<?xml version='1.0'?>

<xsl:stylesheet version="1.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xh="http://www.w3.org/1999/xhtml"
  xmlns:cbd="http://oracc.org/ns/cbd/1.0"
  xmlns:dc="http://dublincore.org/documents/2003/06/02/dces/"
  xmlns:ex="http://exslt.org/common"
  xmlns:g="http://oracc.org/ns/gdl/1.0"
  xmlns:i="http://oracc.org/ns/instances/1.0"
  xmlns:xcl="http://oracc.org/ns/xcl/1.0"
  xmlns:norm="http://oracc.org/ns/norm/1.0"
  xmlns:usg="http://oracc.org/ns/usg/1.0"
  xmlns:xl="http://www.w3.org/1999/xlink"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  extension-element-prefixes="ex"
  exclude-result-prefixes="cbd dc ex g i xl norm xcl usg">

<xsl:import href="html-standard.xsl"/>
<xsl:import href="g2-gdl-HTML.xsl"/>

<xsl:include href="xpd.xsl"/>

<xsl:param name="basename"/>
<xsl:param name="project"/>
<xsl:param name="projectDir"/>
<xsl:param name="imgdir" select="'/epsd/psl/img/'"/>

<xsl:variable name="periods-xis" select="concat('/usr/local/oracc/bld/',$basename,'/',/*/@xml:lang,'/periods.xis')"/>

<xsl:variable name="config-file" select="concat('/usr/local/oracc/xml/',$project,'/config.xml')"/>

<xsl:param name="cbd-article-summaries">
  <xsl:call-template name="xpd-option">
    <xsl:with-param name="config-xml" select="$config-file"/>
    <xsl:with-param name="option" select="'cbd-article-summaries'"/>
    <xsl:with-param name="default" select="'no'"/>
  </xsl:call-template>
</xsl:param>

<xsl:param name="cbd-bases-table">
  <xsl:call-template name="xpd-option">
    <xsl:with-param name="config-xml" select="$config-file"/>
    <xsl:with-param name="option" select="'cbd-bases-table'"/>
    <xsl:with-param name="default" select="'no'"/>
  </xsl:call-template>
</xsl:param>

<xsl:param name="cbd-forms-table">
  <xsl:call-template name="xpd-option">
    <xsl:with-param name="config-xml" select="$config-file"/>
    <xsl:with-param name="option" select="'cbd-forms-table'"/>
    <xsl:with-param name="default" select="'no'"/>
  </xsl:call-template>
</xsl:param>

<xsl:param name="cbd-forms-inline">
  <xsl:call-template name="xpd-option">
    <xsl:with-param name="config-xml" select="$config-file"/>
    <xsl:with-param name="option" select="'cbd-forms-inline'"/>
    <xsl:with-param name="default" select="'yes'"/>
  </xsl:call-template>
</xsl:param>

<xsl:variable name="q">'</xsl:variable>

<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:variable name="summaries-doc" select="concat('/usr/local/oracc/www/',$basename,'/cbd/',/*/@xml:lang,'/summaries.html')"/>

<!--<xsl:strip-space elements="*"/>-->

<xsl:key name="signmap" match="do" use="@from"/>
<xsl:key name="summary-id" match="xh:p" use="@id"/>

<xsl:output method="xml" encoding="utf-8"
   doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
   doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
   indent="no"/>

<xsl:template match="cbd:articles">
  <xsl:message>config-file=<xsl:value-of select="$config-file"/>; cbd-forms-table=<xsl:value-of select="$cbd-forms-table"/></xsl:message>
  <xsl:call-template name="make-html">
    <xsl:with-param name="webtype" select="'cbd'"/>
    <xsl:with-param name="with-hr" select="false()"/>
    <xsl:with-param name="with-trailer" select="false()"/>
    <xsl:with-param name="project" select="$project"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="call-back">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="cbd:letter">
