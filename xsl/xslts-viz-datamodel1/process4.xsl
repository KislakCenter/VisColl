<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="svg xlink xs" version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>October 24, 2016</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from the Collation Modeler.
                It generates the collation frame, with a <quire/> element for each quire, 
                <units/> containing all conjoins, and <unit/>for each bifolium / singleton, with a
                <right/> and <left/> side for each conjoin. There are attributes noting the
                position for each <right/> and <left/>, but not folio numbers.
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:template match="@*|node()|comment() " priority="-1" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="manuscript">
        <xsl:variable name="idno" select="translate(shelfmark,' ','')"/>
        <xsl:variable name="msname" select="title"/>
        <xsl:variable name="msURL" select="url"/>
        <manuscript idno="{$idno}" msname="{$msname}" msURL="{$msURL}">
            <xsl:for-each select="//quire">
                <quire>
                    <xsl:attribute name="n">
                        <xsl:value-of select="@n"/>
                    </xsl:attribute>
                    <xsl:variable name="positions">
                        <xsl:choose>
                            <xsl:when test="child::leaf">
                                <xsl:value-of select="child::leaf[last()]/@position"/>
                            </xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="positions">
                        <xsl:value-of select="$positions"/>
                    </xsl:attribute>

                    <leaves>
                        <xsl:call-template name="test"/>
                    </leaves>

                    <xsl:variable name="posNo">
                        <xsl:value-of select="$positions"/>
                    </xsl:variable>
                    <xsl:variable name="sum">
                        <xsl:value-of select="$posNo + 1"/>
                    </xsl:variable>
                    <xsl:variable name="div2">
                        <xsl:value-of select="$posNo div 2 + 1"/>
                    </xsl:variable>

                    <xsl:variable name="missing1">
                        <xsl:value-of select="leaf[mode='missing'][1]/@position"/>
                    </xsl:variable>
                    <xsl:variable name="missing2">
                        <xsl:value-of select="leaf[mode='missing'][2]/@position"/>
                    </xsl:variable>
                    <xsl:variable name="missing3">
                        <xsl:value-of select="leaf[mode='missing'][3]/@position"/>
                    </xsl:variable>
                    <xsl:variable name="missing4">
                        <xsl:value-of select="leaf[mode='missing'][4]/@position"/>
                    </xsl:variable>
                    <xsl:variable name="missing5">
                        <xsl:value-of select="leaf[mode='missing'][5]/@position"/>
                    </xsl:variable>
                    <xsl:variable name="missing6">
                        <xsl:value-of select="leaf[mode='missing'][6]/@position"/>
                    </xsl:variable>
                    <units>
                    
                        <xsl:for-each select="leaf[position() &lt; $div2]">
                        
                            <xsl:variable name="position">
                                <xsl:value-of select="@position"/>
                            </xsl:variable>
                            
                            <xsl:variable name="conjoin">
                                <xsl:value-of select="@conjoin"/>
                            </xsl:variable>
                        
                            <unit>
                                <xsl:attribute name="n" select="$position"/>
                                <inside>
                                    <left>
                                        <xsl:if test="($position = $missing1) or ($position = $missing2) or ($position = $missing3) or ($position = $missing4) or ($position = $missing5) or ($position = $missing6)">
                                            <xsl:attribute name="mode">missing</xsl:attribute>
                                        </xsl:if>                                        <xsl:attribute name="pos"><xsl:value-of select="$position"/></xsl:attribute>
                                    </left>
                                    <right>
                                        <xsl:if test="($conjoin = $missing1) or ($conjoin = $missing2) or ($conjoin = $missing3) or ($conjoin = $missing4) or ($conjoin = $missing5) or ($conjoin = $missing6)">
                                            <xsl:attribute name="mode">missing</xsl:attribute>
                                        </xsl:if>
                                        <xsl:attribute name="pos"><xsl:value-of select="$conjoin"/></xsl:attribute>
                                    </right>
                                </inside>
                                <outside>
                                    <left>
                                        <xsl:if test="($conjoin = $missing1) or ($conjoin = $missing2) or ($conjoin = $missing3) or ($conjoin = $missing4) or ($conjoin = $missing5) or ($conjoin = $missing6)">
                                            <xsl:attribute name="mode">missing</xsl:attribute>
                                        </xsl:if>
                                        <xsl:attribute name="pos"><xsl:value-of select="$conjoin"/></xsl:attribute>
                                    </left>
                                    <right>
                                        <xsl:if test="($position = $missing1) or ($position = $missing2) or ($position = $missing3) or ($position = $missing4) or ($position = $missing5)  or ($position = $missing6)">
                                            <xsl:attribute name="mode">missing</xsl:attribute>
                                        </xsl:if>
                                        <xsl:attribute name="pos"><xsl:value-of select="$position"/></xsl:attribute>
                                    </right>
                                </outside>
                            </unit>
                        
                            
                        
                    </xsl:for-each>
                    </units>
                </quire>
            </xsl:for-each>
            <xsl:call-template name="copy"/>
        </manuscript>

    </xsl:template>

    <xsl:template name="test" match="//quire">
        <xsl:for-each select=".">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="copy">
        <xsl:for-each select="//quire">
        <quireCopy>
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
            <xsl:variable name="positions" select="child::leaf[last()]/@position"/>
            <xsl:attribute name="positions">
                <xsl:value-of select="$positions"/>
            </xsl:attribute>
           <xsl:call-template name="test"/>
        </quireCopy>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
