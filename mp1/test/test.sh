#!/bin/bash

DEBUG="FALSE"
SYMBOLS="../syms.txt"
SYMBOLS_OUT="../syms-out.txt"
TRANSDUTORS_DIR="../"
TESTS_FILE="tests.txt"
INPUT_FILE="input.txt"


### Generate Transductors from input INPUT_FILE
IFS=$'\n'
set -f
for i in $(cat < "$INPUT_FILE"); do
	name=$(cut -d ';' -f1 <<< $i)
	shortName=$(cut -d '_' -f2 <<< $name)
	input=$(cut -d ';' -f2 <<< $i)
	python word2fst.py -s $SYMBOLS $input > "$name"".txt"
	fstcompile --isymbols=$SYMBOLS --osymbols=$SYMBOLS --keep_isymbols --keep_osymbols   "$name"".txt"   | fstarcsort >  "$name"".fst"
	rm -f "$name"".txt"
done

### Parse input transductor, operation transductor and expected output
testCounter=0
IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
for i in $(cat < "$TESTS_FILE"); do
	INPUT[$testCounter]=$(cut -d ';' -f1 <<< $i)
	TRANSDUCTOR[$testCounter]=$(cut -d ';' -f2 <<< $i)
	OUTPUT[$testCounter]=$(cut -d ';' -f3 <<< $i)
	testCounter=$((testCounter+1))
done

### For each test, generate the output tranductor and compare the results to the expected output
for ((i=0;i<$testCounter;i++)); do
	#Make script convert input into a transductor
	number=$(cut -d '_' -f1 <<< ${INPUT[$i]})
	RES_NAME="$number""_""${TRANSDUCTOR[$i]}"

	fstcompose "${INPUT[$i]}"".fst" "$TRANSDUTORS_DIR""${TRANSDUCTOR[$i]}"".fst" > "$RES_NAME"".fst"
	OUT=$(fstproject --project_output "$RES_NAME"".fst" | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=$SYMBOLS_OUT | awk '{print $3}	' ORS='')
	OUT_PROCESSED=$(echo $OUT | sed -e 's/_/ /g' | xargs)	
	if [ "$OUT_PROCESSED" == "${OUTPUT[$i]}" ]; then 
		echo "PASSED TEST $((i+1))"
	else
		echo "FAILED TEST $((i+1))"
		echo "EXPECTED: ${OUTPUT[$i]}"
		echo "OBTAINED: $OUT_PROCESSED"
	fi
	
	if [ "$DEBUG" == "TRUE" ]; then echo -n "${INPUT[$i]} ---- ${TRANSDUCTOR[$i]} ----> $OUT_PROCESSED"; fi
	# fstdraw    --isymbols=$SYMBOLS --osymbols=$SYMBOLS --portrait "$RES_NAME"".fst" | dot -Tpdf  > "$RES_NAME"".pdf"
	echo ""
	echo ""
done


