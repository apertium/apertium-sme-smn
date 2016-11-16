<?xml version="1.0"?>
<!--+
    | Usage: java -Xmx2048m net.sf.saxon.Transform -it main THIS_FILE inDir=DIR
    | 
    +-->

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs xhtml">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" name="xml"
	      encoding="UTF-8"
	      omit-xml-declaration="no"
	      indent="yes"/>

  <xsl:output method="xml" name="tmx"
	      encoding="UTF-8"
	      omit-xml-declaration="no"
	      indent="yes"/>

  <xsl:output method="text" name="txt"
              encoding="UTF-8"/>

  <xsl:output method="html" name="html"
              encoding="UTF-8"
              version="4.0"
              indent="yes"/>

  <xsl:param name="inFile_1" select="'1-2016/sme_src.txt'"/>
  <xsl:variable name="ffParsed_1" select="unparsed-text($inFile_1)"/>
  <xsl:variable name="ffLines_1" select="tokenize($ffParsed_1, '&#xa;')" as="xs:string+"/>

  <xsl:param name="inFile_2" select="'1-2016/smn_mt.txt'"/>
  <xsl:variable name="ffParsed_2" select="unparsed-text($inFile_2)"/>
  <xsl:variable name="ffLines_2" select="tokenize($ffParsed_2, '&#xa;')" as="xs:string+"/>

  <xsl:param name="inFile_3" select="'1-2016/MTeval_MLO.txt'"/>
  <xsl:variable name="ffParsed_3" select="unparsed-text($inFile_3)"/>
  <xsl:variable name="ffLines_3" select="tokenize($ffParsed_3, '&#xa;')" as="xs:string+"/>

  <xsl:param name="inFile_4" select="'1-2016/MTeval_IM.txt'"/>
  <xsl:variable name="ffParsed_4" select="unparsed-text($inFile_4)"/>
  <xsl:variable name="ffLines_4" select="tokenize($ffParsed_4, '&#xa;')" as="xs:string+"/>

  <xsl:param name="inFile_5" select="'1-2016/MTeval_PM.txt'"/>
  <xsl:variable name="ffParsed_5" select="unparsed-text($inFile_5)"/>
  <xsl:variable name="ffLines_5" select="tokenize($ffParsed_5, '&#xa;')" as="xs:string+"/>

  <xsl:param name="inFile_6" select="'1-2016/MTeval_MS.txt'"/>
  <xsl:variable name="ffParsed_6" select="unparsed-text($inFile_6)"/>
  <xsl:variable name="ffLines_6" select="tokenize($ffParsed_6, '&#xa;')" as="xs:string+"/>

  <xsl:param name="utFileName" select="'sme2smn_mt_eval_201601'"/>

  <xsl:param name="outDir" select="'out_html'"/>
  <xsl:variable name="of" select="'html'"/>
  <xsl:variable name="e" select="$of"/>
  <xsl:variable name="debug" select="false()"/>
  <xsl:variable name="nl" select="'&#xa;'"/>
  <xsl:variable name="sr" select="'\*'"/>
  <xsl:variable name="rarrow" select="'▸'"/>
  <xsl:variable name="tb" select="'&#x9;'"/>
  <xsl:variable name="orc" select="'￼'"/>
  <xsl:variable name="apo">'</xsl:variable>
  <xsl:variable name="vCaps" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="ids" select="'SRC_AMT_MLO_IM_PM_MS'"/>
  <xsl:variable name="with_id" select="false()"/>

  <xsl:template match="/" name="main">

    <xsl:if test="not(count($ffLines_1)=count($ffLines_2) or
		  count($ffLines_1)=count($ffLines_3) or
		  count($ffLines_1)=count($ffLines_4) or
		  count($ffLines_1)=count($ffLines_5) or
		  count($ffLines_1)=count($ffLines_6))">
      <xsl:message terminate="yes">
        <xsl:value-of select="'the input files do not have the same number of lines'"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="count($ffLines_1)=count($ffLines_2) and
		  count($ffLines_1)=count($ffLines_3) and
		  count($ffLines_1)=count($ffLines_4) and
		  count($ffLines_1)=count($ffLines_5) and
		  count($ffLines_1)=count($ffLines_6)">
      <xsl:message terminate="no">
        <xsl:value-of select="concat('input files: ', $inFile_1, ' and ', $inFile_2)"/>
      </xsl:message>
    </xsl:if>
    
    <xsl:result-document href="{$outDir}/{$utFileName}.{$of}" format="{$of}">
      <html>
	<head>
	  <title>MT sme2smn evaluation January 2016</title>
	      <style type="text/css">
		.tg  {border-collapse:collapse;border-spacing:0;}
		.tg td{font-family:Arial, sans-serif;font-size:14px;padding:8px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
		.tg th{text-align:left;font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:8px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
		.tg .tg-sme{background-color:#c0c0c0;vertical-align:top;font-weight:bold;}
		.tg .tg-smn{background-color:#efefef;vertical-align:top;font-style:italic;}
		.tg .tg-mlo{vertical-align:top;font-style:normal;}
		.tg .tg-im{background-color:#efefef;vertical-align:top;font-style:normal;}
		.tg .tg-pm{vertical-align:top;font-style:normal;}
		.tg .tg-ms{background-color:#efefef;vertical-align:top;font-style:normal;border-bottom: 2pt solid;}
	      </style>
	</head>
	<body bgcolor="#ffffff">
	  <p><b>MT sme2smn evaluation January 2016</b></p>
	  <hline />
	  <table class="tg">
	    <xsl:for-each select="$ffLines_1">
	      <xsl:if test="not(normalize-space(replace(., $orc, ' '))='')">
		<xsl:message terminate="no">
		  <xsl:value-of select="normalize-space(.)"/>
		</xsl:message>
		<xsl:variable name="c_pos" select="position()"/>
		<xsl:variable name="s_1" select="normalize-space(replace(., $orc, ' '))"/>
		<xsl:variable name="s_2" select="normalize-space(replace($ffLines_2[$c_pos], $orc, ' '))"/>
		<xsl:variable name="s_3" select="normalize-space(replace($ffLines_3[$c_pos], $orc, ' '))"/>
		<xsl:variable name="s_4" select="normalize-space(replace($ffLines_4[$c_pos], $orc, ' '))"/>
		<xsl:variable name="s_5" select="normalize-space(replace($ffLines_5[$c_pos], $orc, ' '))"/>
		<xsl:variable name="s_6" select="normalize-space(replace($ffLines_6[$c_pos], $orc, ' '))"/>
		<tr>
		  <th class="tg-sme">
		    <xsl:value-of select="concat($c_pos,'.')"/>
		  </th>
		  <xsl:if test="$with_id">
		    <td class="tg-sme">
		      <xsl:value-of select="(tokenize($ids,'_'))[1]"/>
		    </td>
		  </xsl:if>
		  <td class="tg-sme">
		    <xsl:value-of select="$s_1"/>
		  </td> 
		</tr>
		<tr>
		  <th class="tg-smn"> 	      </th>
		  <xsl:if test="$with_id">
		    <td class="tg-smn">
		      <xsl:value-of select="(tokenize($ids,'_'))[2]"/>
		    </td>
		  </xsl:if>
		  <td class="tg-smn">
		    <xsl:value-of select="$s_2"/>
		  </td> 
		</tr>
		<tr>
		  <th class="tg-mlo"> 	      </th>
		  <xsl:if test="$with_id">
		    <td class="tg-mlo">
		      <xsl:value-of select="(tokenize($ids,'_'))[3]"/>
		    </td>
		  </xsl:if>
		  <td class="tg-mlo">
		    <xsl:value-of select="$s_3"/>
		  </td> 
		</tr>
		<tr>
		  <th class="tg-im"> 	      </th>
		  <xsl:if test="$with_id">
		    <td class="tg-im">
		      <xsl:value-of select="(tokenize($ids,'_'))[4]"/>
		    </td>
		  </xsl:if>
		  <td class="tg-im">
		    <xsl:value-of select="$s_4"/>
		  </td>
		</tr>
		<tr>
		  <th class="tg-pm"> 	      </th>
		  <xsl:if test="$with_id">
		    <td class="tg-pm">
		      <xsl:value-of select="(tokenize($ids,'_'))[5]"/>
		    </td>
		  </xsl:if>
		  <td class="tg-pm">
		    <xsl:value-of select="$s_5"/>
		  </td>
		</tr>
		<tr>
		  <th class="tg-ms"> 	      </th>
		  <xsl:if test="$with_id">
		    <td class="tg-ms">
		      <xsl:value-of select="(tokenize($ids,'_'))[6]"/>
		    </td>
		  </xsl:if>
		  <td class="tg-ms">
		    <xsl:value-of select="$s_6"/>
		  </td>
		</tr>
	      </xsl:if>
	    </xsl:for-each>
	  </table>
	</body>
      </html>
    </xsl:result-document>
  </xsl:template>
</xsl:stylesheet>
