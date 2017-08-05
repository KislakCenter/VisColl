<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns="http://www.schoenberginstitute.org/schema/collation" exclude-result-prefixes="ss"
    version="2.0">

    <xsl:output method="text"/>
    <xsl:output method="html" indent="yes" name="html"/>


    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>December 3, 2015</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from process6.xsl.
                It generates a single HTML document containing diagrams for each quire.
                Note that although this document can handle quires containing up to 16 folios, the diagrams
                for quires with 14 and 16 folios will be cut off at the bottom.
                Congratulations! You are done!
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    

    <xsl:template match="manuscript">
        <xsl:variable name="idno" select="@idno"/>
        <xsl:variable name="msname" select="@msname"/>
        <xsl:variable name="empty"/>
        <xsl:variable name="msurl">
            <xsl:value-of select="@msURL"/>
        </xsl:variable>
            <xsl:variable name="filename-diagrams" select="concat($idno,'-diagrams.html')"/>
            <xsl:result-document href="{concat($idno,'/',$filename-diagrams)}" format="html">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <!--  -->
                    <head>
                        <title>Diagrams - <xsl:value-of select="$msname"/></title>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

                        <!-- Add jQuery library -->
                        <script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/lib/jquery-1.10.1.min.js"/>

                        <!-- Add fancyBox main JS and CSS files -->
                        <script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.js?v=2.1.5"/>
                        <link rel="stylesheet" type="text/css"
                            href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css?v=2.1.5" media="screen"/>
                        <link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css" rel="stylesheet"
                            type="text/css"/>
                        <script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/iframescript.js"/>

                        <script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/collation.js"/>
                        <link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/collation.css" rel="stylesheet" type="text/css"/>
                        <link href="diagrams_only.css" rel="stylesheet" type="text/css"/>
                    </head>

                    <body>
                        <div id="divtop">
                            <span class="topheader">
                                <a href="http://www.library.upenn.edu" target="_blank">
                                    <img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/pennlogo.gif" width="28" height="27"
                                        style="align:left;" alt="UPenn"/>
                                </a>
                                <xsl:text> </xsl:text>
                                <a href="http://www.schoenberginstitute.org" target="blank"
                                    ><xsl:text> </xsl:text><xsl:text> </xsl:text>Schoenberg
                                    Institute for Manuscript Studies</a>, <a href="http://dorpdev.library.upenn.edu/collation/" target="blank">SIMS Manuscript Collation Project</a>
                            </span>
                        </div>
                        <div id="listofquires"><span
                            class="mstitle"><a
                                target="_blank">
                                <xsl:attribute name="href"><xsl:value-of select="$msurl"/></xsl:attribute>Collation diagrams for <xsl:value-of select="$msname"/>, <xsl:value-of select="$idno"/></a></span></div>
                        
                        <xsl:for-each select="quire">
                        <xsl:variable name="quireNo" select="@n"/>
                        <xsl:variable name="positions" select="@positions"/>
                        
                        <!--<br/> Quire <xsl:value-of select="$quireNo"/> (<xsl:value-of
                            select="$positions"/>)<xsl:text> </xsl:text><xsl:text> </xsl:text><span
                            class="showhideall"><a href="#"
                                onclick="MM_changeProp('divset1','','height','auto','DIV');"
                                >Show
                            All</a></span><xsl:text> </xsl:text><xsl:text> </xsl:text><span
                            class="showhideall"><a href="#"
                                onclick="MM_changeProp('divset1','','height','0','DIV');"
                                >Hide All</a></span>
                        <br/>-->
                        <xsl:for-each select="units/unit[1]">
                            <xsl:comment>
                                begin set
                            </xsl:comment>
                            <!-- This sets up the pairs -->
                            <!--Variables set for the left and right positions, inside-->
                            <xsl:variable name="bi1" select="inside/left/@pos"/>
                            <xsl:variable name="bi2" select="inside/right/@pos"/>
                            <!--Variable setting the URL to the "X" image-->
                            <xsl:variable name="imgX"
                                >https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/x.jpg</xsl:variable>
                            <!-- Variables grabbing the image URLs for all four sides in the unit -->
                            <xsl:variable name="insideLeftImgTest"
                                select="inside/left/@url"/>
                            <xsl:variable name="insideRightImgTest"
                                select="inside/right/@url"/>
                            <xsl:variable name="outsideLeftImgTest"
                                select="outside/left/@url"/>
                            <xsl:variable name="outsideRightImgTest"
                                select="outside/right/@url"/>
                            <!-- Variables checking when image URLs are empty and mode is missing, and replacing them with X image if they are -->
                            <xsl:variable name="insideLeftImg"><xsl:choose>
                                <xsl:when test="$insideLeftImgTest = $empty"><xsl:choose><xsl:when test="inside/left/@mode='missing'"><xsl:value-of
                                            select="$imgX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideLeftImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <xsl:variable name="insideRightImg"><xsl:choose>
                                <xsl:when test="$insideRightImgTest = $empty"><xsl:choose><xsl:when test="inside/right/@mode='missing'"><xsl:value-of
                                    select="$imgX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideRightImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <xsl:variable name="outsideLeftImg"><xsl:choose>
                                <xsl:when test="$outsideLeftImgTest = $empty"><xsl:choose><xsl:when test="outside/left/@mode='missing'"><xsl:value-of
                                    select="$imgX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideLeftImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <xsl:variable name="outsideRightImg"><xsl:choose>
                                <xsl:when test="$outsideRightImgTest = $empty"><xsl:choose><xsl:when test="outside/right/@mode='missing'"><xsl:value-of
                                    select="$imgX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideRightImgTest"
                                        /></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            <!-- Variable setting "X", to be used when another folio number is empty -->
                            <xsl:variable name="folNoX">X</xsl:variable>
                            <!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
                            <xsl:variable name="insideLeftFolNoTest"
                                select="inside/left/@folNo"/>
                            <xsl:variable name="insideRightFolNoTest"
                                select="inside/right/@folNo"/>
                            <xsl:variable name="outsideLeftFolNoTest"
                                select="outside/left/@folNo"/>
                            <xsl:variable name="outsideRightFolNoTest"
                                select="outside/right/@folNo"/>
                            <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                                <xsl:variable name="insideLeftFolNo"><xsl:choose>
                                    <xsl:when test="not($insideLeftFolNoTest)"><xsl:choose><xsl:when test="inside/left/@mode='missing'"><xsl:value-of
                                            select="$folNoX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideLeftFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="insideRightFolNo"><xsl:choose>
                                <xsl:when test="not($insideRightFolNoTest)"><xsl:choose><xsl:when test="inside/right/@mode='missing'"><xsl:value-of
                                    select="$folNoX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$insideRightFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="outsideLeftFolNo"><xsl:choose>
                                <xsl:when test="not($outsideLeftFolNoTest)"><xsl:choose><xsl:when test="outside/left/@mode='missing'"><xsl:value-of
                                    select="$folNoX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideLeftFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="outsideRightFolNo"><xsl:choose>
                                <xsl:when test="not($outsideRightFolNoTest)"><xsl:choose><xsl:when test="outdide/right/@mode='missing'"><xsl:value-of
                                    select="$folNoX"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$outsideRightFolNoTest"
                                        /></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
                            <!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
                            <xsl:variable name="leftFolTest">
                                <xsl:choose>
                                <xsl:when test="contains($insideLeftFolNo,'r') or contains($insideLeftFolNo,'v')">
                                    <xsl:value-of select="concat(substring-before($insideLeftFolNo,'r'),substring-before($insideLeftFolNo,'v'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$insideLeftFolNo"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rightFolTest">
                                <xsl:choose>
                                    <xsl:when test="contains($insideRightFolNo,'r') or contains($insideRightFolNo,'v')">
                                        <xsl:value-of select="concat(substring-before($insideRightFolNo,'r'),substring-before($insideRightFolNo,'v'))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$insideRightFolNo"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
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
                            
                            
                            
                            <div class="bititles">Quire
                                    <xsl:value-of select="$quireNo"/><!--, Unit <xsl:value-of
                                    select="$leftFol"/>, <xsl:value-of select="$rightFol"/>-->
                                <xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#"
                                    onclick="MM_changeProp('divset{$quireNo}','','height','auto','DIV')"><img
                                        src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/open.gif" alt="Open" class="openimage"/></a><a
                                    href="#"
                                    onclick="MM_changeProp('divset{$quireNo}','','height','10px','DIV')"><img
                                        src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/close.gif" alt="Close" class="closeimage"
                                /></a></div>
                            <div class="divset">
                                <xsl:attribute name="id">divset<xsl:value-of select="$quireNo"
                                    /></xsl:attribute>
                                <!--<div class="bif">-->
                                    
                                    
                                    
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     version="1.1"
     x="0"
     y="0"
     width="100mm"
     height="75mm"
     preserveAspectRatio="xMidYMid meet"
     viewBox="0 0 100 75">
    <xsl:attribute name="style">background: #415a6c;</xsl:attribute>
     
   <defs>
      <filter id="f1" filterUnits="userSpaceOnUse">
         <feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
      </filter>
   </defs>
   <desc>Collation diagram Quire <xsl:value-of select="$quireNo"/></desc>
    <!--<text x="20" y="5" class="bititle">Quire <xsl:value-of select="$quireNo"/>, Unit <xsl:value-of
        select="$leftFol"/>, <xsl:value-of select="$rightFol"/></text>-->
    
    
    
    <xsl:for-each select="ancestor::quire">
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
        <xsl:for-each select="parent::units">
            <xsl:variable name="positions" select="parent::quire/@positions"/>
            
            <xsl:for-each select="unit"><desc>Unit #<xsl:value-of select="@n"/></desc>
                
                <xsl:variable name="leftPos" select="inside/left/@pos"/>
                <xsl:variable name="rightPos" select="inside/right/@pos"/>
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
                        <xsl:attribute name="class">leaf<xsl:if test="inside/left[not(@mode)]"> empty</xsl:if><xsl:if test="inside/left[@mode='missing']"> missing</xsl:if><xsl:if test="inside/left[@mode='added']"> added</xsl:if><xsl:if test="inside/left[@mode='replaced']"> replaced</xsl:if></xsl:attribute>
                        <path stroke-linecap="round">
                            <xsl:attribute name="d"><xsl:value-of select="$M-path1"/>,<xsl:value-of select="$path1-left"/> A<xsl:value-of select="$path2"/>,<xsl:value-of select="$path2"/> 0 0,0 <xsl:value-of select="$path3"/>,<xsl:value-of select="$path4"/></xsl:attribute>
                        </path>
                        <path>
                            <xsl:attribute name="d"><xsl:value-of select="$M-path2"/>,<xsl:value-of select="$path1-left"/> <xsl:text> </xsl:text><xsl:value-of select="$L"/>,<xsl:value-of select="$path1-left"/></xsl:attribute>
                        </path>
                    </g>
                    <g>
                        <xsl:attribute name="class">leaf<xsl:if test="inside/right[not(@mode)]"> empty</xsl:if><xsl:if test="inside/right[@mode='missing']"> missing</xsl:if><xsl:if test="inside/right[@mode='added']"> added</xsl:if><xsl:if test="inside/right[@mode='replaced']"> replaced</xsl:if></xsl:attribute>
                        <path stroke-linecap="round">
                            <xsl:attribute name="d"><xsl:value-of select="$M-path1"/>,<xsl:value-of select="$path1-right"/> A<xsl:value-of select="$path2"/>,<xsl:value-of select="$path2"/> 0 0,1 <xsl:value-of select="$path3"/>,<xsl:value-of select="$path4"/></xsl:attribute>
                        </path>
                        <path>
                            <xsl:attribute name="d"><xsl:value-of select="$M-path2"/>,<xsl:value-of select="$path1-right"/> <xsl:text> </xsl:text><xsl:value-of select="$L"/>,<xsl:value-of select="$path1-right"/></xsl:attribute>
                        </path>
                    </g>
                </g>
                
            </xsl:for-each>
        </xsl:for-each>
    </svg>
    
   
