<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.schoenberginstitute.org/schema/collation"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:co="http://www.schoenberginstitute.org/schema/collation"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from process1.xsl or process1-withParam.xsl.
                It creates a <folio/> element for each folio implied in the process1.xsl output, and notes
                whether any of those folios are missing.
                It also copies over the tei:facsimile.
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:template match="@*|node()|comment() " priority="-1" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="co:quires">
        <xsl:variable name="id">
            <xsl:value-of select="@idno"/>
        </xsl:variable>
        
        <co:quires idno="{$id}" msname="{@msname}" msURL="{@msURL}">
            <xsl:for-each select="co:quire">
                
                <xsl:variable name="missing1">
                    <xsl:value-of select="co:less[1]"/>
                </xsl:variable>
                <xsl:variable name="missing2">
                    <xsl:value-of select="co:less[2]"/>
                </xsl:variable>
                <xsl:variable name="missing3">
                    <xsl:value-of select="co:less[3]"/>
                </xsl:variable>
                <xsl:variable name="missing4">
                    <xsl:value-of select="co:less[4]"/>
                </xsl:variable>
                <xsl:variable name="missing5">
                    <xsl:value-of select="co:less[5]"/>
                </xsl:variable>
                <xsl:variable name="missing6">
                    <xsl:value-of select="co:less[6]"/>
                </xsl:variable>
                
                <xsl:variable name="n">
                    <xsl:value-of select="@n"/>
                </xsl:variable>
                <xsl:variable name="positions">
                    <xsl:value-of select="@positions"/>
                </xsl:variable>
                
                <co:quire n="{$n}" positions="{$positions}">
                    <xsl:for-each select="1 to $positions">
                        <xsl:variable name="pos"><xsl:value-of select="."/></xsl:variable>
                        <co:folio>
                            <xsl:attribute name="pos"><xsl:value-of select="$pos"/></xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$pos = $missing1"><xsl:attribute name="mode">less</xsl:attribute></xsl:when>
                                <xsl:when test="$pos = $missing2"><xsl:attribute name="mode">less</xsl:attribute></xsl:when>
                                <xsl:when test="$pos = $missing3"><xsl:attribute name="mode">less</xsl:attribute></xsl:when>
                                <xsl:when test="$pos = $missing4"><xsl:attribute name="mode">less</xsl:attribute></xsl:when>
                                <xsl:when test="$pos = $missing5"><xsl:attribute name="mode">less</xsl:attribute></xsl:when>
                                <xsl:when test="$pos = $missing6"><xsl:attribute name="mode">less</xsl:attribute></xsl:when>
                                <xsl:otherwise><xsl:attribute name="mode">include</xsl:attribute></xsl:otherwise>
                            </xsl:choose>
                        </co:folio>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                    
                </co:quire>
            </xsl:for-each>
            <xsl:apply-templates select="tei:facsimile"/>
        </co:quires>
    </xsl:template>
    
</xsl:stylesheet>