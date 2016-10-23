<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="svg xlink xs" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p>This document takes as its input the output from process4.xsl. It adds folio /
                page numbers to <right/> and <left/>. </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="@*|node()|comment() " priority="-1" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="manuscript">
        <manuscript msname="{@msname}" msURL="{@msURL}" idno="{@idno}">
            <xsl:for-each select="quire">
                <quire>
                    <xsl:attribute name="n">
                        <xsl:value-of select="@n"/>
                    </xsl:attribute>
                    <xsl:attribute name="positions">
                        <xsl:value-of select="@positions"/>
                    </xsl:attribute>
                    <units>
                        <xsl:apply-templates select="units"/>
                    </units>
                </quire>
            </xsl:for-each>
            <xsl:call-template name="copy"/>
        </manuscript>
    </xsl:template>

    <xsl:template match="units">
        <xsl:for-each select="unit">
            <unit>
                <xsl:attribute name="n" select="@n"/>
                <inside>
                    <xsl:apply-templates select="inside"/>
                </inside>
                <outside>
                    <xsl:apply-templates select="outside"/>
                </outside>
            </unit>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="inside">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="outside">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="left">
        <xsl:variable name="the_pos" select="@pos"/>
        <xsl:choose>
            <xsl:when
                test="contains(ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number,'-')">
                <xsl:variable name="first_number"
                    select="tokenize(ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number,'-') [position() = 1]"/>
                <xsl:variable name="second_number"
                    select="tokenize(ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number,'-') [position() = 2]"/>
                <xsl:choose>
                    <xsl:when test="parent::inside">
                        <left>
                            <xsl:if
                                test="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number">
                                <xsl:attribute name="folNo">
                                    <xsl:value-of select="$second_number"/>
                                </xsl:attribute>
                                <xsl:attribute name="mode">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="single">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@single"
                                    />
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="pos">
                                <xsl:value-of select="@pos"/>
                            </xsl:attribute>
                        </left>
                    </xsl:when>
                    <xsl:when test="parent::outside">
                        <left>
                            <xsl:if
                                test="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number">
                                <xsl:attribute name="folNo">
                                    <xsl:value-of
                                        select="$second_number"/>
                                </xsl:attribute>
                                <xsl:attribute name="mode">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="single">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@single"
                                    />
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="pos">
                                <xsl:value-of select="@pos"/>
                            </xsl:attribute>
                        </left>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <left>
                    <xsl:if test="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number">
                        <xsl:attribute name="folNo">
                            <xsl:value-of
                                select="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number"/>
                            <xsl:choose><xsl:when test="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode='missing'"/><xsl:otherwise><xsl:text>v</xsl:text></xsl:otherwise></xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="mode">
                            <xsl:value-of
                                select="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode"/>
                        </xsl:attribute>
                        <xsl:attribute name="single">
                            <xsl:value-of
                                select="ancestor::quire/leaves/leaf[@position=$the_pos]/@single"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="pos">
                        <xsl:value-of select="@pos"/>
                    </xsl:attribute>
                </left>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="right">
        <xsl:variable name="the_pos" select="@pos"/>
        <xsl:choose>
            <xsl:when
                test="contains(ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number,'-')">
                <xsl:variable name="first_number"
                    select="tokenize(ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number,'-') [position() = 1]"/>
                <xsl:variable name="second_number"
                    select="tokenize(ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number,'-') [position() = 2]"/>
                <xsl:choose>
                    <xsl:when test="parent::outside">
                        <right>
                            <xsl:if
                                test="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number">
                                <xsl:attribute name="folNo">
                                    <xsl:value-of
                                        select="$first_number"/>
                                </xsl:attribute>
                                <xsl:attribute name="mode">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="single">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@single"
                                    />
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="pos">
                                <xsl:value-of select="@pos"/>
                            </xsl:attribute>
                        </right>
                    </xsl:when>
                    <xsl:when test="parent::inside">
                        <right>
                            <xsl:if
                                test="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number">
                                <xsl:attribute name="folNo">
                                    <xsl:value-of select="$first_number"/>
                                </xsl:attribute>
                                <xsl:attribute name="mode">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="single">
                                    <xsl:value-of
                                        select="ancestor::quire/leaves/leaf[@position=$the_pos]/@single"
                                    />
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="pos">
                                <xsl:value-of select="@pos"/>
                            </xsl:attribute>
                        </right>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <right>
                    <xsl:if test="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number">
                        <xsl:attribute name="folNo">
                            <xsl:value-of
                                select="ancestor::quire/leaves/leaf[@position=$the_pos]/@folio_number"/>
                            <xsl:choose><xsl:when test="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode='missing'"/><xsl:otherwise><xsl:text>r</xsl:text></xsl:otherwise></xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="mode">
                            <xsl:value-of
                                select="ancestor::quire/leaves/leaf[@position=$the_pos]/@mode"/>
                        </xsl:attribute>
                        <xsl:attribute name="single">
                            <xsl:value-of
                                select="ancestor::quire/leaves/leaf[@position=$the_pos]/@single"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="pos">
                        <xsl:value-of select="@pos"/>
                    </xsl:attribute>
                </right>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="test" match="//quireCopy">
        <xsl:for-each select=".">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="copy">
        <xsl:for-each select="//quireCopy">
            <quireCopy>
                <xsl:attribute name="n">
                    <xsl:value-of select="@n"/>
                </xsl:attribute>
                <xsl:variable name="positions" select="@positions"/>
                <xsl:attribute name="positions">
                    <xsl:value-of select="$positions"/>
                </xsl:attribute>
                
                    <xsl:call-template name="test"/>
                
            </quireCopy>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
