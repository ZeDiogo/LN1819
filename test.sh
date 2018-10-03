#!/bin/bash

# TESTING
# SET
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   testSET.txt   | fstarcsort >  testSET.fst
fstcompose testSET.fst mmm2mm.fst > resSET.fst
echo -n "O resultado da conversao de SET em numero: "
fstproject --project_output resSET.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}	'