</svg>
                                
                                
                                
                                
                                
                                
                                </div>
                                
                                <!--<div class="img1">
                                    <a class="fancybox fancybox.iframe" rel="set{@n}"
                                        title="(Quire {$quireNo}, Unit {$leftFol}.{$rightFol}, inside)"
                                        href="units/{$leftFolFileName}.{$rightFolFileName}.i.html">
                                        <xsl:choose><xsl:when test="contains($insideLeftImg,'.')"><img height="250" src="{$insideLeftImg}"
                                            alt="{$insideLeftFolNo}"/></xsl:when><xsl:otherwise/></xsl:choose>
                                        <xsl:choose><xsl:when test="contains($insideRightImg,'.')"><img height="250" src="{$insideRightImg}"
                                            alt="{$insideRightFolNo}"/></xsl:when><xsl:otherwise/></xsl:choose></a>
                                    <br/><xsl:value-of select="$insideLeftFolNo"/><xsl:if test="contains($insideRightImg,'.') and contains($insideLeftImg,'.')"><span
                                        class="spacer"><xsl:text> </xsl:text></span></xsl:if><xsl:value-of
                                        select="$insideRightFolNo"/>
                                </div>
                                <div class="img2">
                                    <a class="fancybox fancybox.iframe" rel="set{@n}"
                                        title="(Quire {$quireNo}, Unit {$leftFol}.{$rightFol}, outside)"
                                        href="units/{$leftFolFileName}.{$rightFolFileName}.o.html">
                                        <xsl:choose><xsl:when test="contains($outsideLeftImg,'.')"><img height="250" src="{$outsideLeftImg}"
                                            alt="{$outsideLeftFolNo}"/></xsl:when><xsl:otherwise/></xsl:choose>
                                        <xsl:choose><xsl:when test="contains($outsideRightImg,'.')"><img height="250" src="{$outsideRightImg}" 
                                            alt="{$outsideRightFolNo}"
                                        /></xsl:when><xsl:otherwise/></xsl:choose></a>
                                    <br/><xsl:value-of select="$outsideLeftFolNo"/><xsl:if test="contains($outsideLeftImg,'.') and contains($outsideRightImg,'.')"><span
                                        class="spacer"><xsl:text> </xsl:text></span></xsl:if><xsl:value-of
                                        select="$outsideRightFolNo"/>
                                </div>-->
                            <!--</div>-->
                            
                        </xsl:for-each>
                        </xsl:for-each>
                    </body>
                </html>
            </xsl:result-document>
        
    </xsl:template>
</xsl:stylesheet>
