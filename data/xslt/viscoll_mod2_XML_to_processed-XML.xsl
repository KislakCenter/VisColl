<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:vc="http://viscoll.org/schema/collation"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xpath-default-namespace="http://viscoll.org/schema/collation"
    exclude-result-prefixes="svg xlink xs xd tei ss" version="2.0">

    <xsl:output name="processed-XML" method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:output name="collationFormulasTXT" method="text"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 2019-06-5</xd:p>
            <xd:p><xd:b>Author:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>2020-08-14</xd:p>
            <xd:p><xd:b>Based on templates created by:</xd:b> Dot Porter, <xd:b>created on:</xd:b>
                2014-07-02 <xd:p><xd:b>Modified on:</xd:b>May 5, 2015</xd:p>
                <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
                <xd:p><xd:b>Modified on:</xd:b>May 21, 2015</xd:p>
                <xd:p><xd:b>Modified by:</xd:b> Conal</xd:p>
            </xd:p>
            <xd:p>This document takes as its input the output from the Collation Modeler. It
                generates the collation frame for the bifolio visualization. </xd:p>
        </xd:desc>
    </xd:doc>

    <!-- Variable to find the path to the top folder of the textblock 
        (containing all the XML, SVG, HTML, CSS, JS, etc. files) -->
    <xsl:variable name="base-uri">
        <xsl:value-of select="tokenize(base-uri(), 'XML/')[1]"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Main template. Creates an XML file for each textblock. Leaves are grouped into
                gatherings</xd:p>
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
            <!-- Variable to store the image list information 
            NB: it looks for the file in the same folder as the viscol XML document -->
            <xsl:variable name="image-list-spreadsheet-excel"
                select="document(replace(base-uri(), tokenize(base-uri(), '/')[last()], concat($tbID, '-imageList.xml')))/ss:Workbook"/>
            <xsl:result-document href="{concat($tbID, '_processed-XML.xml')}" indent="yes"
                format="processed-XML">
                <viscoll>
                    <textblock>
                        <xsl:attribute name="tbURL">
                            <xsl:value-of select="url"/>
                        </xsl:attribute>
                        <xsl:attribute name="tbID">
                            <xsl:value-of select="$tbID"/>
                        </xsl:attribute>
                        <xsl:attribute name="textblockN">
                            <xsl:value-of select="$textblockN"/>
                        </xsl:attribute>
                        <xsl:attribute name="shelfmark">
                            <xsl:value-of select="$shelfmark"/>
                        </xsl:attribute>
                        <xsl:attribute name="date">
                            <xsl:value-of select="date"/>
                        </xsl:attribute>
                        <xsl:attribute name="direction">
                            <xsl:value-of select="direction/@val"/>
                        </xsl:attribute>
                        <xsl:attribute name="format">
                            <xsl:value-of select="format"/>
                        </xsl:attribute>
                        <xsl:attribute name="paper_flavor">
                            <xsl:value-of select="paper_flavor"/>
                        </xsl:attribute>
                        <xsl:element name="title">
                            <xsl:value-of select="title"/>
                        </xsl:element>
                        <xsl:element name="origPlace">
                            <xsl:value-of select="origPlace"/>
                        </xsl:element>
                        <gatherings>
                            <!-- gatherings are formed by grouping leaves according to the gathering to which the are listed as belonging to;
        if there are subgatherings, these are listed a gathering-number.subgathering-number.etc: this code will group all leaves 
        in the same gathering regardless of subgatherings -->
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
                                <gathering>
                                    <xsl:attribute name="n">
                                        <xsl:value-of select="$gatheringNumber"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="xml:id">
                                        <xsl:value-of select="$gatheringID"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="positions">
                                        <xsl:value-of select="$positions"/>
                                    </xsl:attribute>
                                    <units>
                                        <xsl:call-template name="units">
                                            <xsl:with-param name="units" select="$units"/>
                                            <xsl:with-param name="image-list-spreadsheet-excel"
                                                select="$image-list-spreadsheet-excel"/>
                                        </xsl:call-template>
                                    </units>
                                </gathering>
                            </xsl:for-each-group>
                        </gatherings>
                    </textblock>
                </viscoll>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template divides leaves into <units/> (one for each bifolio)</xd:p>
        </xd:desc>
        <xd:param name="units"/>
        <xd:param name="image-list-spreadsheet-excel"/>
    </xd:doc>
    <xsl:template name="units">
        <xsl:param name="units"/>
        <xsl:param name="image-list-spreadsheet-excel"/>
        <xsl:for-each select="$units/leaf">
            <!-- finds the ID of the conjoned leaf, removing the # symbol -->
            <xsl:variable name="conjoinID">
                <xsl:value-of select="q[1]/conjoin/replace(@target, '#', '')"/>
            </xsl:variable>
            <!-- Finds the position of the conjoined leaf -->
            <xsl:variable name="conjoinPosition">
                <!-- if there is a conjoined leaf, then the position is returned, otherwise 0 -->
                <xsl:choose>
                    <xsl:when test="q[1]/conjoin">
                        <xsl:value-of select="$units/leaf[@xml:id = $conjoinID]/q[1]/@position"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- Variable to generate a unique ID that puts together conjoined leaf positions in the correct order -->
            <xsl:variable name="ID-conjoined">
                <xsl:choose>
                    <xsl:when test="$conjoinPosition = 0">
                        <xsl:value-of select="q[1]/@position"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="
                                if (xs:integer(q[1]/@position) lt xs:integer($conjoinPosition)) then
                                    concat(q[1]/@position, '-', $conjoinPosition)
                                else
                                    concat($conjoinPosition, '-', q[1]/@position)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- Create a unique ID for each bifolium -->
            <xsl:variable name="folioID">
                <xsl:value-of
                    select="concat('g', q[1]/translate(@n, '.', '_'), '-', $ID-conjoined, '_leaf')"
                />
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="position() lt xs:integer($conjoinPosition)">
                    <unit>
                        <xsl:attribute name="folioID">
                            <xsl:value-of select="$folioID"/>
                        </xsl:attribute>
                        <xsl:attribute name="n">
                            <xsl:value-of select="position()"/>
                        </xsl:attribute>
                        <!-- Folio Number variable: by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
                        <xsl:variable name="folioNumberVar">
                            <xsl:choose>
                                <xsl:when test="folioNumber/text()">
                                    <xsl:value-of select="folioNumber"/>
                                    </xsl:when>
                            <xsl:otherwise>
                                    <xsl:value-of select="folioNumber/@val"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            </xsl:variable>
                        <inside>
                            <left>
                                <xsl:call-template name="currentLeaf">
                                    <xsl:with-param name="image-list-spreadsheet-excel"
                                        select="$image-list-spreadsheet-excel"/>
                                    <xsl:with-param name="xml-id" select="@xml:id"/>
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="side" select="'v'"/>
                                    <xsl:with-param name="thisLeaf" select="."/>
                                    <xsl:with-param name="folioNumber" select="$folioNumberVar"/>
                                    <xsl:with-param name="missing"
                                        select="
                                            if (mode/@val = 'missing') then
                                                'yes'
                                            else
                                                'no'"/>
                                    <xsl:with-param name="stub"
                                        select="
                                            if (@stub) then
                                                'yes'
                                            else
                                                'no'"
                                    />
                                </xsl:call-template>
                            </left>
                            <!-- Folio Number variable (sibling): by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
                            <xsl:variable name="folioNumberVarSibl">
                                <xsl:choose>
                                    <xsl:when test="following-sibling::leaf[@xml:id eq $conjoinID]/folioNumber/text()">
                                        <xsl:value-of select="following-sibling::leaf[@xml:id eq $conjoinID]/folioNumber"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="following-sibling::leaf[@xml:id eq $conjoinID]/folioNumber/@val"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <right>
                                <xsl:call-template name="currentLeaf">
                                    <xsl:with-param name="image-list-spreadsheet-excel"
                                        select="$image-list-spreadsheet-excel"/>
                                    <xsl:with-param name="xml-id"
                                        select="following-sibling::leaf[@xml:id eq $conjoinID]/@xml:id"/>
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="side" select="'r'"/>
                                    <xsl:with-param name="thisLeaf"
                                        select="following-sibling::leaf[@xml:id eq $conjoinID]"/>
                                    <xsl:with-param name="folioNumber"
                                        select="$folioNumberVarSibl"/>
                                    <xsl:with-param name="missing"
                                        select="
                                            if (following-sibling::leaf[@xml:id eq $conjoinID]/mode/@val = 'missing') then
                                                'yes'
                                            else
                                                'no'"/>
                                    <xsl:with-param name="stub"
                                        select="
                                            if (following-sibling::leaf[@xml:id eq $conjoinID]/@stub) then
                                                'yes'
                                            else
                                                'no'"
                                    />
                                </xsl:call-template>
                            </right>
                        </inside>                        
                        <!-- Folio Number variable (sibling): by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
                        <xsl:variable name="folioNumberVarSibl">
                            <xsl:choose>
                                <xsl:when test="following-sibling::leaf[@xml:id eq $conjoinID]/folioNumber/text()">
                                    <xsl:value-of select="following-sibling::leaf[@xml:id eq $conjoinID]/folioNumber"/>
                                    </xsl:when>
                            <xsl:otherwise>
                                    <xsl:value-of select="following-sibling::leaf[@xml:id eq $conjoinID]/folioNumber/@val"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            </xsl:variable>
                    <outside>
                            <left>
                                <xsl:call-template name="currentLeaf">
                                    <xsl:with-param name="image-list-spreadsheet-excel"
                                        select="$image-list-spreadsheet-excel"/>
                                    <xsl:with-param name="xml-id"
                                        select="following-sibling::leaf[@xml:id eq $conjoinID]/@xml:id"/>
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="side" select="'v'"/>
                                    <xsl:with-param name="thisLeaf"
                                        select="following-sibling::leaf[@xml:id eq $conjoinID]"/>
                                    <xsl:with-param name="folioNumber"
                                        select="$folioNumberVarSibl"/>
                                    <xsl:with-param name="missing"
                                        select="
                                            if (following-sibling::leaf[@xml:id eq $conjoinID]/mode/@val = 'missing') then
                                                'yes'
                                            else
                                                'no'"/>
                                    <xsl:with-param name="stub"
                                        select="
                                            if (following-sibling::leaf[@xml:id eq $conjoinID]/@stub) then
                                                following-sibling::leaf[@xml:id eq $conjoinID]/@stub
                                            else
                                                'no'"
                                    />
                                </xsl:call-template>
                            </left>                            
                            <!-- Folio Number variable: by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
                            <xsl:variable name="folioNumberVar">
                                <xsl:choose>
                                    <xsl:when test="folioNumber/text()">
                                        <xsl:value-of select="folioNumber"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="folioNumber/@val"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <right>
                                <xsl:call-template name="currentLeaf">
                                    <xsl:with-param name="image-list-spreadsheet-excel"
                                        select="$image-list-spreadsheet-excel"/>
                                    <xsl:with-param name="xml-id" select="@xml:id"/>
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="side" select="'r'"/>
                                    <xsl:with-param name="thisLeaf" select="."/>
                                    <xsl:with-param name="folioNumber" select="$folioNumberVar"/>
                                    <xsl:with-param name="missing"
                                        select="
                                            if (mode/@val = 'missing') then
                                                'yes'
                                            else
                                                'no'"/>
                                    <xsl:with-param name="stub"
                                        select="
                                            if (@stub) then
                                                @stub
                                            else
                                                'no'"
                                    />
                                </xsl:call-template>
                            </right>
                        </outside>
                    </unit>
                </xsl:when>
                <!-- Single leaves (without conjoin) only have the <left> setting -->
                <xsl:when test="xs:integer($conjoinPosition) eq 0">
                    <unit>
                        <xsl:attribute name="folioID">
                            <xsl:value-of select="$folioID"/>
                        </xsl:attribute>
                        <xsl:attribute name="n">
                            <xsl:value-of select="position()"/>
                        </xsl:attribute>
                        <!-- Folio Number variable: by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
                        <xsl:variable name="folioNumberVar">
                            <xsl:choose>
                                <xsl:when test="folioNumber/text()">
                                    <xsl:value-of select="folioNumber"/>
                                    </xsl:when>
                            <xsl:otherwise>
                                    <xsl:value-of select="folioNumber/@val"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <inside>
                            <left>
                                <xsl:call-template name="currentLeaf">
                                    <xsl:with-param name="image-list-spreadsheet-excel"
                                        select="$image-list-spreadsheet-excel"/>
                                    <xsl:with-param name="xml-id" select="@xml:id"/>
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="side" select="'r'"/>
                                    <xsl:with-param name="thisLeaf" select="."/>
                                    <xsl:with-param name="folioNumber" select="$folioNumberVar"/>
                                    <xsl:with-param name="missing"
                                        select="
                                            if (mode/@val = 'missing') then
                                                'yes'
                                            else
                                                'no'"/>
                                    <xsl:with-param name="stub"
                                        select="
                                            if (@stub) then
                                                @stub
                                            else
                                                'no'"
                                    />
                                </xsl:call-template>
                            </left>
                        </inside>
                    <!-- Folio Number variable: by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
                        <xsl:variable name="folioNumberVar">
                            <xsl:choose>
                                <xsl:when test="folioNumber/text()">
                                    <xsl:value-of select="folioNumber"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="folioNumber/@val"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <outside>
                            <left>
                                <xsl:call-template name="currentLeaf">
                                    <xsl:with-param name="image-list-spreadsheet-excel"
                                        select="$image-list-spreadsheet-excel"/>
                                    <xsl:with-param name="xml-id" select="@xml:id"/>
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="side" select="'v'"/>
                                    <xsl:with-param name="thisLeaf" select="."/>
                                    <xsl:with-param name="folioNumber" select="$folioNumberVar"/>
                                    <xsl:with-param name="missing"
                                        select="
                                            if (mode/@val = 'missing') then
                                                'yes'
                                            else
                                                'no'"/>
                                    <xsl:with-param name="stub"
                                        select="
                                            if (@stub) then
                                                @stub
                                            else
                                                'no'"
                                    />
                                </xsl:call-template>
                            </left>
                        </outside>
                    </unit>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template sets the data for each leaf representation, linking to the image
                listed in the imageList file</xd:p>
        </xd:desc>
        <xd:param name="image-list-spreadsheet-excel"/>
        <xd:param name="xml-id"/>
        <xd:param name="side"/>
        <xd:param name="folioID"/>
        <xd:param name="thisLeaf"/>
        <xd:param name="stub"/>
        <xd:param name="folioNumber"/>
        <xd:param name="missing"/>
    </xd:doc>
    <xsl:template name="currentLeaf">
        <xsl:param name="image-list-spreadsheet-excel"/>
        <xsl:param name="xml-id"/>
        <xsl:param name="side"/>
        <xsl:param name="folioID"/>
        <xsl:param name="thisLeaf"/>
        <xsl:param name="stub"/>
        <xsl:param name="folioNumber"/>
        <xsl:param name="missing"/>
        <leaf>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($xml-id, $side)"/>
            </xsl:attribute>
            <xsl:attribute name="folioID">
                <xsl:value-of select="$folioID"/>
            </xsl:attribute>
            <xsl:attribute name="side">
                <xsl:value-of select="$side"/>
            </xsl:attribute>
            <xsl:attribute name="stub">
                <xsl:value-of select="$stub"/>
            </xsl:attribute>
            <!-- Calculate the folio number for each side -->
            <xsl:variable name="folN">
                <xsl:choose>
                    <!-- paginated -->
                    <xsl:when test="contains($folioNumber, '-')">
                        <xsl:choose>
                            <xsl:when test="$side eq 'v'">
                                <xsl:value-of select="tokenize($folioNumber, '-')[2]"/>
                            </xsl:when>
                            <xsl:when test="$side eq 'r'">
                                <xsl:value-of select="tokenize($folioNumber, '-')[1]"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <!-- foliated -->
                    <xsl:otherwise>
                        <xsl:value-of select="concat($folioNumber, $side)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="folN">
                <xsl:value-of select="$folN"/>
            </xsl:attribute>
            <xsl:attribute name="url">
                <xsl:choose>
                    <xsl:when test="$image-list-spreadsheet-excel//ss:Row/ss:Cell/ss:Data/$folN">
                        <xsl:value-of
                            select="$image-list-spreadsheet-excel//ss:Row/ss:Cell/ss:Data[text() = $folN]/../following-sibling::ss:Cell[1]/ss:Data[1]/text()"
                        />
                    </xsl:when>
                    <xsl:when test="$missing eq 'yes'">
                        <xsl:text>
                            https://raw.githubusercontent.com/leoba/VisColl/master/data/support/images/x.jpg
                        </xsl:text>
                    </xsl:when>
                    <!-- same crossed image for stubs? -->
                    <xsl:when test="$stub eq 'yes'">
                        <xsl:text>
                            https://raw.githubusercontent.com/leoba/VisColl/master/data/support/images/x.jpg
                        </xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:copy-of select="$thisLeaf/child::*" copy-namespaces="no"/>
        </leaf>
    </xsl:template>

</xsl:stylesheet>
