Inclui-se um programa escrito em python que pode ser útil para a elaboração do trabalho.


word2fst.py - dada uma palavra, permite gerar um transdutor correspondente a essa palavra. Exemplos:


./word2fst.py pedro
    0 1 p p
    1 2 e e
    2 3 d d
    3 4 r r
    4 5 o o
    5

./word2fst.py -s symbols.txt 2/set
    0 1 2 2
    1 2 / /
    2 3 set set
    3


