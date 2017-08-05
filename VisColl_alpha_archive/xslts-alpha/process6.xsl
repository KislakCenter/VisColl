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
            <xd:p>This document takes as its input the output from process5.xsl (or process5.1-forPagination
                for those manuscripts that are paginated).
                It pulls image file URLs from tei:facsimile up into <left/> and <right/>.
                There is a separate document for Archimedes.
            </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="@*|node()|comment() " priority="-1" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="idno" select="quires/@idno"/>

    <xsl:template match="quires">
        <quires idno="{$idno}" msname="{@msname}" msURL="{@msURL}">

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
            <xsl:if test="@folNo">
                <xsl:attribute name="folNo">
                    <xsl:value-of select="@folNo"/>
                </xsl:attribute>
            </xsl:if>
            <!-- For Archimedes -->
            <xsl:variable name="folNoTest">
                <xsl:if test="contains($idno,'Arch') and contains(@folNo,'v')">
                    <xsl:value-of select="format-number(number(tokenize(@folNo,'v')[position() = 1]),'00')"/>
                    <!--<xsl:value-of select="@folNo"/>-->
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="folNo" select="concat('Arch',$folNoTest,'v')"/>
            
            <xsl:variable name="the_folNo">
                <xsl:choose>
                    <xsl:when test="starts-with($idno,'W')">
                        <xsl:value-of select="concat('fol. ',@folNo)"/>
                    </xsl:when>
                    <xsl:when test="starts-with($idno,'Arch')">
                        <xsl:value-of select="$folNo"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@folNo"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="ancestor::quires/tei:facsimile/tei:surface[@n=$the_folNo]">
                <xsl:attribute name="url">
                    <xsl:value-of
                        select="/quires/tei:facsimile/tei:surface[@n=$the_folNo]/tei:graphic/@url"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="pos">
                <xsl:value-of select="@pos"/>
            </xsl:attribute>
        </left>
    </xsl:template>

    <xsl:template match="right">
        <right>
            <xsl:if test="@missing='yes'">
                <xsl:attribute name="missing">yes</xsl:attribute>
            </xsl:if>
            <xsl:if test="@folNo">
                <xsl:attribute name="folNo">
                    <xsl:value-of select="@folNo"/>
                </xsl:attribute>
            </xsl:if>
            
            <!-- For Archimedes -->
            <xsl:variable name="folNoTest">
                <xsl:if test="contains($idno,'Arch') and contains(@folNo,'r')">
                    <xsl:value-of select="format-number(number(tokenize(@folNo,'r')[position() = 1]),'00')"/>
                    <!--<xsl:value-of select="@folNo"/>-->
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="folNo" select="concat('Arch',$folNoTest,'r')"/>
            
            <xsl:variable name="the_folNo">
                <xsl:choose>
                    <xsl:when test="starts-with($idno,'W')">
                        <xsl:value-of select="concat('fol. ',@folNo)"/>
                    </xsl:when>
                    <xsl:when test="starts-with($idno,'Arch')">
                        <xsl:value-of select="$folNo"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@folNo"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="/quires/tei:facsimile/tei:surface[@n=$the_folNo]">
                <xsl:attribute name="url">
                    <xsl:value-of
                        select="ancestor::quires/tei:facsimile/tei:surface[@n=$the_folNo]/tei:graphic/@url"
                    />
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="pos">
                <xsl:value-of select="@pos"/>
            </xsl:attribute>
        </right>
    </xsl:template>



</xsl:stylesheet>
