#!/bin/bash

DEBUG="FALSE"
SYMBOLS="../syms.txt"
SYMBOLS_OUT="../syms-out.txt"
TRANSDUTORS_DIR="../"
TESTS_FILE="tests.txt"


testCounter=0
IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
for i in $(cat < "$TESTS_FILE"); do
	INPUT[$testCounter]=$(cut -d ';' -f1 <<< $i)
	TRANSDUCTOR[$testCounter]=$(cut -d ';' -f2 <<< $i)
	OUTPUT[$testCounter]=$(cut -d ';' -f3 <<< $i)
	testCounter=$((testCounter+1))
done

for ((i=0;i<$testCounter;i++)); do
	#Make script convert input into a transductor
	TEST_NAME="test_""${TRANSDUCTOR[$i]}"
	RES_NAME="res_""${TRANSDUCTOR[$i]}"
	python word2fst.py -s $SYMBOLS ${INPUT[$i]} > "$TEST_NAME"".txt"
	fstcompile --isymbols=$SYMBOLS --osymbols=$SYMBOLS --keep_isymbols --keep_osymbols   "$TEST_NAME"".txt"   | fstarcsort >  "$TEST_NAME"".fst"
	fstcompose "$TEST_NAME"".fst" "$TRANSDUTORS_DIR""${TRANSDUCTOR[$i]}"".fst" > "$RES_NAME"".fst"
	OUT=$(fstproject --project_output "$RES_NAME"".fst" | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=$SYMBOLS_OUT | awk '{print $3}	' ORS='')
	OUT_PROCESSED=$(echo $OUT | sed -e 's/_/ /g' | xargs)	
	if [ "$OUT_PROCESSED" == "${OUTPUT[$i]}" ]; then 
		echo "PASSED TEST $((i+1)) "
	else
		echo "FAILED TEST $((i+1))"
		echo "EXPECTED: ${OUTPUT[$i]}"
		echo "OBTAINED: $OUT_PROCESSED"
	fi
	
	if [ "$DEBUG" == "TRUE" ]; then echo -n "${INPUT[$i]} ---- ${TRANSDUCTOR[$i]} ----> $OUT_PROCESSED"; fi
	# fstdraw    --isymbols=$SYMBOLS --osymbols=$SYMBOLS --portrait "$RES_NAME"".fst" | dot -Tpdf  > "$RES_NAME"".pdf"
	rm -f "$TEST_NAME"".fst" "$RES_NAME"".fst" "$TEST_NAME"".txt"
	echo ""
	echo ""
done


