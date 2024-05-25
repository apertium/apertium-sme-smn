# kjøres i dev-mappa:
# sh sme_bidix_sanity.sh

HLOOKUP=$(echo $HLOOKUP)

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep vblex |grep '"tv"' |cut -d '>' -f7 | sort -u > tvverbs 
cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep vblex |grep '"iv"' |cut -d '>' -f7 | sort -u > ivverbs
cat tvverbs |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+TV' | cut -f2 | cut -d '+' -f1 |sort -u > gentv 
cat ivverbs |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+IV' | cut -f2 | cut -d '+' -f1 |sort -u > geniv 
echo 'The verb is not in the sme-FST or has wrong transitivity in dix:' > missingsme.txt
echo '' >> missingsme.txt
comm -23 tvverbs gentv | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt
comm -23 ivverbs geniv | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"n"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > nouns 
cat nouns |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+N+' | cut -f2 | cut -d '+' -f1 |sort -u > gennouns 
echo '' >> missingsme.txt
echo 'Nouns:' >> missingsme.txt
comm -23 nouns gennouns | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"adv"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 |grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > advs 
cat advs |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Adv' | cut -f2 | cut -d '+' -f1 |sort -u > genadvs 
echo '' >> missingsme.txt
echo 'Adverbs:' >> missingsme.txt
comm -23 advs genadvs | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt


cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"adj"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > adjs 
cat adjs |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+A+' | cut -f2 | cut -d '+' -f1 |sort -u > genadjs 
echo '' >> missingsme.txt
echo 'Adjectives:' >> missingsme.txt
comm -23 adjs genadjs | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"post"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > post 
cat post |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Po' | cut -f2 | cut -d '+' -f1 |sort -u > genpost 
echo '' >> missingsme.txt
echo 'Post:' >> missingsme.txt
comm -23 post genpost | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"pr"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > pre 
cat pre |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Pr' | cut -f2 | cut -d '+' -f1 |sort -u > genpre 
echo '' >> missingsme.txt
echo 'Prep:' >> missingsme.txt
comm -23 pre genpre | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"num"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > num 
cat num |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Num' | cut -f2 | cut -d '+' -f1 |sort -u > gennum 
echo '' >> missingsme.txt
echo 'Num:' >> missingsme.txt
comm -23 num gennum | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"prn"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > prn 
cat prn |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Pron' | cut -f2 | cut -d '+' -f1 |sort -u > genprn 
echo '' >> missingsme.txt
echo 'Pronouns:' >> missingsme.txt
comm -23 prn genprn | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"cnjcoo"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > cnjcoo 
cat cnjcoo |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+CC' | cut -f2 | cut -d '+' -f1 |sort -u > gencnjcoo 
echo '' >> missingsme.txt
echo 'cnjcoo:' >> missingsme.txt
comm -23 cnjcoo gencnjcoo | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"cnjsub"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > cnjsub 
cat cnjsub |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+CS' | cut -f2 | cut -d '+' -f1 |sort -u > gencnjsub 
echo '' >> missingsme.txt
echo 'cnjsub:' >> missingsme.txt
comm -23 cnjsub gencnjsub | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"pcle"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > pcle 
cat pcle |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Pcle' | cut -f2 | cut -d '+' -f1 |sort -u > genpcle 
echo '' >> missingsme.txt
echo 'Particles:' >> missingsme.txt
comm -23 pcle genpcle | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt

cat ../apertium-sme-smn.sme-smn.dix | tr '<' '>' | cut -d '>' -f1-10 |grep '"np"' |sed 's/>b\/>/%/g' |cut -d '>' -f7 | grep '[a-zščá][a-zščá]' |tr '%' ' ' | sort -u > proper 
cat proper |$HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol |grep '+Prop' | cut -f2 | cut -d '+' -f1 |sort -u > genproper 
echo '' >> missingsme.txt
echo 'Propernouns:' >> missingsme.txt
comm -23 proper genproper | $HLOOKUP -q  $GTLANGS/lang-sme/src/fst/analyser-gt-desc.hfstol >> missingsme.txt
rm  tvverbs ivverbs  gentv geniv nouns gennouns advs genadvs adjs genadjs post genpost pre genpre num gennum prn genprn cnjcoo gencnjcoo cnjsub gencnjsub pcle genpcle proper genproper  


open missingsme.txt

