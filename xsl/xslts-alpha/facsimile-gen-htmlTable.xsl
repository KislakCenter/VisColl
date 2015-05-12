<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">

    <!-- To generate a tei:facsimile -->

    <xsl:template match="/">
        <facsimile>
            <xsl:for-each select="html/body/table/tr"> 
            <xsl:variable name="folNo" select="td[3]"/>
            <xsl:variable name="url" select="td[9]"/>
            <surface n="{$folNo}">
                <graphic url="{$url}"/>
            </surface>
            </xsl:for-each>
        </facsimile>
    </xsl:template>
</xsl:stylesheet>
