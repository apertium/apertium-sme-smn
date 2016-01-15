#!/usr/bin/perl -w
use utf8 ;

# Simple script to convert csv to bidix
# For input/outpus examples, see below.


while (<>) 
{
	chomp ;
# verbs
#	my ($lemma, $ivtv, $transl) = split /\t/ ;
#	print STDOUT "    <e><p><l>$lemma<s n=\"vblex\"/><s n=\"$ivtv\"/></l><r>$transl<s n=\"vblex\"/></r></p></e>\n" ;

# others
	my ($lemma, $transl) = split /\t/ ;
	print STDOUT "    <e><p><l>$lemma<s n=\"adj\"/></l><r>$transl<s n=\"adj\"/></r></p></e>\n" ;
}




# Example input:
#
# aampumakenttä	N	skytefelt

