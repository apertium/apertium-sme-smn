import sys;

# Input file (inputfile.tsv):

# addálas<adj>	addalâš<adj>	0	addalâš<adj>	
# addálas<adj>	adelâš<adj>	1	adelâš<adj>
# áli<adv>	ain<adv>	2190	ain<adv>
# áli<adv>	eivi<adv>	9	eivi<adv>
# alitrássi<n>	čuovjisrääsi<n>	0	čuovjisrääsi<n>	
# alitrássi<n>	puáriskállárääsi<n>	0	puáriskállárääsi<n>	

# Usage: 

# $ python3 adding-bidix-ambiguous-to-lrx-by-frequency.py < inputfile.tsv

 

lrx = {};

for line in sys.stdin.readlines(): #{
	if line.count('\t') < 2: #{
		continue;
	#}
	row = line.strip().split('\t');
#	print(row);

	if row[0] not in lrx: #{
		lrx[row[0]] = [];
	#}
	lrx[row[0]].append((row[1], float(row[2])+1.0));
#}

for sl in lrx.keys(): #{
	total = 0.0;
	for tl in lrx[sl]: #{	
		total = total + tl[1];
	#}
	
	for tl in lrx[sl]: #{
		print('<rule weight="%.2f">' % (tl[1]/total));
		sl_lem = sl.split('<')[0];
		tl_lem = tl[0].split('<')[0];
		sl_tags = sl.replace('><','.').split('<')[1].replace('>', '.*');
		tl_tags = tl[0].replace('><','.').split('<')[1].replace('>', '.*');
		print('  <match lemma="%s" tags="%s"><select lemma="%s" tags="%s"/></match>' % (sl_lem, sl_tags, tl_lem, tl_tags));
		print('</rule>');
	#}
	print('');
#}
