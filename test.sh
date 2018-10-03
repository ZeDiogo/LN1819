#!/bin/bash

# TESTING
# mmm2mm
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   testmmm2mm.txt   | fstarcsort >  testmmm2mm.fst
fstcompose testmmm2mm.fst mmm2mm.fst > resmmm2mm.fst
echo -n "O resultado da conversao de SET em numero: "
fstproject --project_output resmmm2mm.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}	' ORS=''
# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait resSET.fst | dot -Tpdf  > resSET.pdf
rm -f testmmm2mm.fst resmmm2mm.fst
echo ""

# misto2numerico
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   testMisto2numerico.txt   | fstarcsort >  testMisto2numerico.fst
fstcompose testMisto2numerico.fst misto2numerico.fst > resMisto2numerico.fst
echo -n "O resultado da conversao de 15/SET/2018: "
fstproject --project_output resMisto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}	' ORS=''
rm -f testMisto2numerico.fst resMisto2numerico.fst
echo ""