<!--  <div class="letter {$summaries-doc}"> -->
  <div class="letter">
    <xsl:attribute name="name">
      <xsl:call-template name="html-text">
	<xsl:with-param name="text" select="@dc:title"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="id">
      <xsl:call-template name="html-text">
	<xsl:with-param name="text" select="@dc:title"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="cbd:entry">
  <div class="body" name="{concat(/*/@project,'/',/*/@xml:lang,'/',cbd:cf,'[',cbd:gw,']')}">
  <xsl:copy-of select="@xml:id"/>
  <div class="header">
    <h1 class="entry">
      <span class="cf {/*/@xml:lang}">
	<!--      <xsl:value-of select="translate(cbd:cf,$utf8,$html)"/> -->
	<xsl:apply-templates mode="print" select="cbd:cf"/>
      </span>
      <span class="gw">
	<xsl:text> [</xsl:text>
	<xsl:value-of select="translate(cbd:gw,$lower,$upper)"/>
	<xsl:text>]</xsl:text>
      </span>
      <xsl:if test="cbd:phon">
	<span class="phon"><xsl:text>(/</xsl:text>
	<xsl:apply-templates mode="print" select="cbd:phon"/>
	<xsl:text>/)</xsl:text></span>
      </xsl:if>
      <xsl:if test="cbd:pos">
	<xsl:text> </xsl:text>
	<span class="pos"><xsl:value-of select="concat('(',cbd:pos,')')"/></span>
      </xsl:if>
      <xsl:apply-templates mode="print" select="cbd:root"/>
    </h1>
    
    <xsl:if test="@icount > 0">
      <!--    <xsl:variable name="jarg">
	   <xsl:text>'</xsl:text>
	   <xsl:value-of select="concat('dp/',@xml:id,'-dp.html')"/>
	   <xsl:text>'</xsl:text></xsl:variable>
      -->
      <xsl:variable name="pcfgw">
	<xsl:call-template name="escape-quotes">
	  <xsl:with-param name="text" select="substring-after(@dc:title,': ')"/>
	</xsl:call-template>
      </xsl:variable>
      <p class="icount">
	<xsl:call-template name="instref">
	  <xsl:with-param name="instances-only" select="true()"/>
	</xsl:call-template>
      </p>
    </xsl:if>
    
  </div>

  <xsl:apply-templates mode="doit" select="cbd:bffs|cbd:bffs-listed"/>

  <xsl:if test="$cbd-article-summaries = 'yes'">
    <div class="summary">
      <xsl:variable name="xid" select="@xml:id"/>
      <xsl:for-each select="document($summaries-doc,/)">
	<xsl:for-each select="key('summary-id',$xid)/*">
	  <p>
	    <xsl:copy-of select="*|text()"/>
	  </p>
	</xsl:for-each>
      </xsl:for-each>
    <xsl:apply-templates mode="doit" select="cbd:compound|cbd:see-compounds"/>
    </div>
  </xsl:if>

<!--  <xsl:if test="not(cbd:norms)">-->
<!--    <xsl:apply-templates mode="do-forms" select="cbd:forms"/> -->
<!--  </xsl:if>-->

  <xsl:apply-templates select="cbd:bases"/>

  <xsl:if test="$cbd-forms-table = 'yes'">
    <div class="morphology">
      <p>
        <a href="javascript:popxff('{$project}','{@xml:id}')"
	   ><xsl:value-of select="count(cbd:forms/cbd:form[not(@icount='0')])"/> distinct forms attested; click to view forms table.</a>
      </p>
    </div>
  </xsl:if>

  <xsl:if test="not($cbd-forms-inline='no')">
    <xsl:choose>
      <xsl:when test="cbd:form-sanss">
	<xsl:apply-templates select="cbd:form-sanss"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="cbd:forms"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="cbd:norms"/>
    <xsl:apply-templates select="cbd:morphs"/>
  </xsl:if>

  <xsl:apply-templates select="cbd:senses"/>

  <xsl:apply-templates select="cbd:usages"/>

  <xsl:apply-templates select="cbd:bib"/>

<!--

 THIS NEEDS TO BE INTEGRATED WITH SENSES RENDERING

  <xsl:if test="cbd:senses/descendant::i:instances">
    <hr class="instances"/>
    <div class="senseInstances">
      <xsl:apply-templates mode="inst" select="cbd:senses/cbd:sense"/>
    </div>
  </xsl:if>

 -->

<!--
  <xsl:if test="/*/@xml:lang='sux' and not(/*/@n='epsd_cbd_sux')">
    <xsl:variable name="cfgw" select="concat(cbd:cf,'[',cbd:gw,']')"/>
    <p>See ePSD <a href="javascript:pop1art('epsd','sux','{$cfgw}')"><xsl:value-of 
    select="$cfgw"/></a></p>
  </xsl:if>
 -->

  <hr class="article"/>
  </div>
</xsl:template>

