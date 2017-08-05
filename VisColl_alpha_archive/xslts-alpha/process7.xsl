<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:co="http://www.schoenberginstitute.org/schema/collation"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns="http://www.schoenberginstitute.org/schema/collation" exclude-result-prefixes="co"
    version="2.0">

    <xsl:output method="text"/>
    <xsl:output method="html" indent="yes" name="html"/>


    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from process6.xsl or process6-arch.xsl.
                It generates the several HTML files that make up a collation site for a manuscript.
                Note that although this document can handle quires containing up to 16 folios, the diagrams
                for quires with 14 and 16 folios will be cut off at the bottom.
                Congratulations! You are done!
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="co:quires">
        <xsl:variable name="idno" select="@idno"/>
        <xsl:variable name="msname" select="@msname"/>
        <xsl:variable name="idnoPart" select="substring($idno,2)"/>
        <xsl:variable name="baseurl">
            <xsl:choose>
                <xsl:when test="starts-with($idno,'W')">http://www.thedigitalwalters.org/Data/WaltersManuscripts/<xsl:value-of
                    select="$idno"/>/data/W.<xsl:value-of select="$idnoPart"/>/</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            </xsl:variable>
        <xsl:variable name="msurl">
            <xsl:choose>
                <xsl:when test="starts-with($idno,'W')">http://www.thedigitalwalters.org/Data/WaltersManuscripts/html/<xsl:value-of select="$idno"/>/description.html</xsl:when>
                <xsl:otherwise><xsl:value-of select="@msURL"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:for-each select="co:quire">
            <xsl:variable name="quireNo" select="@n"/>
            <xsl:variable name="positions" select="@positions"/>
            <xsl:variable name="filename" select="concat($idno,'-',$quireNo,'.html')"/>
            <xsl:result-document href="{concat($idno,'/',$filename)}" format="html">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <!--  -->
                    <head>
                        <title>Collation - Quire <xsl:value-of select="$quireNo"/></title>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

                        <!-- Add jQuery library -->
                        <script type="text/javascript" src="fancybox/lib/jquery-1.10.1.min.js"/>

                        <!-- Add fancyBox main JS and CSS files -->
                        <script type="text/javascript" src="fancybox/source/jquery.fancybox.js?v=2.1.5"/>
                        <link rel="stylesheet" type="text/css"
                            href="fancybox/source/jquery.fancybox.css?v=2.1.5" media="screen"/>
                        <link href="fancybox/source/jquery.fancybox.css" rel="stylesheet"
                            type="text/css"/>
                        <script type="text/javascript" src="fancybox/source/iframescript.js"/>

                        <script type="text/javascript" src="fancybox/collation.js"/>
                        <link href="css/collation.css" rel="stylesheet" type="text/css"/>

                    </head>

                    <body>
                        <!-- this div is the same for all quires -->
                        <div id="divtop">
                            <span class="topheader">
                                <a href="http://www.library.upenn.edu" target="_blank">
                                    <img src="pennlogo.gif" width="28" height="27"
                                        style="align:left;" alt="UPenn"/>
                                </a>
                                <xsl:text> </xsl:text>
                                <a href="http://www.schoenberginstitute.org" target="blank"
                                    ><xsl:text> </xsl:text><xsl:text> </xsl:text>Schoenberg
                                    Institute for Manuscript Studies</a>, <a href="http://dorpdev.library.upenn.edu/collation/" target="blank">SIMS Manuscript Collation Project</a>
                            </span>
                        </div>
                        <!-- This div will be the same for all quires -->
                        <div id="listofquires">
                            <span class="mstitle"><a
                                    href="{$msurl}"
                                    target="_blank"><xsl:value-of select="$msname"/></a></span>
                            <xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text>
                            <select name="quirelist" id="quirelist"
                                onchange="MM_jumpMenu('parent',this,1)">
                                <option>Select a Quire</option>
                                <!-- need to build this - urls, and quire numbers and positions -->
                                <!-- for-each sibling? -->
                                <xsl:for-each select="parent::co:quires/co:quire">
                                    <xsl:element name="option">
                                        <xsl:attribute name="value"><xsl:value-of
                                                select="concat($idno,'-',@n,'.html')"
                                            /></xsl:attribute> Quire <xsl:value-of select="@n"/>
                                            (<xsl:value-of select="@positions"/>) </xsl:element>
                                </xsl:for-each>
                            </select>
                        </div>
                        <br/> Quire <xsl:value-of select="$quireNo"/> (<xsl:value-of
                            select="$positions"/>)<xsl:text> </xsl:text><xsl:text> </xsl:text><span
                            class="showhideall"><a href="#"
                                onclick="MM_changeProp('divset1','','height','auto','DIV');MM_changeProp('divset2','','height','auto','DIV');MM_changeProp('divset3','','height','auto','DIV');MM_changeProp('divset4','','height','auto','DIV')"
                                >Show
                            All</a></span><xsl:text> </xsl:text><xsl:text> </xsl:text><span
                            class="showhideall"><a href="#"
                                onclick="MM_changeProp('divset1','','height','0','DIV');MM_changeProp('divset2','','height','0','DIV');MM_changeProp('divset3','','height','0','DIV');MM_changeProp('divset4','','height','0','DIV')"
                                >Hide All</a></span>
                        <br/>
                        <xsl:for-each select="co:bifolia/co:conjoin">
                            <xsl:comment>
                                begin set
                            </xsl:comment>
                            <!-- This sets up the pairs -->
                            <!--Variables set for the left and right positions, inside-->
                            <xsl:variable name="bi1" select="co:inside/co:left/@pos"/>
                            <xsl:variable name="bi2" select="co:inside/co:right/@pos"/>
                            <!--Variable setting the URL to the "X" image-->
                            <xsl:variable name="imgX"
                                >http://dorpdev.library.upenn.edu/collation/x.jpg</xsl:variable>
                            <!-- Variables grabbing the image URLs for all four sides in the bifolium -->
                            <xsl:variable name="insideLeftImgTest"
                                select="concat($baseurl,co:inside/co:left/@url)"/>
                            <xsl:variable name="insideRightImgTest"
                                select="concat($baseurl,co:inside/co:right/@url)"/>
                            <xsl:variable name="outsideLeftImgTest"
                                select="concat($baseurl,co:outside/co:left/@url)"/>
                            <xsl:variable name="outsideRightImgTest"
                                select="concat($baseurl,co:outside/co:right/@url)"/>
                            <!-- Variables checking when image URLs are empty, and replacing them with X image if they are -->
                            <xsl:variable name="insideLeftImg"><xsl:choose>
                                    <xsl:when test="$insideLeftImgTest = $baseurl"><xsl:value-of
                                            select="$imgX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideLeftImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <xsl:variable name="insideRightImg"><xsl:choose>
                                    <xsl:when test="$insideRightImgTest = $baseurl"><xsl:value-of
                                            select="$imgX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideRightImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <xsl:variable name="outsideLeftImg"><xsl:choose>
                                    <xsl:when test="$outsideLeftImgTest = $baseurl"><xsl:value-of
                                            select="$imgX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideLeftImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <xsl:variable name="outsideRightImg"><xsl:choose>
                                    <xsl:when test="$outsideRightImgTest = $baseurl"><xsl:value-of
                                            select="$imgX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideRightImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <!-- Variable setting "X", to be used when another folio number is empty -->
                            <xsl:variable name="folNoX">X</xsl:variable>
                            <!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
                            <xsl:variable name="insideLeftFolNoTest"
                                select="co:inside/co:left/@folNo"/>
                            <xsl:variable name="insideRightFolNoTest"
                                select="co:inside/co:right/@folNo"/>
                            <xsl:variable name="outsideLeftFolNoTest"
                                select="co:outside/co:left/@folNo"/>
                            <xsl:variable name="outsideRightFolNoTest"
                                select="co:outside/co:right/@folNo"/>
                            <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                                <xsl:variable name="insideLeftFolNo"><xsl:choose>
                                    <xsl:when test="not($insideLeftFolNoTest)"><xsl:value-of
                                            select="$folNoX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideLeftFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="insideRightFolNo"><xsl:choose>
                                    <xsl:when test="not($insideRightFolNoTest)"><xsl:value-of
                                            select="$folNoX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideRightFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="outsideLeftFolNo"><xsl:choose>
                                    <xsl:when test="not($outsideLeftFolNoTest)"><xsl:value-of
                                            select="$folNoX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideLeftFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="outsideRightFolNo"><xsl:choose>
                                    <xsl:when test="not($outsideRightFolNoTest)"><xsl:value-of
                                            select="$folNoX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideRightFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!-- Variables removing r and v from the folio numbers - used as a check in the next set -->
                            <xsl:variable name="leftFolTest"
                                select="concat(substring-before($insideLeftFolNo,'r'),substring-before($insideLeftFolNo,'v'))"/>
                            <xsl:variable name="rightFolTest"
                                select="concat(substring-before($insideRightFolNo,'r'),substring-before($insideRightFolNo,'v'))"
                            />
                            <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                            <xsl:variable name="leftFol"><xsl:choose>
                                    <xsl:when test="not($leftFolTest)"><xsl:value-of
                                            select="$folNoX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$leftFolTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rightFol"><xsl:choose>
                                    <xsl:when test="not($rightFolTest)"><xsl:value-of
                                            select="$folNoX"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$rightFolTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable> 
                            
                            
                            <xsl:variable name="leftFolFileName">
                                <xsl:choose>
                                    <xsl:when test="$leftFol = $folNoX"><xsl:value-of select="concat($folNoX,$quireNo,$bi1)"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$leftFol"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rightFolFileName">
                                <xsl:choose>
                                    <xsl:when test="$rightFol = $folNoX"><xsl:value-of select="concat($folNoX,$quireNo,$bi2)"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$rightFol"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            
                            <xsl:variable name="divsetNo" select="@n"/>
                            
                            <div class="bititles">Quire
                                    <xsl:value-of select="$quireNo"/>, Bifolium <xsl:value-of
                                    select="$leftFol"/>, <xsl:value-of select="$rightFol"/>
                                <xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#"
                                    onclick="MM_changeProp('divset{$divsetNo}','','height','auto','DIV')"><img
                                        src="images/open.gif" alt="Open" class="openimage"/></a><a
                                    href="#"
                                    onclick="MM_changeProp('divset{$divsetNo}','','height','0px','DIV')"><img
                                        src="images/close.gif" alt="Close" class="closeimage"
                                /></a></div>
                            <div>
                                <xsl:attribute name="id">divset<xsl:value-of select="$divsetNo"
                                    /></xsl:attribute>
                                <div class="bif">
                                    
                                    
                                    
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     version="1.1"
     x="0"
     y="0"
     width="100mm"
     height="75mm"
     preserveAspectRatio="xMidYMid meet"
	 style="background: #415a6c;"
     viewBox="0 0 100 75">
     
   <defs>
      <filter id="f1" filterUnits="userSpaceOnUse">
         <feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
      </filter>
   </defs>
   <desc>Collation diagram Quire <xsl:value-of select="$quireNo"/></desc>
    <text x="20" y="5" class="bititle">Quire <xsl:value-of select="$quireNo"/>, Bifolium <xsl:value-of
        select="$leftFol"/>, <xsl:value-of select="$rightFol"/></text>
    
    
    
    <xsl:for-each select="ancestor::co:quire">
        <xsl:variable name="positions" select="@positions"/>
        <xsl:for-each select="1 to $positions">
            <!--<text>
                <xsl:attribute name="x">75</xsl:attribute>
                <xsl:attribute name="class">nums</xsl:attribute>
                <xsl:if test=".>($positions div 2)"><xsl:attribute name="y"><xsl:value-of select="11 + 6*."/></xsl:attribute>
                <xsl:value-of select="."></xsl:value-of>
                </xsl:if>
                <xsl:if test=".&lt;=($positions div 2)"><xsl:attribute name="y"><xsl:value-of select="10 + 6*(.-1)"/></xsl:attribute>
                <xsl:value-of select="."/>
                </xsl:if>
                
            </text>-->
                <xsl:if test=". = $bi1"><text class="labels" x="75">
                    <xsl:attribute name="y"><xsl:value-of select="4 + 6*."/></xsl:attribute><xsl:choose><xsl:when test="$insideLeftFolNo = $folNoX"><xsl:value-of select="$folNoX"/></xsl:when><xsl:otherwise><xsl:value-of select="$leftFolTest"/></xsl:otherwise></xsl:choose></text></xsl:if>
                <xsl:if test=". = $bi2"><text class="labels" x="75">
                    <xsl:attribute name="y"><xsl:value-of select="17 + 6*(.-1)"/></xsl:attribute><xsl:choose><xsl:when test="$insideRightFolNo = $folNoX"><xsl:value-of select="$folNoX"/></xsl:when><xsl:otherwise><xsl:value-of select="$rightFolTest"/></xsl:otherwise></xsl:choose></text></xsl:if>
            
            
        </xsl:for-each>
    </xsl:for-each>

    <svg x="0" y="0">
        <xsl:for-each select="parent::co:bifolia">
            <xsl:variable name="positions" select="parent::co:quire/@positions"/>
            
            <xsl:for-each select="co:conjoin"><desc>Bifolium #<xsl:value-of select="@n"/></desc>
                
                <xsl:variable name="leftPos" select="co:inside/co:left/@pos"/>
                <xsl:variable name="rightPos" select="co:inside/co:right/@pos"/>
                <xsl:variable name="path1-left">
                    <xsl:value-of select="9 + 6*($leftPos - 1)"/>
                </xsl:variable>
                <xsl:variable name="path1-right">
                    <xsl:value-of select="9 + 6*$rightPos"/>
                </xsl:variable>
                <xsl:variable name="count" select="$positions div 2"/>
                <xsl:variable name="max" select="$count * 6"/>
                <xsl:variable name="path2" select="$max - ($leftPos - 1)*6"/>
                <xsl:variable name="path3">
                    <xsl:if test="$count = 2">
                        <xsl:value-of select="14 + ($leftPos - 1)*6"/>
                    </xsl:if>
                    <xsl:if test="$count = 1 or $count = 4">
                        <xsl:value-of select="5 + ($leftPos - 1)*5"/>
                    </xsl:if>
                    <xsl:if test="$count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">
                        <xsl:value-of select="19 + ($leftPos - 1)*6"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="path4" select="15 + ($count - 1)*6"/>
                <xsl:variable name="M-path1">
                    <xsl:if test="$count = 1">M12</xsl:if>
                    <xsl:if test="$count = 2">M24</xsl:if>
                    <xsl:if test="$count = 3">M36</xsl:if>
                    <xsl:if test="$count = 4">M26</xsl:if>
                    <xsl:if test="$count = 5">M48</xsl:if>
                    <xsl:if test="$count = 6">M54</xsl:if>
                    <xsl:if test="$count = 7">M60</xsl:if>
                    <xsl:if test="$count = 8">M66</xsl:if>
                </xsl:variable>
                <xsl:variable name="M-path2">
                    <xsl:if test="$count = 1 or $count = 2 or $count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">M70</xsl:if>
                    <xsl:if test="$count = 4 or $count = 7">M26</xsl:if>
                </xsl:variable>
                <xsl:variable name="L">
                    <xsl:if test="$count = 1">L12</xsl:if>
                    <xsl:if test="$count = 2">L24</xsl:if>
                    <xsl:if test="$count = 3">L36</xsl:if>
                    <xsl:if test="$count = 4">L60</xsl:if>
                    <xsl:if test="$count = 5">L48</xsl:if>
                    <xsl:if test="$count = 6">L54</xsl:if>
                    <xsl:if test="$count = 7">L60</xsl:if>
                    <xsl:if test="$count = 8">L66</xsl:if>
                </xsl:variable>
                <g>
                    <g>
                        <xsl:attribute name="class"><xsl:choose><xsl:when test="@n = $bi1">thisleaf</xsl:when><xsl:otherwise>leaf</xsl:otherwise></xsl:choose></xsl:attribute>
                        <path stroke-linecap="round">
                            <xsl:attribute name="d"><xsl:value-of select="$M-path1"/>,<xsl:value-of select="$path1-left"/> A<xsl:value-of select="$path2"/>,<xsl:value-of select="$path2"/> 0 0,0 <xsl:value-of select="$path3"/>,<xsl:value-of select="$path4"/></xsl:attribute>
                        </path>
                        <path>
                            <xsl:attribute name="d"><xsl:value-of select="$M-path2"/>,<xsl:value-of select="$path1-left"/> <xsl:text> </xsl:text><xsl:value-of select="$L"/>,<xsl:value-of select="$path1-left"/></xsl:attribute>
                        </path>
                    </g>
                    <g>
                        <xsl:attribute name="class"><xsl:choose><xsl:when test="@n = $bi1">thisleaf</xsl:when><xsl:otherwise>leaf</xsl:otherwise></xsl:choose></xsl:attribute>
                        <path stroke-linecap="round">
                            <xsl:attribute name="d"><xsl:value-of select="$M-path1"/>,<xsl:value-of select="$path1-right"/> A<xsl:value-of select="$path2"/>,<xsl:value-of select="$path2"/> 0 0,1 <xsl:value-of select="$path3"/>,<xsl:value-of select="$path4"/></xsl:attribute>
                        </path>
                        <path>
                            <xsl:attribute name="d"><xsl:value-of select="$M-path2"/>,<xsl:value-of select="$path1-right"/> <xsl:text> </xsl:text><xsl:value-of select="$L"/>,<xsl:value-of select="$path1-right"/></xsl:attribute>
                        </path>
                    </g>
                </g>
                <xsl:if test="co:inside/co:left[@missing='yes']">
                    <desc>Missing leaf #<xsl:value-of select="$leftPos"/></desc>
                    <g>
                        <g class="missingLeaf">
                            <path stroke-linecap="round">
                                <xsl:attribute name="d"><xsl:value-of select="$M-path1"/>,<xsl:value-of select="$path1-left"/> A<xsl:value-of select="$path2"/>,<xsl:value-of select="$path2"/> 0 0,0 <xsl:value-of select="$path3"/>,<xsl:value-of select="$path4"/></xsl:attribute>
                            </path>
                            <path>
                                <xsl:attribute name="d"><xsl:value-of select="$M-path2"/>,<xsl:value-of select="$path1-left"/> <xsl:text> </xsl:text><xsl:value-of select="$L"/>,<xsl:value-of select="$path1-left"/></xsl:attribute>
                            </path>
                        </g>
                    </g>
                </xsl:if>
                <xsl:if test="co:inside/co:right[@missing='yes']">
                    <desc>Missing leaf #<xsl:value-of select="$rightPos"/></desc>
                    <g>
                        <g class="missingLeaf">
                            <path stroke-linecap="round">
                                <xsl:attribute name="d"><xsl:value-of select="$M-path1"/>,<xsl:value-of select="$path1-right"/> A<xsl:value-of select="$path2"/>,<xsl:value-of select="$path2"/> 0 0,1 <xsl:value-of select="$path3"/>,<xsl:value-of select="$path4"/></xsl:attribute>
                            </path>
                            <path>
                                <xsl:attribute name="d"><xsl:value-of select="$M-path2"/>,<xsl:value-of select="$path1-right"/> <xsl:text> </xsl:text><xsl:value-of select="$L"/>,<xsl:value-of select="$path1-right"/></xsl:attribute>
                            </path>
                        </g>
                    </g>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </svg>
    
   
