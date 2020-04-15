<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:sic="http://www.schoenberginstitute.org/schema/collation"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.schoenberginstitute.org/schema/collation"
    exclude-result-prefixes="svg xlink sic xs" version="2.0">

    <xsl:output method="xml" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD SVG 1.1//EN"
        doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd" standalone="no"
        xpath-default-namespace="http://www.w3.org/2000/svg" exclude-result-prefixes="xlink"
        include-content-type="no"/>

    <!-- Parameter to be fed the source file name -->
    <xsl:param name="sourceFileName" select="'Wnnn'"/>
    
    <!-- Variable to extrapolate the manuscript ID from the source file name -->
    <xsl:variable name="msID" select="tokenize($sourceFileName, '_')[1]"/>

    <!-- X and Y reference values - i.e. the registration for the whole diagram, changing these values, the whole diagram can be moved -->
    <xsl:variable name="Ox" select="0"/>
    <xsl:variable name="Oy" select="$Ox"/>

    <!-- Value to determine the Y value of distance between the different components of the quire-->
    <xsl:variable name="delta" select="6"/>

    <!-- Variable to determine the length of the leaves in the diagram -->
    <xsl:variable name="leafLength" select="50"/>

    <xsl:template match="/">
        <xsl:for-each select="quires/quire">
            <xsl:result-document
                href="{concat('../wam-collation-SVG/', $msID, '/', $msID, '_quire_', @n, '.svg')}"
                method="xml" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD SVG 1.1//EN"
                doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
                <xsl:processing-instruction name="xml-stylesheet">
                    <xsl:text>href="../../CSS/style.css"&#32;</xsl:text>
                    <xsl:text>type="text/css"</xsl:text>
                </xsl:processing-instruction>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment>
                    <xsl:text>SVG file generated on: </xsl:text>
                    <xsl:value-of select="format-dateTime(current-dateTime(), '[D] [MNn] [Y] at [H]:[m]:[s]')"/>
                    <xsl:text> using </xsl:text>
                    <xsl:value-of select="system-property('xsl:product-name')"/>
                    <xsl:text> version </xsl:text>
                    <xsl:value-of select="system-property('xsl:product-version')"/>
                </xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <!-- The SVG output is for the moment an A4: change to smaller area -->
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                    version="1.1" x="0" y="0" width="297mm" height="210mm" viewBox="0 0 297 210"
                    preserveAspectRatio="xMidYMid meet">
                    <title>Collation diagram quire <xsl:value-of select="@n"/></title>
                    <!-- Call SVG definitions' template -->
                    <xsl:call-template name="defs"/>
                    <desc>Collation diagram quire <xsl:value-of select="@n"/></desc>
                    <svg>
                        <xsl:attribute name="x">
                            <xsl:value-of select="$Ox + 20"/>
                        </xsl:attribute>
                        <xsl:attribute name="y">
                            <xsl:value-of select="$Oy  + 20"/>
                        </xsl:attribute>
                        <!-- Variable to remove question marks from position numbering -->
                        <xsl:variable name="positions">
                            <xsl:choose>
                                <xsl:when test="contains(@positions, '?')">
                                    <xsl:value-of select="if (@positions eq '?') then 2 else xs:integer(translate(@positions, '?', ''))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@positions"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <!-- Call the template to draw the bifolia -->
                        <xsl:call-template name="bifoliaDiagram">
                            <xsl:with-param name="odd1_Even2"
                                select="if ($positions mod 2 = 0) then 2 else 1"/>
                            <xsl:with-param name="positions" select="$positions" as="xs:integer"/>
                        </xsl:call-template>
                    </svg>
                </svg>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="bifoliaDiagram">
        <xsl:param name="positions" select="1"/>
        <xsl:param name="odd1_Even2" select="2"/>
        <xsl:param name="counter" select="1"/>
        <xsl:param name="upper1_Lower2" select="1"/>
        <!-- Variable to count how many bifolia/singletons should be drawn -->
        <!-- if @positions is an even number the components are @positions/2, is odd (@positions+1)/2 -->
        <xsl:variable name="countComponents"
            select="if ($odd1_Even2 eq 2) then ($positions div 2) else (($positions + 1) div 2)"/>
        <!-- Variable to count how many bifolia the current one is wrapped around -->
        <xsl:variable name="followingComponents" select="$countComponents - $counter"/>
        <!-- Centre coordinates -->
        <xsl:variable name="Cx" select="$Ox + 20"/>
        <xsl:variable name="Cy" select="$Oy + ($delta * 1.5 + $delta * $countComponents)"/>
        <desc xmlns="http://www.w3.org/2000/svg">
            <xsl:text>Bifolium #</xsl:text>
            <xsl:value-of select="$counter"/>
        </desc>
        <!-- Bifolium -->
        <g xmlns="http://www.w3.org/2000/svg">
            <!-- Upper leaf -->
            <xsl:call-template name="leafPath">
                <xsl:with-param name="odd1_Even2" select="$odd1_Even2"/>
                <xsl:with-param name="counter" select="$counter"/>
                <xsl:with-param name="Cx" select="$Cx"/>
                <xsl:with-param name="Cy" select="$Cy"/>
                <xsl:with-param name="countComponents" select="$countComponents"/>
                <xsl:with-param name="followingComponents" select="$followingComponents"/>
                <xsl:with-param name="upper1_Lower2" select="1"/>
            </xsl:call-template>
            <!-- Lower leaf -->
            <xsl:call-template name="leafPath">
                <xsl:with-param name="odd1_Even2" select="$odd1_Even2"/>
                <xsl:with-param name="counter" select="$counter"/>
                <xsl:with-param name="Cx" select="$Cx"/>
                <xsl:with-param name="Cy" select="$Cy"/>
                <xsl:with-param name="countComponents" select="$countComponents"/>
                <xsl:with-param name="followingComponents" select="$followingComponents"/>
                <xsl:with-param name="upper1_Lower2" select="2"/>
            </xsl:call-template>
        </g>
        <!-- Delete missing leaves from visible drawn structure -->
        <xsl:for-each select="less">
            <xsl:choose>
                <xsl:when
                    test="if (xs:integer(text()) le $countComponents) then xs:integer(text()) eq $counter else ($positions - xs:integer(text())) + 1 eq $counter">
                    <desc xmlns="http://www.w3.org/2000/svg">
                        <xsl:text>Missing leaf #</xsl:text>
                        <xsl:value-of select="text()"/>
                    </desc>
                    <g xmlns="http://www.w3.org/2000/svg">
                        <!-- Deleted leaf -->
                        <xsl:call-template name="leafPath">
                            <xsl:with-param name="odd1_Even2" select="$odd1_Even2"/>
                            <xsl:with-param name="counter"
                                select="xs:integer(text()) + (if ($odd1_Even2 eq 1) then 1 else 0)"/>
                            <xsl:with-param name="Cx" select="$Cx"/>
                            <xsl:with-param name="Cy" select="$Cy"/>
                            <xsl:with-param name="countComponents" select="$countComponents"/>
                            <xsl:with-param name="followingComponents" select="$followingComponents"/>
                            <xsl:with-param name="upper1_Lower2"
                                select="if (xs:integer(text()) le $countComponents) then 1 else 2"/>
                            <xsl:with-param name="del" select="1"/>
                            <xsl:with-param name="absoluteY"
                                select="if (xs:integer(text()) le $countComponents) 
                                then $delta * ($countComponents - ($counter - 1)) 
                                else $delta * ($countComponents - (($positions - xs:integer(text()))))"
                            />
                        </xsl:call-template>
                    </g>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="$counter lt $countComponents">
                <xsl:call-template name="bifoliaDiagram">
                    <xsl:with-param name="counter" select="$counter + 1"/>
                    <xsl:with-param name="odd1_Even2" select="$odd1_Even2"/>
                    <xsl:with-param name="upper1_Lower2" select="1"/>
                    <xsl:with-param name="positions" select="$positions"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="leafPath" xmlns="http://www.w3.org/2000/svg">
        <xsl:param name="odd1_Even2" select="2"/>
        <xsl:param name="counter" select="1"/>
        <xsl:param name="Cx" select="$Ox + 20"/>
        <xsl:param name="Cy" select="$Cx"/>
        <xsl:param name="countComponents" select="4"/>
        <xsl:param name="followingComponents" select="3"/>
        <xsl:param name="upper1_Lower2"/>
        <xsl:param name="del" select="0"/>
        <xsl:param name="absoluteY" select="$delta * ($countComponents - ($counter - 1))"/>
        <!-- Parametric Y values for each leaf -->
        <xsl:variable name="parametricY">
            <xsl:choose>
                <xsl:when test="$upper1_Lower2 eq 1">
                    <xsl:value-of select="- $absoluteY"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$absoluteY"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <g xmlns="http://www.w3.org/2000/svg">
            <xsl:choose>
                <xsl:when test="($odd1_Even2 eq 1)">
                    <xsl:call-template name="certainty">
                        <xsl:with-param name="certainty" select="50"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="contains(@positions, '?')">
                    <xsl:call-template name="certainty">
                        <xsl:with-param name="certainty" select="50"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
            <!-- Draw line black or white -->
            <xsl:call-template name="CSSclass">
                <xsl:with-param name="odd1_Even2"
                    select="if ($upper1_Lower2 eq 1) then $odd1_Even2 else 2"/>
                <xsl:with-param name="counter" select="$counter"/>
                <xsl:with-param name="upper1_Lower2" select="$upper1_Lower2"/>
                <xsl:with-param name="del" select="$del"/>
            </xsl:call-template>
            <!-- arc -->
            <path stroke-linecap="round">
                <xsl:attribute name="d">
                    <xsl:text>M</xsl:text>
                    <xsl:value-of select="$Cx + ($delta * $countComponents) - 2"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$Cy + $parametricY"/>
                    <xsl:text>&#32;A</xsl:text>
                    <xsl:value-of select="$delta + ($followingComponents * $delta)"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$delta + ($followingComponents * $delta)"/>
                    <xsl:text>&#32;</xsl:text>
                    <xsl:value-of select="0"/>
                    <xsl:text>&#32;</xsl:text>
                    <xsl:value-of select="0"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="if ($upper1_Lower2 eq 1 ) then 0 else 1"/>
                    <xsl:text>&#32;</xsl:text>
                    <xsl:value-of
                        select="$Cx + ($delta * $countComponents) - 2 - ($delta - 1 + ($followingComponents * $delta))"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$Cy"/>
                </xsl:attribute>
            </path>
            <!-- line -->
            <path>
                <xsl:attribute name="d">
                    <xsl:text>M</xsl:text>
                    <xsl:value-of select="$Cx + $leafLength"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$Cy + $parametricY"/>
                    <xsl:text>&#32;L</xsl:text>
                    <xsl:value-of select="$Cx + ($delta * $countComponents) - 2"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$Cy + $parametricY"/>
                </xsl:attribute>
            </path>
        </g>
    </xsl:template>

    <!-- CSS class attribute template -->
    <xsl:template name="CSSclass">
        <xsl:param name="odd1_Even2"/>
        <xsl:param name="upper1_Lower2" select="1"/>
        <xsl:param name="counter"/>
        <xsl:param name="del" select="0"/>
        <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="$del eq 1">
                    <xsl:text>missingLeaf</xsl:text>
                </xsl:when>
                <xsl:when test="($odd1_Even2 eq 1) and ($counter eq 1)">
                    <xsl:text>ghostLeaf</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>leaf</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <!-- SVG definitions' template -->
    <xsl:template name="defs">
        <defs xmlns="http://www.w3.org/2000/svg">
            <filter id="f1" filterUnits="userSpaceOnUse">
                <feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
            </filter>
        </defs>
    </xsl:template>

    <!-- Uncertainty template -->
    <xsl:template name="certainty">
        <xsl:param name="certainty" select="100" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="$certainty lt 100">
                <xsl:attribute name="filter">
                    <xsl:text>url(#f1)</xsl:text>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
