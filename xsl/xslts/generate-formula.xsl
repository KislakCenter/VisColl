<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- Simple script to create a collation formula from the output of the collation modeler -->

    <xsl:template match="manuscript">
        <xsl:variable name="title" select="//title"/>
        <xsl:variable name="shelfmark" select="//shelfmark"/>
        <xsl:variable name="url" select="//url"/>
<xsl:result-document href="{concat(translate($shelfmark,' ',''),'.html')}">
    <html>
            <head><title>Collation Formula for <xsl:value-of select="$title"/></title></head>
            <body>
                <p>Collation Formula for <a href="{$url}"><xsl:value-of select="$title"/></a>
                    (shelfmark: <xsl:value-of select="$shelfmark"/>)</p>
                <p>Formula 1: 
                    <xsl:for-each select="quire">
                        <!-- to be in the format 1(8, -4, +3) -->
                        <xsl:variable name="quire-no" select="@n"/>
                        <xsl:variable name="no-leaves" select="child::leaf[last()]/@n"/>
                        <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"
                            /><xsl:for-each select="child::leaf[@mode='missing']">, -<xsl:value-of
                                select="@n"/></xsl:for-each><xsl:for-each select="child::leaf[@mode='added']">, +<xsl:value-of
                                    select="@n"/></xsl:for-each><xsl:for-each select="child::leaf[@mode='replaced']">, leaf in position <xsl:value-of
                                        select="@n"/> has been replaced</xsl:for-each>),<xsl:text> </xsl:text>
                    </xsl:for-each>
                </p>
                <p>Formula 2: 
                    <xsl:for-each select="quire">
                        <!-- to be in the format 1(8, leaf missing between fol. X and fol. Y, leaf added after fol. X) -->
                        <xsl:variable name="quire-no" select="@n"/>
                        <xsl:variable name="no-leaves" select="child::leaf[last()]/@n"/>
                        <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"
                        />
                        <xsl:for-each select="child::leaf[@mode='missing']"><xsl:choose>
                            <xsl:when test="preceding-sibling::leaf">, leaf missing after fol. <xsl:value-of
                                select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when><xsl:otherwise>, first leaf is missing</xsl:otherwise></xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each select="child::leaf[@mode='added']"><xsl:choose>
                            <xsl:when test="preceding-sibling::leaf">, leaf added after fol. <xsl:value-of
                                select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when><xsl:otherwise>, first leaf is added</xsl:otherwise></xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each select="child::leaf[@mode='replaced']"><xsl:choose><xsl:when test="preceding-sibling::leaf">, leaf replaced after fol. <xsl:value-of
                            select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when><xsl:otherwise>, first leaf is replaced</xsl:otherwise></xsl:choose>
                        </xsl:for-each>),<xsl:text> </xsl:text>
                    </xsl:for-each>
                </p>
            </body>
        </html></xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