</svg>
                                
                                
                                
                                
                                
                                
                                </div>
                                
                                <div class="img1">
                                    <a class="fancybox fancybox.iframe" rel="set{@n}"
                                        title="(Quire {$quireNo}, Bifolium {$leftFol}.{$rightFol}, inside)"
                                        href="bifoliums/{$leftFolFileName}.{$rightFolFileName}.i.html">
                                        <img height="250" src="{$insideLeftImg}"
                                            alt="{$insideLeftFolNo}"/>
                                        <img height="250" src="{$insideRightImg}"
                                            alt="{$insideRightFolNo}"/></a>
                                    <br/><xsl:value-of select="$insideLeftFolNo"/><span
                                        class="spacer"><xsl:text> </xsl:text></span><xsl:value-of
                                        select="$insideRightFolNo"/>
                                </div>
                                <div class="img2">
                                    <a class="fancybox fancybox.iframe" rel="set{@n}"
                                        title="(Quire {$quireNo}, Bifolium {$leftFol}.{$rightFol}, outside)"
                                        href="bifoliums/{$leftFolFileName}.{$rightFolFileName}.o.html">
                                        <img height="250" src="{$outsideLeftImg}"
                                            alt="{$outsideLeftFolNo}"/>
                                        <img height="250" src="{$outsideRightImg}" 
                                            alt="{$outsideRightFolNo}"
                                        /></a>
                                    <br/><xsl:value-of select="$outsideLeftFolNo"/><span
                                        class="spacer"><xsl:text> </xsl:text></span><xsl:value-of
                                        select="$outsideRightFolNo"/>
                                </div>
                            </div>
                            
                            <xsl:result-document href="{$idno}/bifoliums/{$leftFolFileName}.{$rightFolFileName}.i.html" format="html">
                                <xsl:for-each select="co:inside">
                                    <html xmlns="http://www.w3.org/1999/xhtml">
                                        <head>
                                            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                                            <title>Quire <xsl:value-of select="$quireNo"/>, Bifolium <xsl:value-of
                                                select="$leftFol"/>.<xsl:value-of select="$rightFol"/>, inside</title>
                                            
                                            <link href="../css/imagepages.css" rel="stylesheet" type="text/css" />
                                        </head>
                                        
                                        <body>
                                            
                                            <table id="tblimages">
                                                <tr>
                                                    <td><img src="{$insideLeftImg}"  class="bifolimage" alt="{$insideLeftFolNo}" /></td>
                                                    <td><img src="{$insideRightImg}"  class="bifolimage" alt="{$insideRightFolNo}" /></td>
                                                </tr>
                                                <tr>
                                                    <td><xsl:value-of select="$insideLeftFolNo"/></td>
                                                    <td><xsl:value-of select="$insideRightFolNo"/></td>
                                                </tr>
                                                
                                            </table>
                                        </body>
                                    </html>
                                </xsl:for-each>
                            </xsl:result-document>
                            <xsl:result-document href="{$idno}/bifoliums/{$leftFolFileName}.{$rightFolFileName}.o.html" format="html">
                                <xsl:for-each select="co:outside">
                                    <html xmlns="http://www.w3.org/1999/xhtml">
                                        <head>
                                            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                                            <title>Quire <xsl:value-of select="$quireNo"/>, Bifolium <xsl:value-of
                                                select="$leftFol"/>.<xsl:value-of select="$rightFol"/>, outside</title>
                                            
                                            <link href="../css/imagepages.css" rel="stylesheet" type="text/css" />
                                        </head>
                                        
                                        <body>
                                            
                                            <table id="tblimages">
                                                <tr>
                                                    <td><img src="{$outsideLeftImg}"  class="bifolimage" alt="{$outsideLeftFolNo}" /></td>
                                                    <td><img src="{$outsideRightImg}"  class="bifolimage" alt="{$outsideRightFolNo}" /></td>
                                                </tr>
                                                <tr>
                                                    <td><xsl:value-of select="$outsideLeftFolNo"/></td>
                                                    <td><xsl:value-of select="$outsideRightFolNo"/></td>
                                                </tr>
                                                
                                            </table>
                                        </body>
                                    </html>
                                </xsl:for-each>
                            </xsl:result-document>
                        </xsl:for-each>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
