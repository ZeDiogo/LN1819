#!/bin/bash

rm -f *.fst *.pdf

################### Palavras ################
#
# Compila e gera a versão gráfica dos transdutores que tem a palavra a traduzir
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms --keep_isymbols --keep_osymbols   perro.txt   | fstarcsort >  perro.fst
echo "Transdutor que representa 'perro' "
fstrmepsilon perro.fst | fsttopsort | fstprint --isymbols=palavras.syms
echo " "

fstcompile --isymbols=palavras.syms --osymbols=palavras.syms --keep_isymbols --keep_osymbols   tortoise.txt   | fstarcsort >  tortoise.fst
echo "Transdutor que representa 'tortoise' "
fstrmepsilon tortoise.fst | fsttopsort | fstprint --isymbols=palavras.syms
echo " "

fstcompile --isymbols=palavras.syms --osymbols=palavras.syms --keep_isymbols --keep_osymbols   rato.txt   | fstarcsort >  rato.fst
echo "Transdutor que representa 'rato' "
fstrmepsilon rato.fst | fsttopsort | fstprint --isymbols=palavras.syms
echo " "


################### Tradutores elementares de Portugues ################
#
# Compila e gera a versão textual do transdutor que traduz Portuguas em Espanhol
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms --keep_isymbols --keep_osymbols   PorEsp.txt  | fstarcsort >  PorEsp.fst
echo "Transdutor que traduz Português em Espanhol"
fstrmepsilon PorEsp.fst | fsttopsort | fstprint  --isymbols=palavras.syms
echo " "

# Compila e gera a versão textual do transdutor que traduz Português em Francês
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms --keep_isymbols --keep_osymbols   PorFra.txt  | fstarcsort >  PorFra.fst
echo "Transdutor que traduz Português em Francês"
fstrmepsilon PorFra.fst | fsttopsort | fstprint --isymbols=palavras.syms
echo " "

# Compila e gera a versão textual do transdutor que traduz Português em Ingês
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms --keep_isymbols --keep_osymbols   PorIng.txt  | fstarcsort --sort_type=ilabel >  PorIng.fst
echo "Transdutor que traduz Português em Ingês"
fstrmepsilon PorIng.fst | fsttopsort | fstprint  --isymbols=palavras.syms
echo " "


################### Tradutores elementares inversos ################
#
# Compila e gera a versão textual do transdutor que traduz Espanhol em Português
fstinvert  PorEsp.fst  >  EspPor.fst
echo "Transdutor que traduz Espanhol em Português"
fstrmepsilon EspPor.fst | fsttopsort | fstprint  --isymbols=palavras.syms
echo " "

# Compila e gera a versão textual do transdutor que traduz Francês em Português
fstinvert  PorFra.fst >  FraPor.fst
echo "Transdutor que traduz Francês em Português"
fstrmepsilon FraPor.fst | fsttopsort | fstprint  --isymbols=palavras.syms
echo " "

# Compila e gera a versão textual do transdutor que traduz Inglês em Português
fstinvert  PorIng.fst >  IngPor.fst
echo "Transdutor que traduz Inglês em Português"
fstrmepsilon IngPor.fst | fsttopsort | fstprint  --isymbols=palavras.syms
echo " "


################### Tradutores Compostos ################
#
# Compila e gera a versao textual do transdutor que traduz Espanhol em Ingles


fstarcsort -sort_type=olabel EspPor.fst > EspPor2.fst
fstarcsort -sort_type=ilabel PorIng.fst > PorIng2.fst
fstcompose EspPor2.fst PorIng2.fst      >   EspIng.fst
echo "Transdutor que traduz Espanhol em Inglês"
fstrmepsilon EspIng.fst | fsttopsort | fstprint  --isymbols=palavras.syms
echo " "


################### Testa os tradutores ################
#
# Compila e gera a versão textual das traduções
fstcompose rato.fst PorFra.fst > souris.fst
echo -n "Em francês, a tradução de 'rato' (português) é: "
fstproject --project_output souris.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'


fstcompose perro.fst EspIng.fst  | fstarcsort > dog.fst
echo -n "Em Inglês, a tradução de 'perro' (espanhol) é: "
fstproject --project_output dog.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose tortoise.fst FraPor.fst  | fstarcsort > tartaruga.fst
echo -n "Em Português, a tradução de 'tortoise' (francês) é: "
fstproject --project_output tartaruga.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'
