<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns="http://www.schoenberginstitute.org/schema/collation"
    xmlns:co="http://www.schoenberginstitute.org/schema/collation"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xpath-default-namespace="http://www.schoenberginstitute.org/schema/collation"
    exclude-result-prefixes="svg xlink xs" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from process4.xsl.
                It adds folio numbers to <right/> and <left/>.
            </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="@*|node()|comment() " priority="-1" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="quires">
        <quires msname="{@msname}" msURL="{@msURL}" idno="{@idno}">
            <xsl:for-each select="quire">
                <quire>
                    <xsl:attribute name="n">
                        <xsl:value-of select="@n"/>
                    </xsl:attribute>
                    <xsl:attribute name="positions">
                        <xsl:value-of select="@positions"/>
                    </xsl:attribute>
                    <bifolia>
                        <xsl:apply-templates select="bifolia"/>
                    </bifolia>
                </quire>
            </xsl:for-each>
            <xsl:apply-templates select="//tei:facsimile"/>
        </quires>
    </xsl:template>

    <xsl:template match="bifolia">
        <xsl:for-each select="conjoin">
            <conjoin>
                <xsl:attribute name="n" select="@n"/>
                <inside>
                    <xsl:apply-templates select="inside"/>
                </inside>
                <outside>
                    <xsl:apply-templates select="outside"/>
                </outside>
            </conjoin>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="inside">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="outside">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="left">
        <left>
            <xsl:if test="@missing='yes'">
                <xsl:attribute name="missing">yes</xsl:attribute>
            </xsl:if>
            <xsl:variable name="the_pos" select="@pos"/>
            <xsl:if test="ancestor::quire/folios/folio[@pos=$the_pos]/@folNo">
                <xsl:attribute name="folNo">
                    <xsl:value-of select="ancestor::quire/folios/folio[@pos=$the_pos]/@folNo"/><xsl:text>v</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="pos"><xsl:value-of select="@pos"/></xsl:attribute>
        </left>
    </xsl:template>

    <xsl:template match="right">
        <right>
            <xsl:if test="@missing='yes'">
                <xsl:attribute name="missing">yes</xsl:attribute>
            </xsl:if>
            <xsl:variable name="the_pos" select="@pos"/>
            <xsl:if test="ancestor::quire/folios/folio[@pos=$the_pos]/@folNo">
                <xsl:attribute name="folNo">
                    <xsl:value-of select="ancestor::quire/folios/folio[@pos=$the_pos]/@folNo"/><xsl:text>r</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="pos"><xsl:value-of select="@pos"/></xsl:attribute>
        </right>
    </xsl:template>



</xsl:stylesheet>
