#!/bin/bash

rm -f *.fst *.pdf

# mmm2mm.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   mmm2mm.txt   | fstarcsort >  mmm2mm.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf
echo "Transdutor que converte meses de portugues abreviado para numeros no formato MM"
fstrmepsilon mmm2mm.fst | fsttopsort | fstprint --isymbols=syms-out.txt
echo " "


