<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sims="http://schoenberginstitute.org/"
    xmlns="http://www.schoenberginstitute.org/schema/collation"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Aug 12, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> Doug Emery</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
            <xd:p>XSLT to parse Walters Art Museum-style collation formulas from Walters TEI
                manuscript descriptions.

                This document takes three parameters: a unique ID for the manuscript, a manuscript
                name, and a URL for the manuscript at its home site.

                Walters-style collation formulae have a form like this:

                i, 1(8,-1,2), 2(6), 3(10,-1,9), 4(10,-4,8), 5(6,-1,5), 6(6), 7-11(8),
                   12(8,-8), 13(8), 14(6), 15(8,-8), 16(12,-5,9,12), 17(10,-6,8,10),
                   18(10,-6,8,10) 19(8,-7), 20-21(8), i

               Here the leading and trailing 'i' indicate a count of flyleaves. Before each
               parenthetical unit - e.g., '1(8,-1,2)' - is a single quire number (e.g., 1, 2,
               3) or a range of quire numbers (e.g., 7-11, 20-21). Within each parenthetical
               set - e.g., (8,-1,2) - the first number indicates the number of leaves in a
               theoretical regular quire structure, that would apply if this quire were regular:
               8 leaves for a regular quire of four bifolia or 6 leaves for a quire of three
               bifolia. The leaf number is then followed by a series of subtracted positions
               that explain how the regular quire structure should be altered to derive the
               structure of the quire in its current form.

               The general form of the formula is:

                 QUIRE_NO[-QUIRE_NO](LEAF_COUNT[,-POSITION[,POSITION,..]])

               For example, '1(8,-1,2)' describes a quire of 6 extant leaves. The quire has
               two bifolia followed by two singletons. The two bifolia are positions 3+6, 4+5,
               followed by singletons at positions 7, 8. The positions needed to complete the
               structure are the missing positions 1* and 2* (here marked with a * to indicate
               their absence).

                _ _ _ _ _ _ _ _ 1*
               |  _ _ _ _ _ _ _ 2*
               | |  ___________ 3
               | | |  _________ 4
               | | | |
               | | | |
               | | | |_________ 5
               | | |___________ 6
               | |_____________ 7
               |_______________ 8

               NB The numbers here indicate *theoretical* leaf positions, not folio numbers.

               NB Also, these formulae do no describe how the quire came to be, but rather
               merely describe the structure in a subtractive formula. Nothing should be
               inferred about the history of the quire from this formula. In the example
               above, the quire may have been a quire of 4 bifolia to which the last two
               singletons were later added; the formula is not concerned with this.

               This XSLT turns rewrites such a formula in an XML quire structure. The output
               has the following format:

                  <quires>
                      <quire n="1" positions="8"/>
                      <quire n="2" positions="8">
                          <less>1</less>
                          <less>2</less>
                      </quire>
                      <!--...-->
                  </quires>

                Modification by Dot Porter on 4/10 includes the full <facsimile/> section after the quires.
            </xd:p>
        </xd:desc>
    </xd:doc>

    <!--
        TODO: ? Handle both added and subtracted leaves (now only subtracted leaves are dealt with.)
        May be no need to handle added leaves, we have no cases of this yet.
    -->

    <xsl:output indent="yes"/>

    <xsl:param name="idno"/>
    <xsl:param name="msname"/>
    <xsl:param name="msURL"/>

    <xsl:template match="/">
        <quires>
            <xsl:attribute name="idno" select="$idno"/>


            <xsl:attribute name="msname" select="$msname"/>
            <xsl:attribute name="msURL" select="$msURL"/>

            <xsl:variable name="collation" select="//tei:formula"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:comment>
                <xsl:text>Formula: </xsl:text>
                <xsl:value-of select="$collation"/>
            </xsl:comment>
            <!--Get rid of spaces and strip flyleaves-->
            <xsl:variable name="quire-string" select="replace(replace($collation, '\s+', ''), '^[ivxl]+,|,[ivxl]+$', '')"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:comment>
                <!-- 1(8,-1,2),2(6),3(10,-1,9),4(10,-4,8),5(6,-1,5),6(6),7-11(8),12(8,-8),13(8),14(6),15(8,-8),16(12,-5,9,12),...,20-21(8)-->
                <xsl:text>Quire string: </xsl:text>
                <xsl:value-of select="$quire-string"/>
            </xsl:comment>

            <!-- Get the quire numbers and make sure there are no duplicates -->
            <xsl:variable name="quire-nums" as="xs:string*">
                <xsl:for-each select="tokenize($quire-string, '\),')">
                    <xsl:call-template name="quire-nums">
                        <xsl:with-param name="quire-set" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <xsl:text>&#xA;</xsl:text>
            <xsl:call-template name="validate-quires">
                <xsl:with-param name="quire-nums" select="$quire-nums"/>
            </xsl:call-template>
            <xsl:comment>
                <xsl:text>Quire numbers: </xsl:text>
                <xsl:value-of select="string-join($quire-nums, ', ')"/>
            </xsl:comment>
            <xsl:text>&#xA;</xsl:text>

            <!--Process each set of quire descriptions, here called a quire-set-->
            <xsl:for-each select="tokenize($quire-string, '\),')">
                <!-- ("1(8,-1,2", "2(6", "3(10,-1,9", "4(10,-4,8", "5(6,-1,5", "6(6", "7-11(8", ...) -->
                <xsl:call-template name="parse-quire-set">
                    <xsl:with-param name="quire-set" select="."/>
                </xsl:call-template>
            </xsl:for-each>

            <!-- Including the facsimile portion of the TEI MSDESC -->
            <tei:facsimile>
                <xsl:for-each select="//tei:facsimile/tei:surface">
                        <tei:surface n="{@n}">
                            <tei:graphic url="{tei:graphic/@url}"/>
                        </tei:surface>
                </xsl:for-each>
            </tei:facsimile>
        </quires>
    </xsl:template>

    <!-- CALCULATING QUIRE NUMBERS -->
    
    <!-- template: quire-nums - for quire-set return the quire nums as an array of strings -->
    <xsl:template name="quire-nums" as="xs:string*">
        <xsl:param name="quire-set"/>
        <!--  "1(8,-1,2" quire-nos: "1" -->
        <xsl:variable name="quire-nos" select="tokenize(.,'\(')[1]"/>
        <!--  "1(8,-1,2" start: "1" -->
        <xsl:variable name="start" select="tokenize($quire-nos,'-')[1]"/>
        <!--  "1(8,-1,2" end: NaN -->
        <xsl:variable name="end" select="tokenize($quire-nos,'-')[2]"/>
        <xsl:call-template name="calc-quire-nums">
            <xsl:with-param name="start-num" select="$start"/>
            <xsl:with-param name="end-num" select="$end"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- template: calc-quire-nums - for start-num and end-num return all quire numbers;
        accepts numerals or single letters in a-z or A-Z; if end-num is empty, returns 
        start-num and quits
        
        recursively calls itself increument start-num until start-num is greater than end-num
        
        1,3        => ("1", "2", "3")
        a,c        => ("a", "b", "c")
        1,<EMPTY>  => ("1")
    -->
    <xsl:template name="calc-quire-nums" as="xs:string*">
        <xsl:param name="start-num"/>
        <xsl:param name="end-num"/>
        <xsl:choose>
            <xsl:when test="not($end-num)">
                <xsl:sequence select="$start-num"/>
            </xsl:when>
            <xsl:when test="sims:quire-lte($start-num, $end-num)">
                <xsl:sequence select="$start-num"/>
                <xsl:variable name="next">
                    <xsl:call-template name="next-quire-num">
                        <xsl:with-param name="num" select="$start-num"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="calc-quire-nums">
                    <xsl:with-param name="start-num" select="$next"/>                    
                    <xsl:with-param name="end-num" select="$end-num"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- template: next-quire-num - return the subsequent quire number for num
        
        1 => 2
        3 => 4
        a => b
        A => B
    -->
    <xsl:template name="next-quire-num">
        <xsl:param name="num"/>
        <xsl:choose>
            <xsl:when test="matches($num, '\d+')">
                <xsl:value-of select="number($num) + 1"/>
            </xsl:when>
            <xsl:when test="matches($num, '[A-Z]')">
                <xsl:value-of select="translate($num, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'BCDEFGHIJKLMNOPQRSTUVWXYZA')"/>
            </xsl:when>
            <xsl:when test="matches($num, '[a-z]')">
                <xsl:value-of select="translate($num, 'abcdefghijklmnopqrstuvwxyz', 'bcdefghijklmnopqrstuvwxyza')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- template: validate-quires - halt processing if quire-nums contains duplicates 
    
    Note: 'a' and 'A' are not duplicates
    -->
    <xsl:template name="validate-quires">
        <xsl:param name="quire-nums" as="xs:string*"/>
        <xsl:variable name="distinct-quires" select="distinct-values($quire-nums)" as="xs:string*"/>
        <xsl:if test="count($quire-nums) ne count($distinct-quires)">
            <xsl:message terminate="yes">
                <!-- 
                    oXygen 
                -->
                <xsl:text>Collation formula has duplicate quire numbers: </xsl:text>
                <xsl:value-of select="string-join($quire-nums, ', ')"/>
            </xsl:message>
        </xsl:if>
    </xsl:template>

    <!--  GENERATION OF <quire> ELEMENTS  -->
    
    <!-- template: parse-quire-set - for quire-set return all <quire> elements
        
        For example, quire-set 3(10,-1,9) returns
        
            <quire n="3" positions="10">
              <less>1</less>
              <less>9</less>
           </quire>        
    -->
    <xsl:template name="parse-quire-set">
        <!--  quire-set looks like this: "1(8,-1,2" -->
        <xsl:param name="quire-set"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:variable name="quire-nums" as="xs:string*">
            <xsl:call-template name="quire-nums">
                <xsl:with-param name="quire-set" select="$quire-set"/>
            </xsl:call-template>
        </xsl:variable>
        <!--  "1(8,-1,2" quire-spec: "8,-1,2" -->
        <xsl:variable name="quire-spec" select="tokenize(.,'[()]')[2]"/>
        <xsl:for-each select="$quire-nums">
            <xsl:call-template name="parse-quires">
                <xsl:with-param name="quire-num" select="."/>
                <xsl:with-param name="quire-spec" select="$quire-spec"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- template: parse-quires - for quire-num and quire-spec create and return the quire element -->
    <xsl:template name="parse-quires">
        <xsl:param name="quire-num"/>
        <xsl:param name="quire-spec"/>
        <quire>
            <xsl:attribute name="n" select="$quire-num"/>
            <xsl:attribute name="positions">
                <xsl:call-template name="parse-positions">
                    <xsl:with-param name="quire-spec" select="$quire-spec"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="parse-alterations">
                <xsl:with-param name="quire-spec" select="$quire-spec"/>
            </xsl:call-template>
        </quire>
    </xsl:template>
    
    <!--template: parse-positions - get the number of leaf positions from the quire-spec-->
    <xsl:template name="parse-positions">
        <xsl:param name="quire-spec"/>
        <xsl:value-of select="tokenize($quire-spec, ',')[1]"/>
    </xsl:template>

    <!--template: parse-alterations - create a <less> element for each subtraction-->
    <xsl:template name="parse-alterations">
        <xsl:param name="quire-spec"/>
        <xsl:if test="matches($quire-spec, ',')">
            <xsl:for-each select="tokenize(substring-after($quire-spec, ','), ',')">
                <less>
                    <!--Remove any initial '-'-->
                    <xsl:value-of select="replace(., '^-', '')"/>
                </less>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    
    <!-- FUNCTION -->
    
    <!-- function: sims:quire-lte - return true if quire-a is less than or equal to quire-b 
    
    Custom function to do lexical comparison for literal quire-numbers and numeric 
    comparison of numerical quire numbers.
    
    NB: Doesn't compare numbers and letters.
    -->
    <xsl:function name="sims:quire-lte" as="xs:boolean">
        <xsl:param name="quire-a"/>
        <xsl:param name="quire-b"/>
        <xsl:choose>
            <xsl:when test="string(number($quire-a)) = 'NaN'">
                <xsl:value-of select="$quire-a le $quire-b"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number($quire-a) le number($quire-b)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
