import sys;

#skibas<adj>	puocâlâs<adj>	0	puocâlâs<adj>	
#skibas<adj>	ravžâ<adj>	0	ravžâ<adj>	

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