<xsl:template mode="print" match="cbd:phon">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template mode="print" match="cbd:cf">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="cbd:forms|cbd:form-sanss"> <!-- mode="do-forms" -->
  <div class="forms">
    <xsl:if test="string-length(ancestor::cbd:entry/cbd:overview/@periods) > 0">
      <p class="periods">
	<span class="iheader">Periods:</span>
	<xsl:variable name="overview" select="ancestor::cbd:entry/cbd:overview/@periods"/>
	<xsl:value-of select="$overview"/>
	<xsl:if test="not(substring($overview,string-length($overview))='.')">
	  <xsl:text>.</xsl:text>
	</xsl:if>
      </p>
    </xsl:if>
    <p class="forms">
      <span class="iheader">Written forms:</span>
      <xsl:for-each select="cbd:form|cbd:form-sans">
	<xsl:apply-templates select="."/>
	<xsl:if test="not(position()=last())">; </xsl:if>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
  </div>
</xsl:template>

<xsl:template match="cbd:form|cbd:form-sans">
  <xsl:choose>
    <xsl:when test="cbd:text">
      <xsl:for-each select="cbd:text">
	<a class="icountu" href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{../@xis}')"><!--@xml:id-->
	  <xsl:apply-templates/>
	</a>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <a class="icountu" 
	 href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
	<xsl:apply-templates/>
      </a>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="cbd:cof-form-norm">
    <span class="cof-form-norm">
      <xsl:text> [</xsl:text>
      <xsl:for-each select="cbd:cof-form-norm">
	<xsl:choose>
	  <xsl:when test="@xis">
	    <a class="icountu" href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')"><!--@xml:id-->
	      <xsl:value-of select="@n"/>
	    </a>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@n"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="not(position()=last())">, </xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:cf|cbd:dcf|cbd:gw|cbd:phon|cbd:pos|cbd:root"/>

<xsl:template match="cbd:compound|cbd:see-compounds"/>

<xsl:template mode="doit" match="cbd:compound">
  <div class="compounds">
    <p class="cpd">
      <xsl:text>(</xsl:text>
      <xsl:for-each select="*">
	<xsl:choose>
	  <xsl:when test="@ref">
  	    <a href="javascript:showarticle('{@ref}.html')">
	      <xsl:call-template name="format-cpd"/>
  	    </a>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="format-cpd"/>
 	  </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="not(position() = last())">
	  <xsl:text> + </xsl:text>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </p>
  </div>
</xsl:template>

<xsl:template name="format-cfgwpos">
  <xsl:value-of select="concat(cbd:cf,' [',cbd:gw,'] ',cbd:pos)"/>
</xsl:template>

<xsl:template name="format-cpd">
  <xsl:value-of select="concat(cbd:cf,'[',cbd:gw)"/>
  <xsl:if test="cbd:sense">
    <xsl:value-of select="concat('//',cbd:sense)"/>
  </xsl:if>
  <xsl:value-of select="concat(']',cbd:pos)"/>
  <xsl:if test="cbd:epos">
    <xsl:value-of select="concat($q,cbd:epos)"/>
  </xsl:if>
  <xsl:if test="cbd:morph">
    <xsl:value-of select="concat('#',cbd:morph)"/>
  </xsl:if>
</xsl:template>

<xsl:template mode="doit" match="cbd:bffs">
  <div class="bffs">
    <p class="bffs">
      <xsl:text>Byform</xsl:text>
      <xsl:if test="count(cbd:bff)>1"><xsl:text>s</xsl:text></xsl:if>
      <xsl:text>: </xsl:text>
      <xsl:for-each select="cbd:bff">
	<a href="javascript:showarticle('{@ref}.html')">
	  <xsl:for-each select="id(@ref)">
	    <xsl:call-template name="format-cfgwpos"/>
	  </xsl:for-each>
	</a>
	<xsl:choose>
	  <xsl:when test="position()=last()">
	    <xsl:text>.</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>; </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </p>
  </div>  
</xsl:template>

<xsl:template mode="doit" match="cbd:bffs-listed">
  <div class="bffs">
    <p class="bffs">
      <xsl:text>Byform of </xsl:text>
      <xsl:for-each select="cbd:bffl[1]">
	<xsl:variable name="ref" select="id(@ref)/ancestor::cbd:entry/@xml:id"/>
	<a href="javascript:showarticle('{$ref}.html')">
	  <xsl:for-each select="id($ref)">
	    <xsl:call-template name="format-cfgwpos"/>
	  </xsl:for-each>
	</a>	
      </xsl:for-each>
    </p>
  </div>
</xsl:template>

<xsl:template mode="doit" match="cbd:see-compounds">
  <div class="compounds">
    <p class="xcpd">
      <xsl:text>See </xsl:text>
      <xsl:for-each select="*">
	<xsl:choose>
	  <xsl:when test="@ref">
  	    <a href="javascript:showarticle('{@ref}.html')">
	      <xsl:apply-templates/>
	    </a>
	  </xsl:when>
	  <xsl:otherwise>
 	    <xsl:apply-templates/>
 	  </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="not(position() = last())">
	  <xsl:text>, </xsl:text>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
  </div>
</xsl:template>

<xsl:template match="cbd:morphs">
  <div class="morphs">
    <span class="iheader">Morphological forms:</span>
    <xsl:choose>
      <xsl:when test="*/*[@morph2]">
	<xsl:for-each select="cbd:morph">
	  <xsl:apply-templates select="."/>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<p class="norms">
	  <xsl:for-each select="cbd:morph">
	    <xsl:apply-templates select="."/>
	  </xsl:for-each>
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="cbd:morph">
  <!--  <xsl:message>g2-HTML-articles.xsl: morph2=<xsl:value-of select="@morph2"/></xsl:message> -->
  <xsl:choose>
    <xsl:when test="string-length(@morph2)>0">
      <p class="morph">
	<xsl:call-template name="cbd-morph-sub"/>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="cbd-morph-sub"/>
      <xsl:if test="position() &lt; last()">
	<span class="punct-sc"><xsl:text>; </xsl:text></span>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cbd:morph2"/>

<xsl:template name="cbd-morph-sub">
  <a class="icountu" 
     href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
    <xsl:value-of select="@n"/>
  </a>
  <xsl:if test="string-length(@morph2)>0">
    <xsl:text> (</xsl:text>
    <xsl:for-each select="id(@morph2)">
      <a class="icountu"
	 href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
	<xsl:value-of select="@n"/>
      </a>
      <xsl:if test="position() &lt; last()">
	<xsl:text>;</xsl:text><br/>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:prefs">
  <p class="norms">
    <span class="iheader">Verbal prefixes:</span>
    <xsl:for-each select="cbd:pref">
      <xsl:apply-templates select="."/>
      <xsl:if test="position() &lt; last()">
	<span class="punct-sc"><xsl:text>; </xsl:text></span>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </p>
</xsl:template>

<xsl:template match="cbd:pref">
  <a class="icountu" 
     href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template mode="print" match="cbd:root">
  <xsl:value-of select="concat(' (&#x221A;',text(),')')"/>
</xsl:template>

<xsl:template match="cbd:stems">
  <xsl:if test="not(@defaulted)">
    <p class="norms">
      <span class="iheader">Stems:</span>
      <xsl:for-each select="cbd:stem">
	<xsl:apply-templates select="."/>
	<xsl:if test="position() &lt; last()">
	  <span class="punct-sc"><xsl:text>; </xsl:text></span>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:stem">
  <a class="icountu" 
     href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
    <xsl:value-of select="@n"/>
  </a>
</xsl:template>

<xsl:template match="cbd:conts">
  <xsl:if test="$cbd-bases-table='no'">
    <p class="norms">
      <span class="iheader">Continuations:</span>
      <xsl:for-each select="cbd:cont">
	<xsl:apply-templates select="."/>
	<xsl:if test="position() &lt; last()">
	  <span class="punct-sc"><xsl:text>; </xsl:text></span>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:cont">
  <a class="icountu" 
     href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
    <xsl:value-of select="@n"/>
  </a>
</xsl:template>

<xsl:template mode="do-it" match="cbd:conts">
  <xsl:if test="*">
    <tr class="orth cont">
      <td class="orthindex">+</td>
      <td class="orth" colspan="2">
      <xsl:for-each select="*">
	<span class="cont">
	  <xsl:text>-</xsl:text>
	  <xsl:value-of select="@n"/>
	  <xsl:call-template name="instref"/>
	</span>
	<xsl:if test="not(position()=last())">
	  <xsl:text>; </xsl:text>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:norms">
  <p class="norms"> <!-- {ancestor-or-self::*[@xml:lang]/@xml:lang}"> -->
    <span class="iheader">Normalized forms:</span>
    <xsl:for-each select="cbd:norm">
      <xsl:apply-templates select="."/>
      <xsl:if test="position() &lt; last()">
	<span class="punct-sc"><xsl:text>; </xsl:text></span>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </p>
</xsl:template>

<!-- icountu is the icount which is unmarked in CSS -->
<xsl:template match="cbd:norm">
  <xsl:choose>
    <xsl:when test="@icount > 0">
      <a class="icountu" href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
	<xsl:call-template name="cbd-norm-1"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="cbd-norm-1"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="cbd:forms">
    <xsl:text> (</xsl:text>
    <xsl:for-each select="cbd:forms/cbd:f">
      <xsl:choose>
	<xsl:when test="@icount > 0">
	  <a class="icountu" href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
	    <xsl:apply-templates select="id(@ref)"/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="id(@ref)"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="not(position()=last())">
	<span class="punct-c"><xsl:text>, </xsl:text></span>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="cbd-norm-1">
    <xsl:choose>
      <xsl:when test="cbd:n/cbd:n">
	<xsl:for-each select="cbd:n/cbd:n">
	  <xsl:choose>
	    <xsl:when test="@secondary='1'">
	      <xsl:text>(</xsl:text>
	      <xsl:apply-templates select="."/>
	      <xsl:text>)</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="."/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:if test="position() &lt; last()">
	    <xsl:text> </xsl:text>
	  </xsl:if>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="cbd:n"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="cbd:bases">
  <xsl:choose>
    <xsl:when test="$cbd-bases-table='no'">
      <xsl:call-template name="bases-para"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="bases-table"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="bases-para">
  <p class="norms">
    <span class="iheader">Base forms:</span>
    <xsl:for-each select="cbd:base">
      <a class="icountu" href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')">
	<xsl:choose>
	  <xsl:when test="cbd:text|cbd:t">
	    <span class="orth1">
	      <xsl:apply-templates select="cbd:text[1]|cbd:t[1]"/>
	    </span>
	    <xsl:if test="count(cbd:text|cbd:t) > 1">
	      <span class="orth2">
		<xsl:text> (</xsl:text>
		<xsl:for-each select="cbd:text[position() > 1]|cbd:t[position() > 1]">
		  <xsl:apply-templates select="."/>
		  <xsl:if test="not(position()=last())">
		    <xsl:text>, </xsl:text>
		  </xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
	      </span>
	    </xsl:if>
	  </xsl:when>
	  <xsl:otherwise>
	    <span class="orth1">
	      <xsl:apply-templates />
	    </span>
	  </xsl:otherwise>
	</xsl:choose>
      </a>
      <xsl:if test="not(position()=last())">
	<xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </p>
</xsl:template>

<xsl:template name="bases-table">
  <div class="orth">
    <table>
      <xsl:for-each select="cbd:base">
	<tr class="orth">
	  <td class="orthindex">
	    <xsl:text>[</xsl:text>
	    <xsl:value-of select="position()"/>
	    <xsl:text>]</xsl:text>
	  </td>
	  <td class="orth">
	    <span class="cuneiform">
	      <xsl:for-each select="cbd:text[1]//*[@g:utf8]">
		<xsl:value-of select="@g:utf8"/>
	      </xsl:for-each>
	    </span>
	  </td>
	  <td class="orth">
	    <span class="orth1">
	      <xsl:apply-templates select="cbd:text[1]"/>
	    </span>
	    <xsl:if test="count(cbd:text) > 1">
	      <span class="orth2">
		<xsl:text> (</xsl:text>
		<xsl:for-each select="cbd:text[position() > 1]">
		  <xsl:apply-templates/>
		  <xsl:if test="not(position()=last())">
		    <xsl:text>, </xsl:text>
		  </xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
	      </span>
	    </xsl:if>
	  </td>
	</tr>
      </xsl:for-each>
      <xsl:apply-templates mode="do-it" select="../cbd:conts"/>
    </table>
    <xsl:call-template name="orth-overview"/>
  </div>
</xsl:template>

<xsl:template name="orth-overview">
  <xsl:if test="*">
    <div class="orth oview">
      <table class="oview">
	<thead>
	  <tr>
	    <th class="ovcorner"></th>
	    <th class="ovyear" title="Proto-Cuneiform">PC</th>
	    <th class="ovyear" title="Early Dynastic">ED IIIa</th>
	    <th class="ovyear" title="Early Dynastic">ED IIIb</th>
	    <th class="ovyear" title="Early Dynastic">Ebla</th>
	    <th class="ovyear" title="Old Akkadian">OAkk</th>
	    <th class="ovyear" title="Lagash II">Lag II</th>
	    <th class="ovyear" title="Ur III">Ur III</th>
	    <th class="ovyear" title="Old Babylonian">OB</th>
	    <th class="ovyear" title="Post-Old Babylonian">Post-OB</th>
	    <th class="ovyear">(unknown)</th>
	  </tr>
	</thead>
	<xsl:for-each select="*">
	  <tr>
	    <xsl:if test="not(position() mod 2)">
	      <xsl:attribute name="class">even</xsl:attribute>
	    </xsl:if>
	    <xsl:choose>
	      <xsl:when test="@icount>0">
		<td class="ovindex">
		  <xsl:call-template name="instref">
		    <xsl:with-param name="content" select="concat('[',position(),']')"/>
		  </xsl:call-template>
		  <!--
		      <a href="javascript:distprof2('{
		      substring-after($og/../../@dc:title,': ')}','{
		      $og/../../@xml:id}','{
		      $og/@ipage}')">
		      <xsl:text>[</xsl:text>
		      <xsl:value-of select="$og/@n"/>
		      <xsl:text>]</xsl:text>
		      </a>
		  -->
		</td>
	      </xsl:when>
	      <xsl:otherwise>
		<td class="ovindex">[<xsl:value-of select="position()"/>]</td>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:variable name="i-id" select="concat(@xis,'.i')"/>
<!--	    <xsl:message>i-id=<xsl:value-of select="$i-id"/>; periods-xis=<xsl:value-of select="$periods-xis"/></xsl:message> -->
	    <xsl:for-each select="document($periods-xis)">
<!--	      <xsl:message>looking for id in <xsl:value-of select="$periods-xis"/>; id function=<xsl:value-of select="id($i-id)"/></xsl:message> -->
	      <xsl:for-each select="id($i-id)/*">
		<td class="ovfreq">
		  <xsl:if test=".>0"><xsl:value-of select="."/></xsl:if>
		</td>
	      </xsl:for-each>
	    </xsl:for-each>
	  </tr>
      </xsl:for-each>
      </table>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:fpar">
<!--  <h2 class="cbd">Morphology</h2> -->
  <div class="morphology">
    <p>
      <a href="javascript:popxff('{ancestor::cbd:entry/@xml:id}')">
	<xsl:value-of select="@icount"/>
	<xsl:text> distinct form</xsl:text>
	<xsl:if test="not(@icount=1)"><xsl:text>s</xsl:text></xsl:if>
	<xsl:text> attested; click to view forms table.</xsl:text>
      </a>
    </p>
  </div>
</xsl:template>

<xsl:template match="cbd:ipar">
  <p class="ipar">
    <span class="iparh">
      <xsl:value-of select="@type"/>
      <xsl:text>: </xsl:text>
    </span>
    <xsl:apply-templates/>
    <xsl:text>.</xsl:text>
  </p>
</xsl:template>

<xsl:template match="cbd:ielt">
  <xsl:if test="position() > 1">
    <xsl:text>; </xsl:text>
  </xsl:if>
  <span class="ielt">
    <xsl:apply-templates/>
    <xsl:call-template name="instref"/>
  </span>
</xsl:template>

<xsl:template match="cbd:senses">
  <xsl:choose>
    <xsl:when test="not(../cbd:pos='PN')">
      <div class="senses">
	<xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="props">
	<xsl:if test="../cbd:prop[@name='gender']">
	  <p span="prop gender"><xsl:value-of select="../cbd:prop[@name='gender']/@value"/><xsl:text>.</xsl:text></p>
	</xsl:if>
	<xsl:if test="../cbd:prop[@name='father']">
	  <p span="prop father"><xsl:text>s. of </xsl:text><xsl:value-of select="../cbd:prop[@name='father']/@value"/><xsl:text>.</xsl:text></p>
	</xsl:if>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cbd:usages">
  <xsl:if test="*">
    <div class="usages">
      <xsl:apply-templates/>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="usg:usage">
  <xsl:variable name="inst-content">
    <xsl:for-each select="usg:cfs/*">
      <xsl:value-of select="."/>
      <xsl:if test="not(position()=last())">
	<xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <p class="usolo">
    <xsl:call-template name="instref">
      <xsl:with-param name="content" select="$inst-content"/>
    </xsl:call-template>  
    <xsl:if test="*/*/usg:trans">
      <xsl:text> = "</xsl:text>
      <xsl:for-each select=".//usg:trans[1]">
	<xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text>"</xsl:text>
    </xsl:if>
  </p>
</xsl:template>

<xsl:template match="cbd:xusages">
  <div class="usages">
    <xsl:for-each select="cbd:u0">
      <p class="usolo">
	<xsl:call-template name="instref">
	  <xsl:with-param name="content" select="ancestor::cbd:cf"/>
	</xsl:call-template>
<!--
	<a href="javascript:distprof2('{substring-after(
		 ancestor::cbd:entry/@dc:title,': ')}','{
		 ancestor::cbd:entry/@xml:id}','{@ref}')">
	<xsl:value-of select="ancestor::cbd:cf"/></a>
 -->
      </p>
    </xsl:for-each>
    <xsl:for-each select="cbd:u1">
      <xsl:variable name="r" select="@ref"/>
      <xsl:for-each select="document('inline-usages.html',/)">
	<xsl:for-each select="id($r)">
	  <xsl:copy-of select="*|text()"/>
	</xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:if test="cbd:u2">
      <p class="uxrefs"><span class="usee">See:</span>
      <xsl:for-each select="cbd:u2">
	<xsl:variable name="r" select="@ref"/>
	<xsl:variable name="last" select="position()=last()"/>
	<xsl:for-each select="document('../../lib/usage-db.xml',/)">
	  <xsl:if test="id($r)">
	    <span>
	      <xsl:attribute name="class">
		<xsl:text>uxref </xsl:text>
		<xsl:choose>
		  <xsl:when test="$last">
		    <xsl:text>refterm</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:text>refsep</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <a href="{substring-before(id($r)/srefs/s[1]/@ref,'.')}.html#u.{id($r)/srefs/s[1]/@ref}">
		<xsl:call-template name="html-text">
		  <xsl:with-param name="text" select="id($r)/@p"/>
		</xsl:call-template>
		<xsl:choose>
		  <xsl:when test="$last">
		    <xsl:text>.</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:text>;</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
	      </a>
	    </span>
	  </xsl:if>
	</xsl:for-each>
      </xsl:for-each>
      </p>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="cbd:sense">
  <xsl:choose>
    <xsl:when test="cbd:subsense">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <h3 class="sense">
	<span class="sensenum">
	  <xsl:value-of select="@num"/>
	</span>
	<xsl:text> </xsl:text>
        <xsl:value-of select="cbd:mng"/>

	<xsl:if test="cbd:pos and not(cbd:pos=../../cbd:pos)">
	  <xsl:value-of select="concat(' (',cbd:pos,') ')"/>
	</xsl:if>

	<xsl:if test="@icount>0">
	  <xsl:call-template name="instref"/>
<!--
	  <xsl:call-template name="print-icount"/>
 -->
	</xsl:if>
<!--
        <xsl:if test="i:instances">
  	  <xsl:message>CHILD0=<xsl:value-of select="i:instances/i:g[1]"/></xsl:message>
        </xsl:if>
 -->
<!-- 
       <xsl:call-template name="count-instances">
	  <xsl:with-param name="g" select="i:instances/i:g[1]"/>
	</xsl:call-template>
 -->
      </h3>
<!--      <xsl:apply-templates select="cbd:usages"/> -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
<xsl:template name="print-icount">
  <a class="icount" 
	href="javascript:distprof2('{substring-after(
			ancestor::cbd:entry/@dc:title,': ')}','{
			ancestor::cbd:entry/@xml:id}','{
			@ipage}')">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="concat(@icount,'x/',@ipct,'%')"/>
    <xsl:text>)</xsl:text>
  </a>
