echo 'Documenting choose-parts in macros' > /tmp/doculist

egrep '(<def-macro|"M\[)' apertium-sme-smn.sme-smn.t1x |cut -d '"' -f2 |sed 's/^/¢/' |sed 's/¢M/M/' |tr '¢' '\n' >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo ' ' >> /tmp/doculist

echo 'Rules:' >> /tmp/doculist

grep 'rule c.*\[' apertium-sme-smn.sme-smn.t1x | grep -v '^<\!' |cut -d '"' -f2   > /tmp/rules
echo 'Rules concerning all parts of speech:' >> /tmp/doculist
grep '\-X ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for verbals:' >> /tmp/doculist
grep '\-V ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for predicates:' >> /tmp/doculist
grep '\-PRED ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for adjectives:' >> /tmp/doculist
grep '\-A ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for bare nouns and pronouns:' >> /tmp/doculist
grep '\-N ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for noun phrases:' >> /tmp/doculist
grep '\-NP ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for numeral expressions and quantifier phrases:' >> /tmp/doculist
grep '\-NUM ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for adverbs:' >> /tmp/doculist
grep '\-ADV ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for P phrases:' >> /tmp/doculist
grep '\-PP ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Rules for other phrases:' >> /tmp/doculist
grep '\-PHR ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Small word classes:' >> /tmp/doculist
grep '\-FOC ' /tmp/rules |rev | sort | rev >> /tmp/doculist
grep '\-CC ' /tmp/rules |rev | sort | rev >> /tmp/doculist
grep '\-CS ' /tmp/rules |rev | sort | rev >> /tmp/doculist
grep '\-IJ ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Technical things:' >> /tmp/doculist
grep '\-T ' /tmp/rules |rev | sort | rev >> /tmp/doculist
echo ' ' >> /tmp/doculist
echo 'Unclassified:' >> /tmp/doculist
grep '\-XXX ' /tmp/rules |rev | sort | rev >> /tmp/doculist
see /tmp/doculist
