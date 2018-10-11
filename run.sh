#!/bin/bash

rm -f *.fst *.pdf

### mmm2mm.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   mmm2mm.txt   | fstarcsort >  mmm2mmBef.fst
fstinvert  mmm2mmBef.fst > mmm2mm.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf
# echo "Transdutor que converte meses de portugues abreviado para numeros no formato MM"
# fstrmepsilon mmm2mm.fst | fsttopsort | fstprint --isymbols=syms-out.txt
# echo " "

### convert days to days
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   day2day.txt   | fstarcsort >  day2day.fst
# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait day2day.fst | dot -Tpdf  > day2day.pdf

### convert year to year
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   year2year.txt   | fstarcsort >  year2year.fst
# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait year2year.fst | dot -Tpdf  > year2year.pdf

### convert / to /
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   bar.txt   | fstarcsort >  bar.fst
# fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait bar.fst | dot -Tpdf  > bar.pdf

### convert misto2numerico
fstconcat day2day.fst bar.fst > 1.fst
fstconcat 1.fst mmm2mm.fst > 2.fst
fstconcat 2.fst bar.fst > 3.fst
fstconcat 3.fst year2year.fst > misto2numerico.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf
rm -f 1.fst 2.fst 3.fst

### convert numeric days to texto
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   dia.txt   | fstarcsort >  diaBef.fst
fstinvert  diaBef.fst > dia.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait dia.fst | dot -Tpdf  > dia.pdf

###	convert numeric month to texto
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   mes.txt   | fstarcsort >  mes.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait mes.fst | dot -Tpdf  > mes.pdf

### convert numeric year to texto
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   ano.txt   | fstarcsort >  ano.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait ano.fst | dot -Tpdf  > ano.pdf

### convert / to de
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   bar2de.txt   | fstarcsort >  bar2de.fst

### convert numerico to texto
fstconcat dia.fst bar2de.fst > 1.fst
fstconcat 1.fst mes.fst > 2.fst
fstconcat 2.fst bar2de.fst > 3.fst
fstconcat 3.fst ano.fst > numerico2texto.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait numerico2texto.fst | dot -Tpdf  > numerico2texto.pdf
rm -f 1.fst 2.fst 3.fst

### en2ptmonth.txt -- convert month en to pt
fstcompile --isymbols=syms.txt --osymbols=syms.txt --keep_isymbols --keep_osymbols   en2ptmonth.txt   | fstarcsort >  en2ptmonth.fst
fstinvert en2ptmonth.fst > pt2enmonth.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait en2ptmonth.fst | dot -Tpdf  > en2ptmonth.pdf

###Invert en2ptmonth to pt2enmonth
###fstinvert  en2ptmonth > pt2enmonth.fst

### convert en2pt
fstconcat day2day.fst bar.fst > 1.fst
fstconcat 1.fst en2ptmonth.fst > 2.fst
fstconcat 2.fst bar.fst > 3.fst
fstconcat 3.fst year2year.fst > en2pt.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait en2pt.fst | dot -Tpdf  > en2pt.pdf
rm -f 1.fst 2.fst 3.

### convert to pt2en
### convert en2pt
fstconcat day2day.fst bar.fst > 1.fst
fstconcat 1.fst pt2enmonth.fst > 2.fst
fstconcat 2.fst bar.fst > 3.fst
fstconcat 3.fst year2year.fst > pt2en.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait pt2en.fst | dot -Tpdf  > pt2en.pdf
rm -f 1.fst 2.fst 

### convert misto to texto
fstconcat dia.fst bar2de.fst > 1.fst
fstcompose mmm2mm.fst mes.fst > mmm2texto.fst
fstconcat 1.fst mmm2texto.fst > 2.fst
fstconcat 2.fst bar2de.fst > 3.fst
fstconcat 3.fst ano.fst > misto2texto.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait misto2texto.fst | dot -Tpdf  > misto2texto.pdf
rm -f 1.fst 2.fst 3.fst