</xsl:template>
-->

<xsl:template mode="inst" match="cbd:sense">
  <xsl:choose>
    <xsl:when test="cbd:subsense">
      <xsl:if test="descendant::i:instances">
        <xsl:apply-templates mode="inst"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="i:instances"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cbd:subsense">
  <li>
    <xsl:choose>
      <xsl:when test="cbd:subsubsense">
        <ol>
 	  <xsl:apply-templates/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <span class="mng"><xsl:value-of select="cbd:mng"/></span>
<!--        <xsl:call-template name="count-instances"/> -->
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

<xsl:template match="cbd:subsubsense">
  <span class="mng"><xsl:value-of select="cbd:mng"/></span>
<!--  <xsl:call-template name="count-instances"/> -->
</xsl:template>

<!--
<xsl:template name="count-instances">
  <xsl:param name="g" select=".//i:g"/>
  <xsl:variable name="n" select="count($g/i:i)"/>
  <xsl:if test="$n > 0">
    <xsl:value-of select="concat(' [',$n,']')"/>
  </xsl:if>
</xsl:template>
-->

<xsl:template match="i:instances">
  <div class="instances">
    <h1 class="instances">
      <xsl:value-of select="../@num"/>
      <xsl:text>&#xa0;</xsl:text>
      <xsl:value-of select="../cbd:mng"/>
    </h1>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="i:g">
  <div class="g{1+count(ancestor::i:g)}">
    <xsl:choose>
      <xsl:when test="i:g">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="i:h"/>
	<xsl:choose>
	  <xsl:when test="i:i">
	    <p class="instances"><xsl:apply-templates select="i:i"/></p>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="i:a"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="i:h">
  <xsl:element name="{concat('h',1+count(ancestor::i:g))}">
    <xsl:attribute name="class"><xsl:text>instances</xsl:text></xsl:attribute>
    <span class="{@class}">
      <xsl:apply-templates/>
    </span>
  </xsl:element>
