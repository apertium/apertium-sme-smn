# -*- coding:utf-8 -*-
# Script that takes a tmx file and for each translation unit <tu>
# takes the source string and translates into the target language.
# The output is a table with the following structure
# source_language original STRING
# target_language original STRING
# target_language Apertium translated STRING
#
# Usage:
# (1) python check_mt-otpt.py
#     - the input dir is tmx_data
# (2) python check_mt-otpt.py -d DIRECTORY_NAME
#     - the input dir is DIRECTORY_NAME
# (3)  python check_mt-otpt.py -f FILE_NAME
#     - the input file is FILE_NAME
#
# the output dir is 'otpt_dir' in the current directory

import re, os, errno, cgi, json, xml
import sys, codecs, locale, getopt
import xml.etree.ElementTree as ET
from subprocess import Popen, PIPE
#from BeautifulSoup import BeautifulStoneSoup
from operator import itemgetter
from xml.dom.minidom import parse, parseString
from os.path import expanduser

def HTMLEntitiesToUnicode(text):
    """Converts HTML entities to unicode.  For example '&amp;' becomes '&'."""
    text = unicode(BeautifulStoneSoup(text, convertEntities=BeautifulStoneSoup.ALL_ENTITIES))
    return text

def unicodeToHTMLEntities(text):
    """Converts unicode to HTML entities.  For example '&' becomes '&amp;'."""
    text = cgi.escape(text).encode('ascii', 'xmlcharrefreplace')
    return text

def indent(elem, level=0):
	i = "\n" + level*"  "
	if len(elem):
		if not elem.text or not elem.text.strip():
			elem.text = i + "  "
		if not elem.tail or not elem.tail.strip():
			elem.tail = i
		for elem in elem:
			indent(elem, level+1)
		if not elem.tail or not elem.tail.strip():
			elem.tail = i
	else:
		if level and (not elem.tail or not elem.tail.strip()):
			elem.tail = i

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="\t")

def getAMT(f,o_dir):
    """Return a XML structure enriched with the Apertium MT output.
    """
    print '... processing ' + str(f)

    cwd = os.getcwd()
    out_dir_path = os.path.join(cwd,o_dir)
    if not os.path.exists(out_dir_path):
        os.mkdir(out_dir_path)

    
    o_root = ET.Element("html")
    o_head = ET.SubElement(o_root, "head")
    o_title = ET.SubElement(o_head, "title")
    o_title.text = str(f)
    o_style = ET.XML(table_style)
    o_head.insert(2,o_style)
    o_body = ET.SubElement(o_root, "body")
    o_body.set("bgcolor", "#ffffff")
    o_p1 = ET.SubElement(o_body, 'p')
    o_p1.text = "File: " + str(f)
    o_hline = ET.SubElement(o_body, 'hline')
    o_table = ET.SubElement(o_body, "table")
    o_table.set('class', 'tg')

    i_tree = ET.parse(f)
    i_root = i_tree.getroot()
    
    i_tu_list = i_root.findall('.//tu')
    for tu in i_tu_list:
        tr_sme = ET.SubElement(o_table, 'tr')
        th_sme = ET.SubElement(tr_sme, 'th')
        th_sme.set('class', 'tg-sme')
        th_sme.text = tu[0][0].text
        
        p = Popen('echo '+tu[0][0].text+cmd, shell=True, stdout=PIPE, stderr=PIPE)
        out, err = p.communicate()
        
        tr_smn = ET.SubElement(o_table, 'tr')
        th_smn = ET.SubElement(tr_smn, 'th')
        th_smn.set('class', 'tg-smn')
        th_smn.text = tu[1][0].text
        
        tr_amt = ET.SubElement(o_table, 'tr')
        th_amt = ET.SubElement(tr_amt, 'th')
        th_amt.set('class', 'tg-amt')
        th_amt.text = out

        
        file_name=os.path.basename(str(f))[:-3]+'html'
        indent(o_root)
        o_tree = ET.ElementTree(o_root)
        o_tree.write(os.path.join(out_dir_path,str(file_name)),
                    xml_declaration=True,encoding='utf-8',
                    method="xml")
    print 'DONE ' + str(f) + '\n\n'

table_style = '<style type="text/css">\n.tg  {border-collapse:collapse;border-spacing:0;}\n.tg td{font-family:Arial, sans-serif;font-size:14px;padding:8px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}\n.tg th{text-align:left;font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:8px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}\n.tg .tg-sme{background-color:#c0c0c0;vertical-align:top;font-weight:bold;}\n.tg .tg-smn{background-color:#efefef;vertical-align:top;font-style:italic;}\n.tg .tg-amt{vertical-align:top;font-style:normal;border-bottom: 2pt solid;}</style>'

# parameters to be adjusted as needed
s_lang = 'sme'
t_lang = 'smn'
atm_dir = '/Users/cipriangerstenberger/aprtm/apertium-sme-smn'
cmd = "| apertium -d " + atm_dir + " " + s_lang + '-' + t_lang
        

def main():
    # parameters to be adjusted as needed
    total = len(sys.argv)

    i_file = ''
    i_dir = 'tmx_data_test'
    o_dir = 'otpt_dir'

    if (total == 3):
        if str(sys.argv[1]) == '-f':
            i_file = str(sys.argv[2])
            if i_file.endswith('tmx'):
                getAMT(i_file,o_dir)
        if str(sys.argv[1]) == '-d':
            i_dir = str(sys.argv[2])
            for root, dirs, files in os.walk(i_dir): # Walk directory tree
                print("Input dir {0} with {1} files ...".format(root, len(files)))
        
                for f in files:
                    if f.endswith('tmx'):
                        getAMT(os.path.join(root,f),o_dir)

    else:
        if (i_file == ''):
            for root, dirs, files in os.walk(i_dir): # Walk directory tree
                print("Input dir {0} with {1} files ...".format(root, len(files)))
        
                for f in files:
                    if f.endswith('tmx'):
                        getAMT(os.path.join(i_dir,f),o_dir)
                
if __name__ == "__main__":
    reload(sys)
    sys.setdefaultencoding("utf-8")
    main()
