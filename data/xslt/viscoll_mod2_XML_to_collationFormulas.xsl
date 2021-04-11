<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:vc="http://viscoll.org/schema/collation"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://viscoll.org/schema/collation"
    exclude-result-prefixes="xlink xs xd tei" version="2.0">

    <xsl:output name="collationFormulasTXT" method="text"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 2019-06-10</xd:p>
            <xd:p><xd:b>Author:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Based on templates created by:</xd:b> Dot Porter, <xd:b>created on:</xd:b>
                2014-07-02 <xd:p><xd:b>Modified on:</xd:b>May 5, 2015</xd:p>
                <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
            </xd:p>
            <xd:p>This document takes as its input the output from the Collation Modeler. It
                generates two text files with two styles of simple collation formulas</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- Variable to find the path to the top folder of the textblock 
        (containing all the XML, SVG, HTML, CSS, JS, etc. files) -->
    <xsl:variable name="base-uri">
        <xsl:value-of select="tokenize(base-uri(), 'XML/')[1]"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Collation formulas are created in separate text files.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/viscoll">
        <xsl:for-each select="textblock | manuscript">
            <xsl:variable name="textblockN" select="position()"/>
            <!-- Shelfmark -->
            <xsl:variable name="shelfmark">
                <xsl:value-of select="shelfmark/text()"/>
            </xsl:variable>
            <!-- Variable to generate a textblock ID from the shelfmark.
            Only adds textblock number for more than one textblock in bookblock -->
            <xsl:variable name="tbID"
                select="
                    concat(translate($shelfmark, ' ', ''), if (xs:integer($textblockN) gt 1) then
                        concat('-', $textblockN)
                    else
                        '')"/>
            <!-- Collation formulas 01 -->
            <xsl:call-template name="collationFormula1">
                <xsl:with-param name="tbID" select="$tbID"/>
            </xsl:call-template>
            <!-- Collation formulas 02 -->
            <xsl:call-template name="collationFormula2">
                <xsl:with-param name="tbID" select="$tbID"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:b>Collation formula generator.</xd:b>
            <xd:p>Format: 1(8, -4, +3)</xd:p>
        </xd:desc>
        <xd:param name="tbID"/>
    </xd:doc>
    <xsl:template name="collationFormula1">
        <xsl:param name="tbID"/>
        <xsl:variable name="filename-formulaTXT_01" select="concat($tbID, '-formula_01.txt')"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base-uri, 'XML/', $filename-formulaTXT_01)"/>
        </xsl:variable>
        <xsl:result-document href="{$href}" format="collationFormulasTXT">
            <xsl:for-each-group select="leaves/leaf"
                group-by="
                if (contains(q[1]/@n, '.')) then
                substring-before(q[1]/@n, '.')
                else
                q[1]/@n">
                <xsl:variable name="gatheringNumber">
                    <xsl:value-of select="current-grouping-key()"/>
                </xsl:variable>
                <xsl:variable name="gatheringID">
                    <xsl:value-of select="replace(q/@target, '#', '')"/>
                </xsl:variable>
                <xsl:variable name="positions">
                    <xsl:value-of select="xs:integer(count(current-group()))"/>
                </xsl:variable>
                <xsl:variable name="units">
                    <xsl:copy-of select="current-group()"/>
                </xsl:variable>
                <!-- to be in the format 1(8, -4, +3) -->
                <xsl:value-of select="$gatheringNumber"/>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="$positions"/>
                <xsl:for-each select="$units/leaf[mode/@val eq 'missing']">
                    <xsl:text>, -</xsl:text>
                    <xsl:value-of select="q/@position"/>
                </xsl:for-each>
                <xsl:for-each select="$units/leaf[mode/@val eq 'added']">
                    <xsl:text>, +</xsl:text>
                    <xsl:value-of select="q/@position"/>
                </xsl:for-each>
                <xsl:for-each select="$units/leaf[mode/@val eq 'replaced']">
                    <xsl:text>, leaf in position </xsl:text>
                    <xsl:value-of select="q/@position"/>
                    <xsl:text> has been replaced</xsl:text>
                </xsl:for-each>
                <xsl:text>)</xsl:text>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each-group>
        </xsl:result-document>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:b>Collation formula generator.</xd:b>
            <xd:p>Format: 1(8, leaf missing between fol. X and fol. Y, leaf added after fol.
                X)</xd:p>
        </xd:desc>
        <xd:param name="tbID"/>
    </xd:doc>
    <xsl:template name="collationFormula2">
        <xsl:param name="tbID"/>
        <xsl:variable name="filename-formulaTXT_02" select="concat($tbID, '-formula_02.txt')"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base-uri, 'XML/', $filename-formulaTXT_02)"/>
        </xsl:variable>
        <xsl:result-document href="{$href}" format="collationFormulasTXT">
            <xsl:for-each-group select="leaves/leaf"
                group-by="
                    if (contains(q[1]/@n, '.')) then
                        substring-before(q[1]/@n, '.')
                    else
                        q[1]/@n">
                <xsl:variable name="gatheringNumber">
                    <xsl:value-of select="current-grouping-key()"/>
                </xsl:variable>
                <xsl:variable name="gatheringID">
                    <xsl:value-of select="replace(q/@target, '#', '')"/>
                </xsl:variable>
                <xsl:variable name="positions">
                    <xsl:value-of select="xs:integer(count(current-group()))"/>
                </xsl:variable>
                <xsl:variable name="units">
                    <xsl:copy-of select="current-group()"/>
                </xsl:variable>
                <!-- to be in the format 1(8, leaf missing between fol. X and fol. Y, leaf added after fol. X) -->
                <xsl:value-of select="$gatheringNumber"/>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="$positions"/>
                <xsl:for-each select="$units/leaf[mode/@val eq 'missing']">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::leaf">
                            <xsl:choose>
                                <xsl:when
                                    test="preceding-sibling::leaf[mode/@val eq 'missing'][1] | following-sibling::leaf[mode/@val eq 'missing'][1]">
                                    <xsl:choose>
                                        <xsl:when
                                            test="following-sibling::leaf[mode/@val eq 'missing']">
                                            <xsl:variable name="lastPresent">
                                                <xsl:value-of
                                                  select="preceding-sibling::leaf[mode/@val != 'missing'][1]/q/@position"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="lastMissing">
                                                <xsl:value-of
                                                  select="following-sibling::leaf[mode/@val eq 'missing'][last()]/q/@position"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="countMissing">
                                                <xsl:value-of
                                                  select="abs($lastMissing - $lastPresent)"/>
                                            </xsl:variable>
                                            <xsl:text>, </xsl:text>
                                            <xsl:value-of select="$countMissing"/>
                                            <xsl:text> leaves missing after fol. </xsl:text>
                                            <xsl:value-of
                                                select="preceding-sibling::leaf[mode/@val != 'missing'][1]/folioNumber"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>, leaf missing after fol. </xsl:text>
                                    <xsl:value-of
                                        select="preceding-sibling::leaf[mode/@val != 'missing'][1]/folioNumber"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, first leaf is missing</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$units/leaf[mode/@val eq 'added']">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::leaf">
                            <xsl:text>, leaf added after fol. </xsl:text>
                            <xsl:value-of select="preceding-sibling::leaf[1]/folioNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, first leaf is added</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$units/leaf[mode/@val eq 'replaced']">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::leaf">
                            <xsl:text>, leaf replaced after fol. </xsl:text>
                            <xsl:value-of select="preceding-sibling::leaf[1]/folioNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, first leaf is replaced</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>)</xsl:text>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each-group>
        </xsl:result-document>
    </xsl:template>    
    
    <!--     <xsl:template name="collationFormula2">
        <xsl:param name="tbID"/>
        <xsl:variable name="filename-formulaTXT_02" select="concat($tbID, '-formula_02.txt')"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base-uri, 'XML/', $filename-formulaTXT_02)"/>
        </xsl:variable>
        <xsl:result-document href="{$href}" format="collationFormulasTXT">
            <xsl:for-each-group select="leaves/leaf"
                group-by="
                    if (contains(q[1]/@n, '.')) then
                        substring-before(q[1]/@n, '.')
                    else
                        q[1]/@n">
                <xsl:variable name="gatheringNumber">
                    <xsl:value-of select="current-grouping-key()"/>
                </xsl:variable>
                <xsl:variable name="gatheringID">
                    <xsl:value-of select="replace(q/@target, '#', '')"/>
                </xsl:variable>
                <xsl:variable name="positions">
                    <xsl:value-of select="xs:integer(count(current-group()))"/>
                </xsl:variable>
                <xsl:variable name="units">
                    <xsl:copy-of select="current-group()"/>
                </xsl:variable>
                <!- to be in the format 1(8, leaf missing between fol. X and fol. Y, leaf added after fol. X) ->
    <xsl:value-of select="$gatheringNumber"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$positions"/>
    <xsl:for-each select="$units/leaf[mode/@val eq 'missing']">
        <xsl:choose>
            <xsl:when test="preceding-sibling::leaf">
                <xsl:choose>
                    <xsl:when
                        test="preceding-sibling::leaf[mode/@val eq 'missing'][1] | following-sibling::leaf[mode/@val eq 'missing'][1]">
                        <xsl:choose>
                            <xsl:when
                                test="following-sibling::leaf[mode/@val eq 'missing']">
                                <xsl:variable name="lastPresent">
                                    <xsl:value-of
                                        select="preceding-sibling::leaf[mode/@val != 'missing'][1]/q/@position"
                                    />
                                </xsl:variable>
                                <xsl:variable name="lastMissing">
                                    <xsl:value-of
                                        select="following-sibling::leaf[mode/@val eq 'missing'][last()]/q/@position"
                                    />
                                </xsl:variable>
                                <xsl:variable name="countMissing">
                                    <xsl:value-of
                                        select="abs($lastMissing - $lastPresent)"/>
                                </xsl:variable>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="$countMissing"/>
                                <xsl:text> leaves missing after fol. </xsl:text>
                                <xsl:value-of
                                    select="preceding-sibling::leaf[mode/@val != 'missing'][1]/folioNumber"
                                />
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>, leaf missing after fol. </xsl:text>
                        <xsl:value-of
                            select="preceding-sibling::leaf[mode/@val != 'missing'][1]/folioNumber"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, first leaf is missing</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="$units/leaf[mode/@val eq 'added']">
        <xsl:choose>
            <xsl:when test="preceding-sibling::leaf">
                <xsl:text>, leaf added after fol. </xsl:text>
                <xsl:value-of select="preceding-sibling::leaf[1]/folioNumber"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, first leaf is added</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="$units/leaf[mode/@val eq 'replaced']">
        <xsl:choose>
            <xsl:when test="preceding-sibling::leaf">
                <xsl:text>, leaf replaced after fol. </xsl:text>
                <xsl:value-of select="preceding-sibling::leaf[1]/folioNumber"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, first leaf is replaced</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
    <xsl:choose>
        <xsl:when test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text> </xsl:text>
    </xsl:for-each-group>
    </xsl:result-document>
    </xsl:template>    
    -->

    
</xsl:stylesheet>
