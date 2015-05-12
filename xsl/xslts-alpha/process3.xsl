<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.schoenberginstitute.org/schema/collation"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:co="http://www.schoenberginstitute.org/schema/collation" version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from process2.xsl.
                It counts all the <folio/> elements and numbers them from 1 through n, skipping
                those that are noted as missing.
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
        <quires idno="{$id}" msname="{@msname}" msURL="{@msURL}">
            <xsl:for-each select="co:quire">
                <xsl:variable name="n">
                    <xsl:value-of select="@n"/>
                </xsl:variable>
                <xsl:variable name="positions">
                    <xsl:value-of select="@positions"/>
                </xsl:variable>
                <quire n="{$n}" positions="{$positions}">
                    <!--<xsl:for-each select="count($positions)">
                        <folio></folio>
                    </xsl:for-each>-->
                    <xsl:apply-templates/>

                </quire>
            </xsl:for-each>
            <xsl:apply-templates select="tei:facsimile"/>
            <xsl:apply-templates select="co:msname"/>
        </quires>
    </xsl:template>

    <xsl:template match="co:folio[@mode='include']">
        <xsl:for-each select=".">
            <xsl:variable name="pos">
                <xsl:value-of select="@pos"/>
            </xsl:variable>
            <xsl:variable name="mode">
                <xsl:value-of select="@mode"/>
            </xsl:variable>
            <xsl:element name="folio">
                <xsl:attribute name="pos">
                    <xsl:value-of select="$pos"/>
                </xsl:attribute>
                <xsl:attribute name="mode">
                    <xsl:value-of select="$mode"/>
                </xsl:attribute>
                <!-- n counts all the folios and numbers them from the beginning. These should match the folio numbers. -->
                <xsl:attribute name="folNo">
                    <xsl:number count="co:folio[@mode='include']" level="any" format="1"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="co:folio[@mode='less']">
        <xsl:for-each select=".">
            <xsl:variable name="pos">
                <xsl:value-of select="@pos"/>
            </xsl:variable>
            <xsl:variable name="mode">
                <xsl:value-of select="@mode"/>
            </xsl:variable>
            <xsl:element name="folio">
                <xsl:attribute name="pos">
                    <xsl:value-of select="$pos"/>
                </xsl:attribute>
                <xsl:attribute name="mode">
                    <xsl:value-of select="$mode"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