</xsl:template>

<xsl:template match="i:a">
  <p class="xref"><a href="{@xl:href}"><xsl:apply-templates/></a></p>
</xsl:template>

<xsl:template match="i:span">
  <span class="{@class}"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="i:i">
  <xsl:variable name="url">
    <xsl:text>/epsd/corpus/epsd/</xsl:text>
    <xsl:value-of select="substring-before(@u,'.')"/>
    <xsl:text>.html#</xsl:text>
    <xsl:value-of select="substring-after(@u,'.')"/>
  </xsl:variable>
  <a href="javascript:popepsdref('{$url}')"
	  ><xsl:value-of select="@n"/></a>
  <xsl:choose>
    <xsl:when test="position()=last()"><xsl:text>.</xsl:text></xsl:when>
    <xsl:otherwise><xsl:text>;&#xa;</xsl:text></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cbd:s"/>
<xsl:template match="cbd:t">
  <xsl:apply-templates/>
  <xsl:if test="@rws">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="translate(@rws,$lower,$upper)"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="cbd:equivs">
  <div class="equivs">
    <p>
      <!-- FIXME: equivs need to be grouped by lang so we can emit, e.g., Akk. only
      once -->
      <xsl:value-of select="concat(translate(substring(*[1]/@xml:lang,1,1),$lower,$upper),
			    substring(*[1]/@xml:lang,2),'. ')"/>
      <xsl:for-each select="cbd:equiv">
        <span class="{@xml:lang}"><xsl:apply-templates select="cbd:term"/></span>
  	<xsl:if test="string-length(cbd:mean) > 0">
          <span class="mean"> &quot;<xsl:apply-templates 
				select="cbd:mean"/>&quot;</span>
        </xsl:if>
 	<xsl:choose>
          <xsl:when test="not(position() = last())">
    	    <xsl:text>; </xsl:text>
          </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>.</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>	
      </xsl:for-each>
    </p>
  </div>
