#!/bin/bash


################### letras ################
#
# Compila e gera a versão gráfica do transdutor que tem "potato"
fstcompile --isymbols=letras.sym --osymbols=letras.sym  potato.txt | fstarcsort > potato.fst
fstdraw    --isymbols=letras.sym --osymbols=letras.sym --portrait potato.fst | dot -Tpdf  > potato.pdf

fstcompile --isymbols=letras.sym --osymbols=letras.sym  cabbage.txt | fstarcsort > cabbage.fst
fstdraw    --isymbols=letras.sym --osymbols=letras.sym --portrait cabbage.fst | dot -Tpdf  > cabbage.pdf

fstcompile --isymbols=letras.sym --osymbols=letras.sym  onion.txt | fstarcsort > onion.fst
fstdraw    --isymbols=letras.sym --osymbols=letras.sym --portrait onion.fst | dot -Tpdf  > onion.pdf


################### Tradutores de tradução ################
#
# Compila e gera a versão gráfica do transdutor que traduz letra a letra
fstcompile --isymbols=letras.sym --osymbols=letras.sym trad.txt | fstarcsort > trad.fst
fstdraw    --isymbols=letras.sym --osymbols=letras.sym --portrait trad.fst | dot -Tpdf  > trad.pdf


################### Testa os tradutores ################
#
# Compila e gera a versão gráfica do transdutor que traduz Inglês em Português
fstcompose potato.fst trad.fst > batata.fst
fstdraw --isymbols=letras.sym --osymbols=letras.sym --portrait batata.fst | dot -Tpdf > batata.pdf

fstcompose cabbage.fst trad.fst > couve.fst
fstdraw --isymbols=letras.sym --osymbols=letras.sym --portrait couve.fst | dot -Tpdf > couve.pdf

fstcompose onion.fst trad.fst > cebola.fst
fstdraw --isymbols=letras.sym --osymbols=letras.sym --portrait cebola.fst | dot -Tpdf > cebola.pdf
