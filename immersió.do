********************************************
*********** SUPORT A LA IMMERSIÓ ***********
********************************************

********************************************
************** Marc Guinjoan ***************
****** Universitat Oberta de Catalunya *****
********************************************

import spss using "http://upceo.ceo.gencat.cat/wsceop/8228/Microdades%20anonimitzades_1010.sav", clear

**Recodificacions
recode  MESURA_PROM_CAT_IMMERSIO (1 2=1 "A favor") (3 4=0 "En contra") (*=.), gen(immersio)

recode LLENGUA_PROPIA (1=1 "Català") (2=2 "Castellà") (3 80=3 "Bilingüe i altres") (*=.), gen(llengua)
label variable llengua "Llengua pròpia"

recode IDEOL_0_10 (98/99=.), gen(ideol)

recode ideol (0/2=1 "Ext.esq") (3/4=2 "Esq") (5=3 "Centre") (6/7=4 "Dr") (8/10=5 "Ext.dr"), gen(ideol5)
label variable ideol5 "Ideologia"

recode SENTIMENT_PERTINENCA (98/99=.), gen(ins)

recode REC_PARLAMENT_VOT_CENS_R (80/97=80 "Altres, blanc, nul") (96=96 "Abstenció") (98/99=.), gen(partit)

recode LLOC_NAIX (3/4=3), gen(naixement)

rename EDAT_GR edat5
label define edat5 1 "16 a 24" 2 "25 a 34" 3 "35 a 49" 4 "50 a 64" 5 "+64"
label values edat5 edat5

****************

**Model complet 

logit immersio i.ideol5  // R2=0.18
logit immersio i.llengua   // R2= 0.19
logit immersio i.naixement  //  R2=0.04
logit immersio i.ins  // R2 = 0.31
logit immersio i.edat5  // R2=0

logit immersio i.ideol5 i.llengua i.naixement  // ideologia i identitat

margins, at(llengua=(1 2 3))
marginsplot, title(Suport immersió per llengua pròpia) ytitle("Percentatge de suport", height(5)) xtitle(, height(5)) xlabel(1 "Català" 2 "Castellà" 3 `""Bilíngüe  ""i altres  ""') sch(s1mono) scale(0.9) name(llengua, replace)
graph export llengua.png, replace

****************

**Per grups d'edat i ideologia

global addplot "addplot(hist edat5 if e(sample) , bin(9) yaxis(2) percent yscale(alt axis(2)) ytitle("", axis(2)) ylabel("", axis(2)) bcolor() color(%6) ) xtitle(, height(5)) legend(off)"

logit immersio i.ideol5 i.naixement i.edat5 if llengua==1
margins, at(edat5=(1 (1) 5))
marginsplot, title(Catalanoparlants) ytitle(Support immersió) sch(s1mono) scale(0.9) xsize(2) ysize(2) $addplot name(cat_ed, replace)

logit immersio i.ideol5 i.naixement i.edat5  if llengua==2
margins, at(edat5=(1 (1) 5))
marginsplot, title(Castellanoparlants) ytitle(Support immersió) sch(s1mono) scale(0.9) xsize(2) ysize(2) $addplot name(cast_ed, replace)

logit immersio i.ideol5 i.naixement i.edat5  if llengua==3
margins, at(edat5=(1 (1) 5))
marginsplot, title(Bilingües) ytitle(Support immersió) sch(s1mono) scale(0.9) xsize(2) ysize(2) $addplot name(bil_ed, replace)

graph combine cat_ed cast_ed bil_ed, col(2) ycommon sch(s1mono) name(edat, replace)
graph export edat.png, replace
graph close *_ed

**Per llengua i ideologia

global addplot "addplot(hist ideol5 if e(sample) , bin(9) yaxis(2) percent yscale(alt axis(2)) ytitle("", axis(2)) ylabel("", axis(2)) bcolor() color(%6) ) xtitle(, height(5)) legend(off)"

logit immersio i.ideol5 i.naixement if llengua==1
margins, at(ideol5=(1 (1) 5))
marginsplot, title(Catalanoparlants) ytitle(Support immersió) sch(s1mono) scale(0.9) xsize(2) ysize(2) $addplot name(cat_id, replace)

logit immersio i.ideol5 i.naixement if llengua==2
margins, at(ideol5=(1 (1) 5))
marginsplot, title(Castellanoparlants) ytitle(Support immersió) sch(s1mono) scale(0.9) xsize(2) ysize(2) $addplot name(cast_id, replace)

logit immersio i.ideol5 i.naixement if llengua==3
margins, at(ideol5=(1 (1) 5))
marginsplot, title(Bilingües) ytitle(Support immersió) sch(s1mono) scale(0.9) xsize(2) ysize(2) $addplot name(bil_id, replace)

graph combine cat_id cast_id bil_id, col(2) ycommon sch(s1mono) name(ideologia, replace)
graph export ideologia.png, replace
graph close *_id