</xsl:template>

<xsl:template match="cbd:equiv">
  <span class="{@xml:lang}"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="cbd:bib">
  <div class="bib"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="cbd:ref">
  <p class="ref">
    <span class="refyear">[<xsl:value-of select="@year"/>]</span>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="cbd:outlink">
  <p class="outlink">
    <span class="outwhere"><xsl:text>See </xsl:text>
	<xsl:value-of select="@name"/><xsl:text>: </xsl:text></span>
    <xsl:for-each select="cbd:link">
      <a class="outlink" href="javascript:outlink('ol{../@name}','{@xl:href}')">
	<xsl:apply-templates/>
      </a>
      <xsl:if test="not(position() = last())"><xsl:text>; </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </p>
</xsl:template>

<xsl:template match="cbd:sup">
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<xsl:template name="instref">
  <xsl:param name="content" select="''"/>
  <xsl:param name="instances-only" select="false()"/>
  <xsl:param name="label" select="''"/>

  <xsl:variable name="ilabel">
    <xsl:choose>
      <xsl:when test="string-length($label) > 0">
	<xsl:value-of select="$label"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test="$instances-only">
	  <xsl:choose>
	    <xsl:when test="@icount = 1"> instance</xsl:when>
	    <xsl:otherwise> instances</xsl:otherwise>
	  </xsl:choose>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <a class="icount" href="javascript:distprof2('{$basename}','{/*/@xml:lang}','{@xis}')"> <!--@xml:id-->
    <xsl:choose>
      <xsl:when test="string-length($content)>0">
	<xsl:value-of select="$content"/>
      </xsl:when>
      <xsl:when test="$instances-only">
	<xsl:value-of select="@icount"/>
	<xsl:value-of select="$ilabel"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="concat(@icount,'x/',@ipct,'%')"/>	
	<xsl:value-of select="$ilabel"/>
	<xsl:text>)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

</xsl:stylesheet>
