<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:vc="http://viscoll.org/schema/collation" xmlns:tp="temporaryTree"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xpath-default-namespace="http://viscoll.org/schema/collation"
    exclude-result-prefixes="svg xlink vc xs tp xd" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 2018-01-05</xd:p>
            <xd:p><xd:b>Author:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>2019-06-05</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>2020-08-14</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>2020-12-04</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>2021-01-09</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>2021-01-15</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p>This document takes as its input the output from the Collation Modeler. It
                generates one SVG diagram per gathering. A general parameter permits to insert the
                CSS information directly into the SVG file.</xd:p>
        </xd:desc>
    </xd:doc>

    <xd:doc>
        <xd:desc>
            <xd:p>This stylesheet outputs a series of SVG files, one for each detected
                gathering</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output name="svg" method="xml" indent="yes" encoding="utf-8"
        doctype-public="-//W3C//DTD SVG 1.1//EN"
        doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd" standalone="no"
        xpath-default-namespace="http://www.w3.org/2000/svg" exclude-result-prefixes="xlink"
        include-content-type="no"/>

    <xd:doc>
        <xd:desc>
            <xd:p>This parameter permits selecting a choice between writing all page numbers in the
                SVG file (1) or only the first and last (0).</xd:p>
            <xd:p>0 = no; 1 = yes</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="allNumbers" select="0"/>

    <xd:doc>
        <xd:desc>
            <xd:p>This parameter permits selecting a choice between writing the gathering number in
                the SVG file (1) or not (0)</xd:p>
            <xd:p>0 = no; 1 = yes</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="gatheringNumbers" select="0"/>

    <xd:doc>
        <xd:desc>
            <xd:p>SVGs are referred to an external CSS file for styling. This parameter permits the
                inclusion of the CSS internally so that the file can always be visualized even if
                moved from its folder.</xd:p>
            <xd:p>0 = no (external CSS); 1 = yes (embedded)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="embedCSS" select="0"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Some visualizations require two paths per folio to show differences in each side,
                e.g., for parchment, hair and flesh side.</xd:p>
            <xd:p>This variable looks for a specific taxonomy terms
                (<xd:pre>'hairside' or 'fleshside'</xd:pre>) to select whether double paths are
                needed.</xd:p>
            <xd:p>0 = no; 1 = yes</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="doublePaths">
        <xsl:choose>
            <xsl:when test="boolean(//taxonomy/term/text() = 'hairside' or //taxonomy/term/text() = 'fleshside')">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Some visualizations require two paths per folio to show differences in each side,
                e.g., for parchment, hair and flesh side.</xd:p>
            <xd:p>This variable sets the displacement value for the second path.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="doublePathDisplacementValue" select="0.7"/>

    <xd:desc>
        <xd:p>Biocodicology visualizations assign a colour to each parchment species.</xd:p>
        <xd:p>This variable checks if a mapping for the animal species was encoded by looking for a
            specific taxonomy ID <xd:pre>//taxonomy/@xml:id = 'id-species'</xd:pre> and caters for
            this.</xd:p>
        <xd:p>0 = no; 1 = yes</xd:p>
    </xd:desc>
    <xsl:variable name="animalSpecies">
        <xsl:choose>
            <xsl:when test="//taxonomy/@xml:id = 'id-species'">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>This variable creates a temporary tree to store all the targets of each map The
                tree looks like this:</xd:p>
            <xd:p>
                <xd:pre><tp:targetLists xmlns:tp="temporaryTree">
                            <tp:targetList side="l" term="#id-fs">
                            <tp:target IDvalue="#id-ItIX876226_q1-1"/>
                            <tp:target IDvalue="#id-ItIX876226_q1-3"/>
                            <tp:target IDvalue="#id-ItIX876226_q1-5"/>
                             ... 
                            </tp:targetList>
                        </tp:targetLists></xd:pre>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="targetLists">
        <tp:targetLists>
            <xsl:for-each select="//viscoll/mapping/map">
                <tp:targetList>
                    <xsl:choose>
                        <xsl:when test="@side">
                            <xsl:attribute name="side">
                                <xsl:value-of select="@side"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:attribute name="term">
                        <xsl:value-of select="term/@target"/>
                    </xsl:attribute>
                    <xsl:for-each select="tokenize(@target, ' ')">
                        <xsl:choose>
                            <xsl:when test=". != ''">
                                <tp:target>
                                    <xsl:attribute name="IDvalue">
                                        <xsl:value-of select="."/>
                                    </xsl:attribute>
                                </tp:target>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </tp:targetList>
            </xsl:for-each>
        </tp:targetLists>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>This variable holds the relative path to the CSS file</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="pathToCSS" select="'../CSS/collation.css'"/>

    <xd:doc>
        <xd:desc>
            <xd:p>X reference value - i.e. the registration for the whole diagram, changing this
                value, the whole diagram can be moved (left-right)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="Ox" select="0"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Y reference value - i.e. the registration for the whole diagram, changing this
                value, the whole diagram can be moved (top-bottom)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="Oy" select="0"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Cx does not need to be parametric, so it can be established at this level, but it
                is called in the Cx template to keep Cx and Cy together</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="CxMain" select="$Ox + 20"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Value to determine the Y value of distance between the different components of the
                gathering</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="delta" select="6" as="xs:integer"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Variable to determine the minimum length of the leaves in the diagram</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="leafLength" select="50"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Variable to determine the maximum number of regular bifolia in a gathering in the
                whole model (even if there are more textblocks)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="maxRegFolIn1Gathering">
        <xsl:variable name="NRegFolInGatherings">
            <tp:gatherings>
                <!-- This groups leaves per gathering -->
                <xsl:for-each-group select="/viscoll//leaves/leaf" group-by="
                        if (contains(q[1]/@n, '.')) then
                            substring-before(q[1]/@n, '.')
                        else
                            q[1]/@n">
                    <xsl:variable name="positions">
                        <xsl:value-of select="xs:integer(count(current-group()))"/>
                    </xsl:variable>
                    <xsl:variable name="countSingletons">
                        <xsl:value-of select="count(current-group()/.[q[1]/single/@val = 'yes'])"/>
                    </xsl:variable>
                    <xsl:variable name="countSubquireLeaves">
                        <xsl:value-of
                            select="count(current-group()/.[contains(q[1]/@n, '.') and not(q[1]/single/@val = 'yes')])"
                        />
                    </xsl:variable>
                    <xsl:variable name="countRegularBifolia2" select="
                            (xs:integer($positions) - xs:integer($countSingletons) - $countSubquireLeaves)"/>
                    <tp:gathering>
                        <xsl:attribute name="regFolN">
                            <xsl:value-of select="$countRegularBifolia2"/>
                        </xsl:attribute>
                    </tp:gathering>
                </xsl:for-each-group>
            </tp:gatherings>
        </xsl:variable>
        <xsl:value-of select="max($NRegFolInGatherings/tp:gatherings/tp:gathering/@regFolN)"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Variable to determine the max number of figures needed to write the leaf
                numbers.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="MaxNLeaves">
        <xsl:value-of select="string-length(xs:string(count(//leaf))) + 3 * $delta"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Variable to determine the maximum number of letters for a roman numeral utilized
                to count the gatherings.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="MaxNGatherings">
        <xsl:variable name="getGatherings">
            <xsl:for-each-group select="/viscoll//leaves/leaf" group-by="
                    if (contains(q[1]/@n, '.')) then
                        substring-before(q[1]/@n, '.')
                    else
                        q[1]/@n">
                <tp:gathering>
                    <!-- count how many letters to simbolize the number of each gathering in roman numerals -->
                    <xsl:value-of select="string-length(xs:string(format-integer(position(), 'I')))"
                    />
                </tp:gathering>
            </xsl:for-each-group>
        </xsl:variable>
        <!-- Maximum number of letters for a roman numeral utilized -->
        <xsl:value-of select="max($getGatherings/tp:gathering/node())"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Main template to start generating files for each textblock: one item could be
                composed of more than one textblock and if coded in this manner the system will
                treat each textblock as independent (adding a number to the ID)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/" name="main">
        <!-- Each textblock is treated independently of the others -->
        <xsl:if test="viscoll/manuscript">
            <xsl:message terminate="no">Warning: Old schema, "manuscript" should be replaced with
                "textblock".</xsl:message>
        </xsl:if>
        <xsl:for-each select="viscoll/textblock | manuscript">
            <!-- Texblock position in bookblock -->
            <xsl:variable name="textblockN">
                <xsl:value-of select="position()"/>
            </xsl:variable>
            <!-- Shelfmark -->
            <xsl:variable name="shelfmark">
                <xsl:value-of select="shelfmark/text()"/>
            </xsl:variable>
            <!-- Variable to generate a textblock ID from the shelfmark.
                Only adds textblock number for more than one textblock in bookblock -->
            <xsl:variable name="tbID" select="
                    concat(translate($shelfmark, ' ', ''), if (xs:integer($textblockN) gt 1) then
                        concat('-', $textblockN)
                    else
                        '')"/>
            <!-- Copy of the whole textblock to manage inter-quire references -->
            <xsl:variable name="textblock">
                <xsl:copy-of select="."/>
            </xsl:variable>
            <!-- Code to divide the leaves into gatherings and initiate the SVG generation pipeline -->
            <xsl:call-template name="gatherings">
                <xsl:with-param name="tbID" select="$tbID"/>
                <xsl:with-param name="shelfmark" select="$shelfmark"/>
                <xsl:with-param name="textblock" select="$textblock"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template groups the leaves into gatherings and analyses the structure of the
                codex into a series of parameters containing the relevant information.</xd:p>
        </xd:desc>
        <xd:param name="tbID">
            <xd:p>Parameter to pass on the textblock ID generated from the shelfmark. Only adds
                textblock number for more than one textblock in bookblock.</xd:p>
        </xd:param>
        <xd:param name="shelfmark">
            <xd:p>The item's shelfmark</xd:p>
        </xd:param>
        <xd:param name="textblock">
            <xd:p>A copy of the whole textblock to manage inter-quire references.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="gatherings">
        <xsl:param name="tbID"/>
        <xsl:param name="shelfmark"/>
        <xsl:param name="textblock"/>
        <!-- quires are formed by grouping leaves according to the quire to which the are listed as belonging to;
        if there are subquires, these are listed a quire-number.subquire-number.etc: this code will group all leaves 
        in the same quire regardless of subquires -->
        <xsl:for-each-group select="leaves/leaf" group-by="
                if (contains(q[1]/@n, '.')) then
                    substring-before(q[1]/@n, '.')
                else
                    q[1]/@n">
            <xsl:variable name="gatheringNumber">
                <xsl:value-of select="current-grouping-key()"/>
            </xsl:variable>
            <xsl:variable name="positions">
                <xsl:value-of select="xs:integer(count(current-group()))"/>
            </xsl:variable>
            <!-- First leaf in the gathering (that is not 'missing' or is not a stub) -->
            <xsl:variable name="first">
                <xsl:for-each select="current-group()">
                    <xsl:choose>
                        <xsl:when test="position() eq 1">
                            <xsl:choose>
                                <xsl:when test="./mode/@val eq 'missing'">
                                    <xsl:value-of
                                        select="following-sibling::leaf[mode/@val != 'missing'][1]/@xml:id"
                                    />
                                </xsl:when>
                                <xsl:when test="@stub">
                                    <xsl:value-of
                                        select="following-sibling::leaf[not(@stub)][1]/@xml:id"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <!-- Last leaf in the gathering (that is not 'missing' or is not a stub) -->
            <xsl:variable name="last">
                <xsl:for-each select="current-group()">
                    <xsl:choose>
                        <xsl:when test="position() eq last()">
                            <xsl:choose>
                                <xsl:when test="./mode/@val eq 'missing'">
                                    <xsl:value-of
                                        select="preceding-sibling::leaf[mode/@val != 'missing'][1]/@xml:id"
                                    />
                                </xsl:when>
                                <xsl:when test="@stub">
                                    <xsl:value-of
                                        select="preceding-sibling::leaf[not(@stub)][1]/@xml:id"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <!-- Variable to manage subquires -->
            <xsl:variable name="subquires">
                <!-- Group subquires by level -->
                <xsl:for-each-group select="current-group()/.[q[1]/@n[contains(., '.')]]"
                    group-by="q[1]/@n">
                    <tp:subquire>
                        <xsl:attribute name="positions_SQ">
                            <xsl:value-of select="xs:integer(count(current-group()))"/>
                        </xsl:attribute>
                        <xsl:attribute name="subquireLevel">
                            <xsl:value-of
                                select="string-length(q[1]/@n) - string-length(translate(q[1]/@n, '.', ''))"
                            />
                        </xsl:attribute>
                        <xsl:copy-of select="current-group()"/>
                    </tp:subquire>
                </xsl:for-each-group>
            </xsl:variable>
            <!-- Variable to count the number of singletons in the quire -->
            <!-- Singletons are folios with the following pattern: /viscoll/textblock/leaves/leaf/q/single/@val="yes" 
            Whilst folios whose cognate has @mode with value 'missing' are technically singletons they are not counted here as they do not alter the symmetry of the diagram.-->
            <xsl:variable name="countSingletons">
                <xsl:value-of select="count(current-group()/.[q[1]/single/@val = 'yes'])"/>
            </xsl:variable>
            <!-- Variable to count the number of leaves in subquires -->
            <xsl:variable name="countSubquireLeaves">
                <xsl:value-of
                    select="count(current-group()/.[contains(q[1]/@n, '.') and not(q[1]/single/@val = 'yes')])"
                />
            </xsl:variable>
            <!-- Variable to count if number of leaves in group is odd (1) or even (2) -->
            <xsl:variable name="odd1_Even2">
                <xsl:value-of select="
                        xs:integer(
                        if ($positions mod 2 = 0) then
                            2
                        else
                            1)"/>
            </xsl:variable>
            <!-- Variable to count how many bifolia should be drawn -->
            <!-- if the total number of positions is an even number the components are the total number of positions/2, 
            if odd = (the total number of positions - total number of singletons)/2 -->
            <xsl:variable name="countRegularBifolia" select="
                    if (xs:integer($odd1_Even2) eq 2) then
                        (xs:integer($positions) div 2)
                    else
                        ((xs:integer($positions) - xs:integer($countSingletons)) div 2)"/>
            <!-- Refined variable that only counts regular bifolia in the main quire -->
            <xsl:variable name="countRegularBifolia2" select="
                    (xs:integer($positions) - xs:integer($countSingletons) - $countSubquireLeaves) div 2"/>
            <!-- Variable to find the left regular inner leaf position:
        it avoids singletons (inside complex gatherings) and leaves belonging to subquires-->
            <xsl:variable name="centralLeftLeafPos">
                <xsl:choose>
                    <!-- If a quire is composed by all singletons, then there cannot be a middle leaf
                and there are no conjoines, so the variable simply returns the number of singletons in that quire -->
                    <xsl:when test="
                            every $leaf in current-group()
                                satisfies $leaf/q[1]/single[@val = 'yes']">
                        <xsl:value-of select="count(current-group())"/>
                    </xsl:when>
                    <!-- Orphan subquires, i.e. subquires without (a) parent leaf/leaves from a main quire -->
                    <xsl:when test="
                            every $leaf in current-group()
                                satisfies $leaf/q/contains(@n, '.')">
                        <xsl:value-of select="count(current-group())"/>
                    </xsl:when>
                    <!-- For normal and complex quires, the variable returns the position of the last leaf 
                to be drawn in the left (upper) part of the quire -->
                    <xsl:otherwise>
                        <xsl:for-each
                            select="current-group()/.[not(q[1]/single/@val = 'yes' or contains(q[1]/@n, '.'))]">
                            <xsl:variable name="ownIdRef">
                                <xsl:value-of select="concat('#', @xml:id)"/>
                            </xsl:variable>
                            <!-- The pattern looks for the next regular folio -->
                            <xsl:variable name="followingConjoinID">
                                <xsl:value-of
                                    select="(following-sibling::leaf[not(q[1]/single/@val = 'yes' or contains(q[1]/@n, '.'))])[1]/q[1]/conjoin/@target"
                                />
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$followingConjoinID = $ownIdRef">
                                    <xsl:value-of select="xs:integer(q[1]/@position)"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- Variable to check for subquires in the middle of the quire that belong to the left half of the quire -->
            <xsl:variable name="extraCentralSubquireLeft">
                <xsl:choose>
                    <!-- if there are subquires with position greater than the central left leaf but still in the left half-->
                    <xsl:when
                        test="current-group()/.[contains(q[1]/@n, '.') and q[1]/@position - xs:integer($centralLeftLeafPos) eq 1]">
                        <xsl:variable name="extraCentralSubquireLeftN">
                            <xsl:value-of
                                select="current-group()/.[contains(q[1]/@n, '.') and q[1]/@position - xs:integer($centralLeftLeafPos) eq 1]/q[1]/@n"
                            />
                        </xsl:variable>
                        <xsl:value-of
                            select="count(current-group()/.[q[1]/@n eq $extraCentralSubquireLeftN])"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Cx">
                <xsl:call-template name="Cx"/>
            </xsl:variable>
            <!-- Variable to store the end of line x value to write folio numbers (in R-L direction) -->
            <xsl:variable name="endOfLineX">
                <xsl:value-of
                    select="($Cx + ($delta * $countRegularBifolia - 2)) + ($leafLength + ((($maxRegFolIn1Gathering div 2) - $countRegularBifolia2) * $delta))"
                />
            </xsl:variable>
            <!-- Call template to initiate the SVG generation pipeline -->
            <xsl:call-template name="svg">
                <xsl:with-param name="tbID" select="$tbID"/>
                <xsl:with-param name="first" select="$first"/>
                <xsl:with-param name="last" select="$last"/>
                <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
                <xsl:with-param name="positions" select="$positions"/>
                <xsl:with-param name="shelfmark" select="$shelfmark"/>
                <xsl:with-param name="textblock" select="$textblock"/>
                <xsl:with-param name="subquires" select="$subquires"/>
                <xsl:with-param name="countSingletons" select="$countSingletons"/>
                <xsl:with-param name="countSubquireLeaves" select="$countSubquireLeaves"/>
                <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
                <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
                <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                <xsl:with-param name="extraCentralSubquireLeft" select="$extraCentralSubquireLeft"/>
                <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
            </xsl:call-template>
        </xsl:for-each-group>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template initiates the SVG pipeline. The parameters necessary to draw the
                gatherings are passed from the previous template.</xd:p>
        </xd:desc>
        <xd:param name="tbID">
            <xd:p>Parameter to pass on the textblock ID generated from the shelfmark. Only adds
                textblock number for more than one textblock in bookblock.</xd:p>
        </xd:param>
        <xd:param name="gatheringNumber">
            <xd:p>The gathering number.</xd:p>
        </xd:param>
        <xd:param name="positions">
            <xd:p>The total number of leaves in the gathering.</xd:p>
        </xd:param>
        <xd:param name="shelfmark">
            <xd:p>The item's shelfmark.</xd:p>
        </xd:param>
        <xd:param name="textblock">
            <xd:p>A copy of the whole textblock to manage inter-quire references.</xd:p>
        </xd:param>
        <xd:param name="subquires">
            <xd:p>Parameter to manage subquires.</xd:p>
        </xd:param>
        <xd:param name="countSingletons">
            <xd:p>Variable to count the number of singletons in the quire</xd:p>
            <xd:p>Singletons are folios with the following pattern:
                <xd:pre>/viscoll/textblock/leaves/leaf/q/single/@val="yes"</xd:pre>. Whilst folios
                whose cognate has <xd:pre>@mode</xd:pre> with value 'missing' are technically
                singletons they are not counted here as they do not alter the symmetry of the
                diagram.</xd:p>
        </xd:param>
        <xd:param name="countSubquireLeaves">
            <xd:p>Parameter to count the number of leaves in subquires.</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
        <xd:param name="extraCentralSubquireLeft">
            <xd:p>Parameter to check for subquires in the middle of the quire that belong to the
                left half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="last">
            <xd:p>Last leaf in the gathering (that is not 'missing' or is not a stub).</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="svg">
        <xsl:param name="tbID"/>
        <xsl:param name="first"/>
        <xsl:param name="last"/>
        <xsl:param name="gatheringNumber"/>
        <xsl:param name="positions"/>
        <xsl:param name="shelfmark"/>
        <xsl:param name="textblock"/>
        <xsl:param name="subquires"/>
        <xsl:param name="countSingletons"/>
        <xsl:param name="countSubquireLeaves"/>
        <xsl:param name="countRegularBifolia"/>
        <xsl:param name="countRegularBifolia2"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:param name="extraCentralSubquireLeft"/>
        <xsl:param name="endOfLineX"/>
        <!-- Parametric leaflength for View Box: to get the max x value -->
        <xsl:variable name="GenParametricLeaflength">
            <xsl:value-of
                select="$leafLength + ((($maxRegFolIn1Gathering div 2) - $countRegularBifolia2) * $delta)"
            />
        </xsl:variable>
        <!-- Each quire is drawn on a different SVG file -->
        <xsl:result-document href="{concat('../SVG/', $tbID, '-', $gatheringNumber, '.svg')}"
            method="xml" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD SVG 1.1//EN"
            doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
            <!-- Record date and time of transformation -->
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
            <!-- Set the scene's dimensions and 
                viewBox: 
                MinX=0
                MinY=0
                MaxX=(maximum leaf legth + maximum distance of arcs + distance of folioNumbers from end of line + max space occupied by folio numbers (1 $delta per figure) + max space occupied by gathering number (1 $delta per figure)
                MaxY=$delta * number of leaves + 4*$delta (for margins)
            -->
            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                version="1.1" x="0" y="0" preserveAspectRatio="xMidYMid meet"
                viewBox="0 0 {($GenParametricLeaflength) + $delta * ($positions) + ((2 * $delta) + ($delta * $MaxNLeaves)) + ($delta * $MaxNGatherings)} {$delta * ($positions) + 4*$delta}">
                <!-- Quire description -->
                <xsl:variable name="description"> Collation diagram of quire <xsl:value-of
                        select="$gatheringNumber"/> for <xsl:value-of select="$shelfmark"/> composed
                    of <xsl:value-of select="$positions"/>
                    <xsl:value-of select="
                            (if ((xs:integer($positions) gt 1)) then
                                ' leaves'
                            else
                                ' leaf')"/>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space($description)"/>
                </title>
                <!-- Call SVG definitions' template: it defines the uncertainty filter and the glued pattern -->
                <xsl:call-template name="defs"/>
                <desc>
                    <xsl:value-of select="normalize-space($description)"/>
                </desc>
                <!-- Main grouping for the quire: sets its coordinate system -->
                <svg>
                    <xsl:attribute name="x">
                        <xsl:value-of select="$Ox"/>
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$Oy"/>
                    </xsl:attribute>
                    <g>
                        <!-- Writing Direction -->
                        <xsl:variable name="direction" select="ancestor::textblock/direction/@val"/>
                        <!-- Rotate diagrams if r-l -->
                        <xsl:call-template name="writingDirRotation">
                            <xsl:with-param name="direction" select="$direction"/>
                            <xsl:with-param name="text" select="0"/>
                            <xsl:with-param name="extraCentralSubquireLeft"
                                select="$extraCentralSubquireLeft"/>
                            <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                        </xsl:call-template>
                        <!-- Call the template to draw the regular bifolia -->
                        <xsl:call-template name="bifoliaDiagram">
                            <xsl:with-param name="positions" select="$positions" as="xs:integer"/>
                            <xsl:with-param name="first" select="$first"/>
                            <xsl:with-param name="last" select="$last"/>
                            <xsl:with-param name="subquires" select="$subquires"/>
                            <xsl:with-param name="textblock">
                                <xsl:copy-of select="$textblock"/>
                            </xsl:with-param>
                            <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
                            <xsl:with-param name="countSingletons" select="$countSingletons"/>
                            <xsl:with-param name="countSubquireLeaves" select="$countSubquireLeaves"/>
                            <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
                            <xsl:with-param name="countRegularBifolia2"
                                select="$countRegularBifolia2"/>
                            <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                            <xsl:with-param name="extraCentralSubquireLeft"
                                select="$extraCentralSubquireLeft"/>
                            <xsl:with-param name="direction" select="$direction" tunnel="yes"/>
                            <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                        </xsl:call-template>
                    </g>
                </svg>
            </svg>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template prepares the data for the drawing of the regular bifolia. The
                parameters necessary to draw the gatherings are passed from the previous
                template.</xd:p>
        </xd:desc>
        <xd:param name="textblock">
            <xd:p>A copy of the whole textblock to manage inter-quire references.</xd:p>
        </xd:param>
        <xd:param name="positions">
            <xd:p>The total number of leaves in the gathering.</xd:p>
        </xd:param>
        <xd:param name="subquires">
            <xd:p>Parameter to manage subquires.</xd:p>
        </xd:param>
        <xd:param name="gatheringNumber">
            <xd:p>The gathering number.</xd:p>
        </xd:param>
        <xd:param name="countSingletons">
            <xd:p>Variable to count the number of singletons in the quire</xd:p>
            <xd:p>Singletons are folios with the following pattern:
                <xd:pre>/viscoll/textblock/leaves/leaf/q/single/@val="yes"</xd:pre>. Whilst folios
                whose cognate has <xd:pre>@mode</xd:pre> with value 'missing' are technically
                singletons they are not counted here as they do not alter the symmetry of the
                diagram.</xd:p>
        </xd:param>
        <xd:param name="countSubquireLeaves">
            <xd:p>Parameter to count the number of leaves in subquires.</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
        <xd:param name="extraCentralSubquireLeft">
            <xd:p>Parameter to check for subquires in the middle of the quire that belong to the
                left half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="last">
            <xd:p>Last leaf in the gathering (that is not 'missing' or is not a stub).</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="bifoliaDiagram">
        <xsl:param name="first"/>
        <xsl:param name="last"/>
        <xsl:param name="textblock"/>
        <xsl:param name="positions" select="1"/>
        <xsl:param name="subquires"/>
        <xsl:param name="gatheringNumber"/>
        <xsl:param name="countSingletons"/>
        <xsl:param name="countSubquireLeaves"/>
        <xsl:param name="countRegularBifolia"/>
        <xsl:param name="countRegularBifolia2"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:param name="extraCentralSubquireLeft"/>
        <xsl:param name="endOfLineX"/>
        <xsl:param name="direction"/>
        <!-- At first, only draw regular bifolia, no subquires -->
        <xsl:for-each select="current-group()/.[not(q[1]/@n[contains(., '.')])]">
            <xsl:variable name="currentPosition">
                <xsl:value-of select="xs:integer(q[1]/@position)"/>
            </xsl:variable>
            <xsl:variable name="conjoinID">
                <!-- finds the ID of the conjoned leaf, removing the # symbol -->
                <xsl:value-of select="q[1]/conjoin/replace(@target, '#', '')"/>
            </xsl:variable>
            <!-- Finds the position of the conjoined leaf -->
            <xsl:variable name="conjoinPosition">
                <xsl:call-template name="conjoinPosition">
                    <xsl:with-param name="test" select="q[1]/conjoin"/>
                    <xsl:with-param name="conjoinPos"
                        select="ancestor::textblock/leaves/leaf[@xml:id = $conjoinID]/q[1]/@position"
                    />
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to generate a unique ID that puts together conjoined leaf positions in the correct order -->
            <xsl:variable name="ID-conjoined">
                <xsl:call-template name="ID-conjoined">
                    <xsl:with-param name="conjoinPosition" select="$conjoinPosition"/>
                    <xsl:with-param name="currentPosition" select="$currentPosition"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to determine if the current folio is in the left or the right half of the quire -->
            <xsl:variable name="left1_Right2">
                <xsl:call-template name="left1_Right2">
                    <xsl:with-param name="test" select="q[1]/single/@val"/>
                    <xsl:with-param name="currentPosition" select="$currentPosition"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="sq" select="0"/>
                    <xsl:with-param name="attachmentMethod" select="attachment-method/@target"/>
                    <xsl:with-param name="precedingLeafID"
                        select="preceding-sibling::leaf[1]/@xml:id"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to count how many folios the current one is wrapped around -->
            <xsl:variable name="followingComponents">
                <xsl:call-template name="followingComponents">
                    <xsl:with-param name="sq" select="0"/>
                    <xsl:with-param name="left1_Right2" select="$left1_Right2"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="currentPosition" select="$currentPosition"/>
                    <xsl:with-param name="extraCentralSubquireLeft"
                        select="$extraCentralSubquireLeft"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to count how many regular bifolia the current folio is wrapped around -->
            <xsl:variable name="followingRegularComponents">
                <xsl:call-template name="followingRegularComponents">
                    <xsl:with-param name="left1_Right2" select="$left1_Right2"/>
                    <xsl:with-param name="countRegularComponentsLeft"
                        select="count(following-sibling::leaf[q[1]/@n = current-grouping-key() and not(q[1]/single/@val = 'yes' or contains(q[1]/@n, '.')) and ./q[1]/xs:integer(@position) le xs:integer($centralLeftLeafPos)])"/>
                    <xsl:with-param name="countRegularComponentsRight"
                        select="count(preceding-sibling::leaf[q[1]/@n = current-grouping-key() and not(q[1]/single/@val = 'yes' or contains(q[1]/@n, '.')) and ./q[1]/xs:integer(@position) gt xs:integer($centralLeftLeafPos)])"
                    />
                </xsl:call-template>
            </xsl:variable>
            <!-- Centre coordinates -->
            <xsl:variable name="Cx">
                <xsl:call-template name="Cx"/>
            </xsl:variable>
            <xsl:variable name="Cy">
                <xsl:call-template name="Cy">
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Set group and drawing direction -->
            <g xmlns="http://www.w3.org/2000/svg">
                <!-- Add the xml:id of the folio -->
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <!-- Folio description -->
                <desc xmlns="http://www.w3.org/2000/svg">
                    <xsl:text>Folio #</xsl:text>
                    <xsl:value-of select="q[1]/@position"/>
                </desc>
                <!-- Draw folio -->
                <xsl:call-template name="leafPath">
                    <xsl:with-param name="positions" select="$positions"/>
                    <xsl:with-param name="first" select="$first"/>
                    <xsl:with-param name="last" select="$last"/>
                    <xsl:with-param name="Cx" select="$Cx"/>
                    <xsl:with-param name="Cy" select="$Cy"/>
                    <xsl:with-param name="textblock" select="$textblock"/>
                    <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
                    <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
                    <xsl:with-param name="countSubquireLeaves" select="$countSubquireLeaves"/>
                    <xsl:with-param name="followingComponents" select="$followingComponents"
                        as="xs:float"/>
                    <xsl:with-param name="followingRegularComponents"
                        select="$followingRegularComponents" as="xs:integer"/>
                    <xsl:with-param name="left1_Right2" select="$left1_Right2"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="conjoinPosition" select="$conjoinPosition"/>
                    <xsl:with-param name="ID-conjoined" select="$ID-conjoined"/>
                    <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                    <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
                </xsl:call-template>
            </g>
        </xsl:for-each>
        <!-- Then draw also the subquires -->
        <xsl:choose>
            <xsl:when test="current-group()/./q[1]/@n[contains(., '.')]">
                <!-- Number of subquires: number of iterations -->
                <xsl:variable name="NSubquires" select="count($subquires/tp:subquire)"
                    as="xs:integer"/>
                <xsl:call-template name="bifoliaDiagram_SQ">
                    <xsl:with-param name="first" select="$first"/>
                    <xsl:with-param name="last" select="$last"/>
                    <xsl:with-param name="subquires">
                        <xsl:copy-of select="$subquires"/>
                    </xsl:with-param>
                    <xsl:with-param name="textblock">
                        <xsl:copy-of select="$textblock"/>
                    </xsl:with-param>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"
                        as="xs:integer"/>
                    <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
                    <xsl:with-param name="countSubquireLeaves" select="$countSubquireLeaves"/>
                    <xsl:with-param name="NSubquires" select="$NSubquires" as="xs:integer"/>
                    <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                    <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rotate diagrams if r-l.</xd:desc>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
        <xd:param name="text">
            <xd:p>Parameter to determine where the template is called.</xd:p>
            <xd:p>text = 0 (main mirroring of the whole diagram for R-L);</xd:p>
            <xd:p>text = 1 (folio numbers);</xd:p>
            <xd:p>text = 2 (gathering numbers).</xd:p>
        </xd:param>
        <xd:param name="extraCentralSubquireLeft">
            <xd:p>Parameter to check for subquires in the middle of the quire that belong to the
                left half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="writingDirRotation">
        <xsl:param name="direction"/>
        <xsl:param name="text" select="0"/>
        <xsl:param name="extraCentralSubquireLeft" as="xs:integer" select="0"/>
        <xsl:param name="endOfLineX"/>
        <xsl:choose>
            <xsl:when test="$direction = 'r-l'">
                <xsl:attribute name="transform">
                    <!-- If there is a subquire at the centre the drawings are pushed up outside the binding box,
                        this hack moves the whole diagram down -->
                    <xsl:choose>
                        <xsl:when test="xs:integer($extraCentralSubquireLeft) != 0">
                            <xsl:value-of
                                select="concat('translate(0,', $delta * ($extraCentralSubquireLeft), ')')"
                            />
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$text = 0">
                            <!-- Matrix='-1 0 0 1 width of drawing 0' -->
                            <xsl:text>matrix(-1 0 0 1 </xsl:text>
                            <xsl:value-of
                                select="(xs:integer($endOfLineX) + xs:integer($MaxNLeaves) + 2 * $delta)"/>
                            <xsl:text> 0)</xsl:text>
                        </xsl:when>
                        <xsl:when test="$text = 1">
                            <xsl:text>translate(</xsl:text>
                            <xsl:value-of select="($endOfLineX * 2) + ($delta)"/>
                            <xsl:text> 0) scale(-1 1)</xsl:text>
                        </xsl:when>
                        <xsl:when test="$text = 2">
                            <xsl:text>translate(</xsl:text>
                            <xsl:value-of select="(4 * $delta)"/>
                            <xsl:text> 0) scale(-1 1)</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$direction = 'l-r'">
                <xsl:attribute name="transform">
                    <!-- If there is a subquire at the centre the drawings are pushed up outside the view box,
                        this hack moves the whole diagram down -->
                    <!-- If the numeral for the Gathering are longer than 4 figures these are outside the view box -->
                    <xsl:variable name="gatheringNumberTranslation">
                        <xsl:choose>
                            <xsl:when test="xs:integer($MaxNGatherings) > 4 and $text = 0">
                                <xsl:value-of select="xs:integer($MaxNGatherings) - 4"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="
                            concat('translate(', $gatheringNumberTranslation * $delta, ' ', if (xs:integer($extraCentralSubquireLeft) != 0) then
                                $delta * ($extraCentralSubquireLeft)
                            else
                                0, ')')"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Confirms the value of Cx</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="Cx">
        <xsl:value-of select="$CxMain"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Calculates Cy</xd:p>
        </xd:desc>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="Cy">
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:value-of select="$Oy + ($delta * 1.5 + $delta * $centralLeftLeafPos)"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template finds the position of the conjoined leaf.</xd:p>
            <xd:p>If there is a conjoined leaf, then the position is returned, otherwise 0</xd:p>
        </xd:desc>
        <xd:param name="test">
            <xd:p>Whether the leaf has a conjoin:</xd:p>
            <xd:p>
                <xd:pre>q[1]/conjoin</xd:pre>
            </xd:p>
        </xd:param>
        <xd:param name="conjoinPos">
            <xd:p>The position of the conjoined leaf.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="conjoinPosition">
        <xsl:param name="test"/>
        <xsl:param name="conjoinPos"/>
        <xsl:choose>
            <xsl:when test="$test">
                <xsl:value-of select="$conjoinPos"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Parameter to generate a unique ID that puts together conjoined leaf positions in
                the correct order.</xd:p>
        </xd:desc>
        <xd:param name="conjoinPosition">
            <xd:p>The position of the conjoined leaf.</xd:p>
        </xd:param>
        <xd:param name="currentPosition">
            <xd:p>The position of the current leaf.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="ID-conjoined">
        <xsl:param name="conjoinPosition"/>
        <xsl:param name="currentPosition"/>
        <xsl:choose>
            <!-- there is no conjoin -->
            <xsl:when test="$conjoinPosition = 0">
                <xsl:value-of select="$currentPosition"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="
                        if (xs:integer($currentPosition) lt xs:integer($conjoinPosition)) then
                            concat($currentPosition, '-', $conjoinPosition)
                        else
                            concat($conjoinPosition, '-', $currentPosition)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Parameter to determine if the current folio is in the left or the right half of
                the gathering.</xd:p>
        </xd:desc>
        <xd:param name="test">
            <xd:p>If there is a single leaf</xd:p>
            <xd:pre>q[1]/single/@val</xd:pre>
        </xd:param>
        <xd:param name="test2">
            <xd:p>If the leaf is in a subquire</xd:p>
            <xd:pre>contains(q[1]/@n, '.')</xd:pre>
        </xd:param>
        <xd:param name="test3">
            <xd:p>If the leaf is in the left half of the subquire</xd:p>
            <xd:pre>(xs:integer(parent::tp:subquire/vc:leaf[1]/vc:q[1]/@position) - xs:integer($centralLeftLeafPos)) le 1</xd:pre>
        </xd:param>
        <xd:param name="currentPosition">
            <xd:p>The position of the current leaf.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
        <xd:param name="attachmentMethod">
            <xd:p>The current leaf's attachment method.</xd:p>
        </xd:param>
        <xd:param name="precedingLeafID">
            <xd:p>The ID of the preceding leaf.</xd:p>
        </xd:param>
        <xd:param name="sq">
            <xd:p>If the current leaf is in a subquire</xd:p>
            <xd:p>0 = no; 1 = yes</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="left1_Right2">
        <xsl:param name="test"/>
        <xsl:param name="test2"/>
        <xsl:param name="test3"/>
        <xsl:param name="currentPosition"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:param name="attachmentMethod"/>
        <xsl:param name="precedingLeafID"/>
        <xsl:param name="sq" select="0"/>
        <xsl:choose>
            <!-- Avoids irregular folios: singletons -->
            <xsl:when test="$test eq 'yes'">
                <xsl:choose>
                    <!-- if its position is less than the middle bifolio it is in the left half -->
                    <xsl:when test="xs:integer($currentPosition) le xs:integer($centralLeftLeafPos)">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <!-- if its position is greater than the central uppler leaf and is is attached to it
                            it is still in the left half-->
                    <xsl:when
                        test="(xs:integer($currentPosition) - xs:integer($centralLeftLeafPos) eq 1) and ($attachmentMethod eq concat('#', $precedingLeafID))">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$sq = 1">
                <xsl:choose>
                    <!-- Irregular folios: subquires -->
                    <xsl:when test="$test2">
                        <!-- Number of the subquire -->
                        <xsl:choose>
                            <!-- if the position is less than the middle bifolio it is in the left half -->
                            <xsl:when
                                test="xs:integer($currentPosition) le xs:integer($centralLeftLeafPos)">
                                <xsl:value-of select="1"/>
                            </xsl:when>
                            <!-- if its position is greater than the central uppler leaf but is still in the left half-->
                            <xsl:when test="$test3">
                                <!-- (xs:integer($currentPosition) gt xs:integer($centralLeftLeafPos)) and  -->
                                <xsl:value-of select="1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="2"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- Regular bifolia -->
            <xsl:otherwise>
                <xsl:value-of select="
                        if (xs:integer($currentPosition) le xs:integer($centralLeftLeafPos)) then
                            1
                        else
                            2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to count how many folios the current one is wrapped around.</xd:p>
        </xd:desc>
        <xd:param name="left1_Right2">
            <xd:p>If the current folio is in the left or the right half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
        <xd:param name="currentPosition">
            <xd:p>The position of the current leaf.</xd:p>
        </xd:param>
        <xd:param name="extraCentralSubquireLeft">
            <xd:p>Parameter to check for subquires in the middle of the quire that belong to the
                left half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="sq">
            <xd:p>If the current leaf is in a subquire</xd:p>
            <xd:p>0 = no; 1 = yes</xd:p>
        </xd:param>
        <xd:param name="left1_Right2_SQ">
            <xd:p>If the current folio is in the left or the right half of the subquire.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos_SQ">
            <xd:p>Parameter to find the left regular inner leaf position within subquires.</xd:p>
        </xd:param>
        <xd:param name="currentPosition_SQ">
            <xd:p>The position of the current leaf within the subquire.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="followingComponents">
        <xsl:param name="left1_Right2"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:param name="currentPosition"/>
        <xsl:param name="extraCentralSubquireLeft"/>
        <xsl:param name="sq" select="0"/>
        <xsl:param name="left1_Right2_SQ"/>
        <xsl:param name="centralLeftLeafPos_SQ"/>
        <xsl:param name="currentPosition_SQ"/>
        <xsl:choose>
            <xsl:when test="$sq = 1">
                <xsl:choose>
                    <!-- If left half of the quire -->
                    <xsl:when test="$left1_Right2_SQ = 1">
                        <xsl:value-of
                            select="xs:integer($centralLeftLeafPos_SQ) - xs:integer($currentPosition_SQ)"
                        />
                    </xsl:when>
                    <!-- If right half of the quire -->
                    <xsl:when test="$left1_Right2_SQ = 2">
                        <xsl:value-of
                            select="xs:integer($currentPosition_SQ) - (xs:integer($centralLeftLeafPos_SQ) + 1)"
                        />
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- If left half of the quire -->
                    <xsl:when test="$left1_Right2 = 1">
                        <xsl:value-of
                            select="xs:integer($centralLeftLeafPos) - xs:integer($currentPosition) + $extraCentralSubquireLeft"
                        />
                    </xsl:when>
                    <!-- If right half of the quire -->
                    <xsl:when test="$left1_Right2 = 2">
                        <xsl:value-of
                            select="xs:integer($currentPosition) - (xs:integer($centralLeftLeafPos) + 1) - $extraCentralSubquireLeft"
                        />
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to count how many regular bifolia the current folio is wrapped
                around.</xd:p>
        </xd:desc>
        <xd:param name="left1_Right2">
            <xd:p>If the current folio is in the left or the right half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="countRegularComponentsLeft">
            <xd:p>The number of regular components to the left of the current leaf.</xd:p>
        </xd:param>
        <xd:param name="countRegularComponentsRight">
            <xd:p>The number of regular components to the right of the current leaf.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="followingRegularComponents">
        <xsl:param name="left1_Right2"/>
        <xsl:param name="countRegularComponentsLeft"/>
        <xsl:param name="countRegularComponentsRight"/>
        <xsl:choose>
            <!-- If left half of the quire -->
            <xsl:when test="$left1_Right2 = 1">
                <xsl:value-of select="$countRegularComponentsLeft"/>
            </xsl:when>
            <!-- If right half of the quire -->
            <xsl:when test="$left1_Right2 = 2">
                <xsl:value-of select="$countRegularComponentsRight"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template draws regular bifolia. The parameters necessary to draw the
                gatherings are passed from the previous template.</xd:p>
        </xd:desc>
        <xd:param name="Cx">
            <xd:p>The value of Cx</xd:p>
        </xd:param>
        <xd:param name="Cy">
            <xd:p>The value of Cy</xd:p>
        </xd:param>
        <xd:param name="textblock">
            <xd:p>A copy of the whole textblock to manage inter-quire references.</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="countSubquireLeaves">
            <xd:p>Parameter to count the number of leaves in subquires.</xd:p>
        </xd:param>
        <xd:param name="followingComponents">
            <xd:p>Parameter to count how many folios the current one is wrapped around.</xd:p>
        </xd:param>
        <xd:param name="followingRegularComponents">
            <xd:p>Parameter to count how many regular bifolia the current folio is wrapped
                around.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
        <xd:param name="left1_Right2">
            <xd:p>If the current folio is in the left or the right half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="conjoinPosition">
            <xd:p>The position of the conjoined leaf.</xd:p>
        </xd:param>
        <xd:param name="ID-conjoined">
            <xd:p>The ID of the conjoined leaf.</xd:p>
        </xd:param>
        <xd:param name="positions">
            <xd:p>The total number of leaves in the gathering.</xd:p>
        </xd:param>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="last">
            <xd:p>Last leaf in the gathering (that is not 'missing' or is not a stub).</xd:p>
        </xd:param>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
        <xd:param name="gatheringNumber">
            <xd:p>The gathering number.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="leafPath">
        <xsl:param name="positions"/>
        <xsl:param name="first"/>
        <xsl:param name="last"/>
        <xsl:param name="Cx" select="$Ox + 20"/>
        <xsl:param name="Cy" select="$Cx"/>
        <xsl:param name="textblock"/>
        <xsl:param name="countRegularBifolia" select="4"/>
        <xsl:param name="countRegularBifolia2" select="4"/>
        <xsl:param name="countSubquireLeaves"/>
        <xsl:param name="followingComponents" select="3" as="xs:float"/>
        <xsl:param name="followingRegularComponents" select="1" as="xs:integer"/>
        <xsl:param name="centralLeftLeafPos" select="1" as="xs:integer"/>
        <xsl:param name="left1_Right2"/>
        <xsl:param name="conjoinPosition" select="0"/>
        <xsl:param name="ID-conjoined"/>
        <xsl:param name="direction" tunnel="yes"/>
        <xsl:param name="endOfLineX"/>
        <xsl:param name="gatheringNumber"/>
        <!-- FolioID for JS highlighting -->
        <xsl:variable name="folioID">
            <xsl:call-template name="folioID">
                <xsl:with-param name="test" select="mode/@val"/>
                <xsl:with-param name="standard"
                    select="concat('g', q[1]/translate(@n, '.', '_'), '-', $ID-conjoined, '_leaf')"
                />
            </xsl:call-template>
        </xsl:variable>
        <!-- Calculates the absolute value of the y coordinate -->
        <xsl:variable name="absoluteY" select="$delta + ($delta * $followingComponents)"/>
        <!-- Parametric Y values for each leaf: positive or negative depending on wether the leaf
            is in the left or right half pf the quire -->
        <xsl:variable name="parametricY">
            <xsl:choose>
                <xsl:when test="xs:integer($left1_Right2) eq 1">
                    <xsl:value-of select="-$absoluteY"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$absoluteY"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- The line length varies for stubs, 
        and is legthened to gatherings with less leaves than the maximum in the textblock 
        (so that the diagrams, if aligned, are all the same width -->
        <xsl:variable name="parametricLeafLength">
            <xsl:choose>
                <xsl:when test="@stub = 'yes'">
                    <xsl:value-of select="$leafLength div 12"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="$leafLength + ((($maxRegFolIn1Gathering div 2) - $countRegularBifolia2) * $delta)"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- The following two variables allow to set a singleton with the same position of a stub -->
        <xsl:variable name="leafPosition">
            <xsl:value-of select="./q[1]/@position"/>
        </xsl:variable>
        <xsl:variable name="precPos">
            <xsl:value-of select="preceding-sibling::leaf[1]/q[1][@n = $gatheringNumber]/@position"/>
        </xsl:variable>
        <!-- The line length varies to accommodate the stub for a singleton with the same position of a stub -->
        <xsl:variable name="lineLength">
            <xsl:choose>
                <xsl:when test="$precPos eq $leafPosition">
                    <xsl:value-of select="$parametricLeafLength - (($leafLength div 12) + $delta)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$parametricLeafLength"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Variable to define the visualization of the mode of the folio.
                        Regularly, these are coded in the XML model, however, for parchment leaves,
                        the visualization requires to indicate flesh and hair sides, 
                        modes (missing, replaced, added) cannot also be visualized.
                        This variable is called only for path1-->
        <xsl:variable name="folioMode">
            <xsl:choose>
                <xsl:when test="$doublePaths = 0">
                    <xsl:value-of select="mode/@val"/>
                </xsl:when>
                <xsl:when test="$doublePaths = 1">
                    <!-- Variable to decide if the path1 is drawn for the left or right side -->
                    <xsl:variable name="leftRightSide">
                        <xsl:choose>
                            <xsl:when test="$left1_Right2 = 1">
                                <xsl:value-of select="'left'"/>
                            </xsl:when>
                            <xsl:when test="$left1_Right2 = 2">
                                <xsl:value-of select="'right'"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-fs']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:value-of select="'fleshside'"/>
                        </xsl:when>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-hs']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:value-of select="'hairside'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="folioMode2">
            <!-- Variable to decide if the path1 is drawn for the left or right side -->
            <xsl:variable name="leftRightSide">
                <xsl:choose>
                    <xsl:when test="$left1_Right2 = 1">
                        <xsl:value-of select="'right'"/>
                    </xsl:when>
                    <xsl:when test="$left1_Right2 = 2">
                        <xsl:value-of select="'left'"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-fs']/tp:target/@IDvalue = concat('#', @xml:id)">
                    <xsl:value-of select="'fleshside'"/>
                </xsl:when>
                <xsl:when
                    test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-hs']/tp:target/@IDvalue = concat('#', @xml:id)">
                    <xsl:value-of select="'hairside'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- Variable to insert the right displacement for double paths -->
        <xsl:variable name="leftOrRight">
            <xsl:choose>
                <xsl:when test="$left1_Right2 = 1">
                    <xsl:value-of select="$doublePathDisplacementValue"/>
                </xsl:when>
                <xsl:when test="$left1_Right2 = 2">
                    <xsl:value-of select="-$doublePathDisplacementValue"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- Gathering number (if first folio) -->
        <xsl:call-template name="gatheringNumber">
            <xsl:with-param name="first" select="$first"/>
            <xsl:with-param name="Cx" select="$Cx"/>
            <xsl:with-param name="Cy" select="$Cy + $parametricY"/>
            <xsl:with-param name="direction" select="$direction"/>
            <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
            <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
            <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
            <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
            <xsl:with-param name="positions_SQ" select="0"/>
        </xsl:call-template>
        <g xmlns="http://www.w3.org/2000/svg">
            <!-- Arc group -->
            <g>
                <xsl:choose>
                    <!-- The arc is drawn only for complete bifolia or for subquires-->
                    <xsl:when
                        test="(q[1]/single/@certainty != 1) or not((q[1]/single/@val = 'yes') or contains(q[1]/@n, '.'))">
                        <!-- Uncertainty levels -->
                        <xsl:choose>
                            <xsl:when
                                test="(q[1]/single/@certainty = 2) or (q[1]/single/@certainty = 3)">
                                <xsl:call-template name="certainty">
                                    <xsl:with-param name="certainty" select="q[1]/single/@certainty"
                                    />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="q[1]/conjoin/@certainty != 1">
                                <xsl:call-template name="certainty">
                                    <xsl:with-param name="certainty"
                                        select="q[1]/conjoin/@certainty"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                        <!-- Description -->
                        <desc>
                            <xsl:text>Folio #</xsl:text>
                            <xsl:value-of select="q[1]/@position"/>
                            <xsl:text>: arc</xsl:text>
                        </desc>
                        <!-- Arc path: bezier curve with controls set at a 90° angle  -->
                        <!-- When double paths are needed to encode visualizations for leaf sides, this corresponds to
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="arcPath">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of select="$Cx + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY"/>
                                    <xsl:text>&#32;Q</xsl:text>
                                    <xsl:value-of
                                        select="$Cx + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents * $delta))"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY"/>
                                    <xsl:text>&#32;</xsl:text>
                                    <xsl:value-of
                                        select="$Cx + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents * $delta))"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- When double paths are needed to encode visualizations for leaf sides, this path is drawn and it corresponds to
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="arcPath2">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of select="$Cx + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY + $leftOrRight"/>
                                    <xsl:text>&#32;Q</xsl:text>
                                    <xsl:value-of
                                        select="$Cx + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents * $delta)) + $doublePathDisplacementValue"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY + $leftOrRight"/>
                                    <xsl:text>&#32;</xsl:text>
                                    <xsl:value-of
                                        select="$Cx + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents * $delta)) + $doublePathDisplacementValue"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- This draws the folio. When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:call-template name="arcPaths">
                            <xsl:with-param name="folioID" select="$folioID"/>
                            <xsl:with-param name="arcPath" select="$arcPath"/>
                            <xsl:with-param name="folioMode" select="$folioMode"/>
                            <xsl:with-param name="Q1_SQ2" select="1"/>
                        </xsl:call-template>
                        <!-- When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:choose>
                            <xsl:when test="$doublePaths = 1">
                                <xsl:call-template name="arcPaths">
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="arcPath" select="$arcPath2"/>
                                    <xsl:with-param name="folioMode" select="$folioMode2"/>
                                    <xsl:with-param name="Q1_SQ2" select="1"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </g>
            <!-- Leaf line group -->
            <!-- Variable to store the end of line x value -->
            <xsl:variable name="Mx">
                <xsl:value-of select="($Cx + ($delta * $countRegularBifolia - 2)) + $lineLength"/>
            </xsl:variable>
            <g>
                <!-- To accommodate a singleton with the same position of a stub -->
                <xsl:choose>
                    <xsl:when test="$precPos eq $leafPosition">
                        <xsl:attribute name="transform">
                            <xsl:value-of
                                select="concat('translate(', (($leafLength div 12) + $delta), ',', '0)')"
                            />
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <!-- The line (and the attachment method) is drawn only for complete bifolia or for singletons but not for subquires-->
                <xsl:choose>
                    <xsl:when test="not(contains(q[1]/@n, '.'))">
                        <!-- line description -->
                        <desc>
                            <xsl:text>Folio #</xsl:text>
                            <xsl:value-of select="q[1]/@position"/>
                            <xsl:text>: line</xsl:text>
                        </desc>
                        <!-- Line path -->
                        <!-- When double paths are needed to encode visualizations for leaf sides, this corresponds to
                            tthe left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="linePath">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of select="$Mx"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY"/>
                                    <xsl:text>&#32;L</xsl:text>
                                    <xsl:value-of select="$Cx + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- Line path -->
                        <!-- When double paths are needed to encode visualizations for leaf sides, this path is drawn and it corresponds to
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="linePath2">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of select="$Mx"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY + $leftOrRight"/>
                                    <xsl:text>&#32;L</xsl:text>
                                    <xsl:value-of select="$Cx + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy + $parametricY + $leftOrRight"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- This draws the folio. When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:call-template name="linepaths">
                            <xsl:with-param name="folioID" select="$folioID"/>
                            <xsl:with-param name="linePath" select="$linePath"/>
                            <xsl:with-param name="folioMode" select="$folioMode"/>
                            <xsl:with-param name="Q1_SQ2" select="1"/>
                        </xsl:call-template>
                        <!-- When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:choose>
                            <xsl:when test="$doublePaths = 1">
                                <xsl:call-template name="linepaths">
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="linePath" select="$linePath2"/>
                                    <xsl:with-param name="folioMode" select="$folioMode2"/>
                                    <xsl:with-param name="Q1_SQ2" select="1"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                        <!-- Call attachment method template -->
                        <xsl:choose>
                            <xsl:when test="vc:attachment-method">
                                <xsl:for-each select="vc:attachment-method">
                                    <!-- Attachment target identification: the target can refer other quires
                                        within the same textblock -->
                                    <xsl:choose>
                                        <xsl:when test="@target">
                                            <xsl:variable name="ownPosition">
                                                <xsl:value-of select="parent::leaf/q[1]/@position"/>
                                            </xsl:variable>
                                            <!-- Quire number (avoiding subquire dot-numbers) -->
                                            <xsl:variable name="ownQuireN">
                                                <xsl:value-of select="
                                                        if (contains(parent::leaf/q[1]/@n, '.')) then
                                                            substring-before(parent::leaf/q[1]/@n, '.')
                                                        else
                                                            parent::leaf/q[1]/@n"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="attachmentTargetID">
                                                <xsl:value-of select="substring-after(@target, '#')"
                                                />
                                            </xsl:variable>
                                            <!-- Position of the leaf to which the leaf is attached -->
                                            <xsl:variable name="attachmentTargetPosition">
                                                <xsl:value-of
                                                  select="$textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@position"
                                                />
                                            </xsl:variable>
                                            <!-- Checks the number of the quire to which the target leaf belongs: it avoids subquire dot-numbers -->
                                            <xsl:variable name="attachmentTargetQuire">
                                                <xsl:value-of select="
                                                        if (contains($textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@n, '.')) then
                                                            substring-before($textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@n, '.')
                                                        else
                                                            $textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@n"
                                                />
                                            </xsl:variable>
                                            <!-- Checks the deviation between the leaf and its attachment target: 
                                                usually this would be the leaf before or after -->
                                            <xsl:variable name="attachmentDeviation">
                                                <xsl:variable name="attachmentDeviationValue">
                                                  <xsl:value-of
                                                  select="$ownPosition - $attachmentTargetPosition"
                                                  />
                                                </xsl:variable>
                                                <!-- When the target is in another quire the deviation has to be valuated separately -->
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="$ownQuireN = $attachmentTargetQuire">
                                                  <xsl:value-of select="$attachmentDeviationValue"/>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$ownQuireN != $attachmentTargetQuire">
                                                  <xsl:value-of
                                                  select="-($attachmentDeviationValue)"/>
                                                  </xsl:when>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <!-- Call template to draw the attachment method -->
                                            <xsl:call-template name="attachment-method">
                                                <xsl:with-param name="Cx_A" select="$Cx"/>
                                                <xsl:with-param name="Cy_A" select="
                                                        $Cy + $parametricY - (if (xs:integer($attachmentDeviation) gt 0) then
                                                            $delta
                                                        else
                                                            0)"/>
                                                <xsl:with-param name="countRegularBifolia"
                                                  select="$countRegularBifolia"/>
                                                <xsl:with-param name="countRegularBifolia2"
                                                  select="$countRegularBifolia2"/>
                                                <xsl:with-param name="lineLength"
                                                  select="$lineLength"/>
                                                <xsl:with-param name="parametricY"
                                                  select="$parametricY"/>
                                                <xsl:with-param name="attachmentDeviation"
                                                  select="$attachmentDeviation"/>
                                                <xsl:with-param name="certainty" select="@certainty"
                                                />
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- For patterns without the attachment target -->
                                            <xsl:call-template name="attachment-method">
                                                <xsl:with-param name="Cx_A" select="$Cx"/>
                                                <xsl:with-param name="Cy_A">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="xs:integer($leafPosition) eq $centralLeftLeafPos or xs:integer($leafPosition) eq ($centralLeftLeafPos + 1)">
                                                  <xsl:value-of select="
                                                                    $Cy + $parametricY + ((if (xs:integer($left1_Right2) eq 1) then
                                                                        1
                                                                    else
                                                                        -1) * ($delta)) + ($delta * $followingComponents)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="xs:integer($leafPosition) lt $centralLeftLeafPos">
                                                  <xsl:variable name="ownPosition">
                                                  <xsl:value-of select="parent::leaf/q[1]/@position"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:variable name="currentQuire">
                                                  <xsl:value-of select="parent::leaf/q[1]/@n"/>
                                                  </xsl:variable>
                                                  <xsl:variable name="posNextRegularLeaf">
                                                  <xsl:value-of
                                                  select="parent::leaf/following-sibling::leaf[q[1]/@n = $currentQuire][1]/q[1]/@position"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:variable name="difference" as="xs:integer">
                                                  <xsl:value-of
                                                  select="$posNextRegularLeaf - $ownPosition"/>
                                                  </xsl:variable>
                                                  <xsl:value-of select="
                                                                    $Cy + $parametricY + ($delta div 2) + $delta * (if (xs:integer($difference) eq 1) then
                                                                        0
                                                                    else
                                                                        xs:integer($difference)-1)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="xs:integer($leafPosition) gt ($centralLeftLeafPos + 1)">
                                                  <xsl:variable name="ownPosition">
                                                  <xsl:value-of select="parent::leaf/q[1]/@position"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:variable name="currentQuire">
                                                  <xsl:value-of select="parent::leaf/q[1]/@n"/>
                                                  </xsl:variable>
                                                  <xsl:variable name="posPreviousRegularLeaf">
                                                  <xsl:value-of
                                                  select="parent::leaf/preceding-sibling::leaf[q[1]/@n = $currentQuire][1]/q[1]/@position"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:variable name="difference" as="xs:integer">
                                                  <xsl:value-of
                                                  select="$ownPosition - $posPreviousRegularLeaf"/>
                                                  </xsl:variable>
                                                  <xsl:value-of select="
                                                                    $Cy + $parametricY - ($delta div 2) + $delta * (if (xs:integer($difference) eq 1) then
                                                                        0
                                                                    else
                                                                        xs:integer($difference)-1)"
                                                  />
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:with-param>
                                                <xsl:with-param name="countRegularBifolia"
                                                  select="$countRegularBifolia"/>
                                                <xsl:with-param name="countRegularBifolia2"
                                                  select="$countRegularBifolia2"/>
                                                <xsl:with-param name="lineLength"
                                                  select="$lineLength"/>
                                                <xsl:with-param name="parametricY"
                                                  select="$parametricY"/>
                                                <xsl:with-param name="certainty" select="@certainty"
                                                />
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </g>
        </g>
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
        <!-- Add folio numbers to first and last -->
        <xsl:call-template name="firstLastFolioNumbers">
            <xsl:with-param name="first" select="$first"/>
            <xsl:with-param name="Cy" select="$Cy"/>
            <xsl:with-param name="parametricY" select="$parametricY"/>
            <xsl:with-param name="Cx" select="$Cx"/>
            <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
            <xsl:with-param name="lineLength" select="$parametricLeafLength"/>
            <xsl:with-param name="last" select="$last"/>
            <xsl:with-param name="folioNumber" select="$folioNumberVar"/>
            <xsl:with-param name="direction" select="$direction" tunnel="yes"/>
            <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to write the gathering number in Roman numerals in the SVG.</xd:p>
        </xd:desc>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
        <xd:param name="gatheringNumber">
            <xd:p>The gathering number.</xd:p>
        </xd:param>
        <xd:param name="positions_SQ">
            <xd:p>Parameter to count the number of leaves in the current subquire.</xd:p>
        </xd:param>
        <xd:param name="Cx">
            <xd:p>The value of Cx</xd:p>
        </xd:param>
        <xd:param name="Cy">
            <xd:p>The value of Cy</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="gatheringNumber">
        <xsl:param name="first"/>
        <xsl:param name="Cx"/>
        <xsl:param name="Cy"/>
        <xsl:param name="direction"/>
        <xsl:param name="countRegularBifolia"/>
        <xsl:param name="countRegularBifolia2"/>
        <xsl:param name="endOfLineX"/>
        <xsl:param name="gatheringNumber"/>
        <xsl:param name="positions_SQ"/>
        <xsl:variable name="dx">
            <xsl:choose>
                <xsl:when test="$direction = 'l-r'">
                    <!-- Same value as the end of the sewing through the fold line + $delta -->
                    <xsl:value-of
                        select="($Cx + ($delta * $countRegularBifolia - 2) - ($delta * ($countRegularBifolia2 + 2)) - (($delta div 2) * $positions_SQ)) + ($delta)"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <!-- Same value as the end of the sewing through the fold line + $delta -->
                    <xsl:value-of
                        select="($Cx - ($delta * $countRegularBifolia - 2) + ($delta * ($countRegularBifolia2 + 2)) + (($delta div 2) * $positions_SQ)) - (2 * $delta)"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@xml:id eq $first">
                <!-- Gathering number -->
                <!-- Old code: dx="{$Ox + $delta + (if ($direction = 'l-r') then (2*$delta) else 0)}" -->
                <xsl:choose>
                    <xsl:when test="$gatheringNumbers = 1">
                        <g xmlns="http://www.w3.org/2000/svg">
                            <text xmlns="http://www.w3.org/2000/svg" dy="{$Cy}" dx="{$dx}"
                                class="{concat('gatheringNumber', (if ($direction = 'l-r') then ' gatheringNumber_L-R' else ''))}">
                                <xsl:call-template name="writingDirRotation">
                                    <xsl:with-param name="direction" select="$direction"/>
                                    <xsl:with-param name="text" select="2"/>
                                    <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                                </xsl:call-template>
                                <!-- Print the gathering number -->
                                <xsl:value-of select="format-integer($gatheringNumber, 'I')"/>
                            </text>
                        </g>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template draws the folio. When double paths are needed to encode
                visualizations for leaf sides, this draws the left side or right side depending on
                the position of the leaf (left or right of the centre).</xd:p>
        </xd:desc>
        <xd:param name="folioID">
            <xd:p>FolioID for JS highlighting</xd:p>
        </xd:param>
        <xd:param name="linePath">
            <xd:p>Line path. When double paths are needed to encode visualizations for leaf sides, a
                second path is drawn and it corresponds to the left side or right side depending on
                the position of the leaf (left or right of the centre)</xd:p>
        </xd:param>
        <xd:param name="folioMode">
            <xd:p>Parameter to define the visualization of the mode of the folio. Regularly, these
                are coded in the XML model, however, for parchment leaves, the visualization
                requires to indicate flesh and hair sides, modes (missing, replaced, added) cannot
                also be visualized.</xd:p>
        </xd:param>
        <xd:param name="Q1_SQ2">
            <xd:p>Whether the current leaf is in the main gathering or in a subquire.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="linepaths" xmlns="http://www.w3.org/2000/svg">
        <xsl:param name="folioID"/>
        <xsl:param name="linePath"/>
        <xsl:param name="folioMode"/>
        <xsl:param name="Q1_SQ2"/>
        <g>
            <!-- Line uncertainty -->
            <xsl:choose>
                <xsl:when test="$Q1_SQ2 = 1">
                    <xsl:call-template name="pathUncertainty"/>
                </xsl:when>
                <xsl:when test="$Q1_SQ2 = 2">
                    <xsl:call-template name="pathUncertainty_SQ"/>
                </xsl:when>
            </xsl:choose>
            <!-- Line style -->
            <xsl:call-template name="CSSclass">
                <xsl:with-param name="folioMode" select="$folioMode"/>
                <xsl:with-param name="folioID" select="$folioID"/>
            </xsl:call-template>
            <xsl:copy-of select="$linePath"/>
        </g>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to determine and visualize the uncertainty of the path.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="pathUncertainty" xmlns="http://www.w3.org/2000/svg">
        <xsl:choose>
            <xsl:when test="q[1]/@certainty != 1 or q[2]">
                <xsl:call-template name="certainty">
                    <xsl:with-param name="certainty" select="q[1]/@certainty"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="q[2]">
                <xsl:call-template name="certainty">
                    <xsl:with-param name="certainty" select="
                            if (q[2]/@certainty) then
                                q[2]/@certainty
                            else
                                3"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to determine and visualize the uncertainty of the path within
                subquires.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="pathUncertainty_SQ" xmlns="http://www.w3.org/2000/svg">
        <xsl:choose>
            <xsl:when test="vc:q[1]/@certainty != 1 or vc:q[2]">
                <xsl:call-template name="certainty">
                    <xsl:with-param name="certainty" select="vc:q[1]/@certainty"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="vc:q[2]">
                <xsl:call-template name="certainty">
                    <xsl:with-param name="certainty" select="
                            if (vc:q[2]/@certainty) then
                                vc:q[2]/@certainty
                            else
                                3"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template draws the folio. When double paths are needed to encode
                visualizations for leaf sides, this draws the left side or right side depending on
                the position of the leaf (left or right of the centre)</xd:p>
        </xd:desc>
        <xd:param name="folioID">
            <xd:p>FolioID for JS highlighting</xd:p>
        </xd:param>
        <xd:param name="arcPath">
            <xd:p>Arc path. When double paths are needed to encode visualizations for leaf sides, a
                second path is drawn and it corresponds to the left side or right side depending on
                the position of the leaf (left or right of the centre)</xd:p>
        </xd:param>
        <xd:param name="folioMode">
            <xd:p>Parameter to define the visualization of the mode of the folio. Regularly, these
                are coded in the XML model, however, for parchment leaves, the visualization
                requires to indicate flesh and hair sides, modes (missing, replaced, added) cannot
                also be visualized.</xd:p>
        </xd:param>
        <xd:param name="Q1_SQ2">
            <xd:p>Whether the current leaf is in the main gathering or in a subquire.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="arcPaths" xmlns="http://www.w3.org/2000/svg">
        <xsl:param name="folioID"/>
        <xsl:param name="arcPath"/>
        <xsl:param name="folioMode"/>
        <xsl:param name="Q1_SQ2"/>
        <g>
            <!-- Arc uncertainty -->
            <xsl:choose>
                <xsl:when test="$Q1_SQ2 = 1">
                    <xsl:call-template name="pathUncertainty"/>
                </xsl:when>
                <xsl:when test="$Q1_SQ2 = 2">
                    <xsl:call-template name="pathUncertainty_SQ"/>
                </xsl:when>
            </xsl:choose>
            <!-- Line style -->
            <xsl:call-template name="CSSclass">
                <xsl:with-param name="folioMode" select="$folioMode"/>
                <xsl:with-param name="folioID" select="$folioID"/>
            </xsl:call-template>
            <xsl:copy-of select="$arcPath"/>
        </g>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template prepares the data for the drawing of the irregular bifolia. The
                parameters necessary to draw the gatherings are passed from the previous
                template.</xd:p>
        </xd:desc>
        <xd:param name="subquires">
            <xd:p>Parameter to manage subquires.</xd:p>
        </xd:param>
        <xd:param name="textblock">
            <xd:p>A copy of the whole textblock to manage inter-quire references.</xd:p>
        </xd:param>
        <xd:param name="counter">
            <xd:p>Counter for recursive template</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="countSubquireLeaves">
            <xd:p>Parameter to count the number of leaves in subquires.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
        <xd:param name="NSubquires">
            <xd:p>Number of subquires, i.e. the number of iterations</xd:p>
        </xd:param>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="last">
            <xd:p>Last leaf in the gathering (that is not 'missing' or is not a stub).</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
        <xd:param name="gatheringNumber">
            <xd:p>The gathering number.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="bifoliaDiagram_SQ">
        <xsl:param name="first"/>
        <xsl:param name="last"/>
        <xsl:param name="subquires"/>
        <xsl:param name="textblock"/>
        <xsl:param name="counter" select="1"/>
        <xsl:param name="countRegularBifolia" as="xs:integer" select="1"/>
        <xsl:param name="countRegularBifolia2" select="1"/>
        <xsl:param name="countSubquireLeaves"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:param name="NSubquires" as="xs:integer" select="1"/>
        <xsl:param name="endOfLineX"/>
        <xsl:param name="gatheringNumber"/>
        <!-- Variable to count the number of leaves in the current subquire -->
        <xsl:variable name="positions_SQ" select="$subquires/tp:subquire[$counter]/@positions_SQ"/>
        <!-- Subquire levels -->
        <xsl:variable name="subquireLevel" select="$subquires/tp:subquire[$counter]/@subquireLevel"/>
        <!-- Checks how many leaves before -->
        <xsl:variable name="previousPositions_SQ" select="
                if ($subquires/tp:subquire[@subquireLevel = ($subquireLevel - 1)][$counter - 1]) then
                    xs:integer($subquires/tp:subquire[@subquireLevel = ($subquireLevel - 1)][1]/@positions_SQ)
                else
                    0"/>
        <!-- Variable to assess the number of leaves in the subquire section -->
        <xsl:variable name="odd1_Even2_SQ" select="
                if ($subquires/tp:subquire[$counter]/@positions_SQ mod 2 = 0) then
                    2
                else
                    1" as="xs:integer"/>
        <!-- Variable to count the number of singletons in the subquire -->
        <xsl:variable name="countSingletons_SQ">
            <xsl:value-of
                select="count($subquires/tp:subquire[$counter]/vc:leaf[vc:q[1]/vc:single/@val = 'yes'])"
            />
        </xsl:variable>
        <!-- Variable to find the left regular inner leaf position:
        it avoids singletons and leaves belonging to other subquires-->
        <xsl:variable name="centralLeftLeafPos_SQ">
            <xsl:call-template name="centralLeftLeafPos_SQ">
                <xsl:with-param name="subquires" select="$subquires"/>
                <xsl:with-param name="counter" select="$counter"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="$subquires/tp:subquire[$counter]/vc:leaf">
            <xsl:variable name="currentPosition_SQ">
                <xsl:value-of select="xs:integer(vc:q[1]/@position)"/>
            </xsl:variable>
            <!-- Variable to determine if the current folio is in the left or the right half in the principal quire -->
            <xsl:variable name="left1_Right2">
                <xsl:call-template name="left1_Right2">
                    <xsl:with-param name="test" select="vc:q[1]/vc:single/@val"/>
                    <xsl:with-param name="test2" select="contains(q[1]/@n, '.')"/>
                    <xsl:with-param name="test3"
                        select="(xs:integer(parent::tp:subquire/vc:leaf[1]/vc:q[1]/@position) - xs:integer($centralLeftLeafPos)) le 1"/>
                    <xsl:with-param name="currentPosition" select="$currentPosition_SQ"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="attachmentMethod" select="attachment-method/@target"/>
                    <xsl:with-param name="precedingLeafID"
                        select="preceding-sibling::leaf[1]/@xml:id"/>
                    <xsl:with-param name="sq" select="1"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Number of the subquire -->
            <xsl:variable name="subquireN" select="vc:q[1]/@n"/>
            <!-- Variable to determine if the current folio is in the left or the right half of the subquire -->
            <xsl:variable name="left1_Right2_SQ">
                <xsl:call-template name="left1_Right2_SQ">
                    <xsl:with-param name="currentPosition_SQ" select="$currentPosition_SQ"/>
                    <xsl:with-param name="centralLeftLeafPos_SQ" select="$centralLeftLeafPos_SQ"/>
                    <xsl:with-param name="counter" select="$counter"/>
                    <xsl:with-param name="subquireN" select="$subquireN"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Check if there are subquires with position greater than the central left leaf but still in the left half-->
            <xsl:variable name="extraCentralSubquireLeft">
                <xsl:call-template name="extraCentralSubquireLeft">
                    <xsl:with-param name="subquires" select="$subquires"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to count how many folios follow the current one -->
            <xsl:variable name="followingComponents">
                <xsl:call-template name="followingComponents">
                    <xsl:with-param name="sq" select="0"/>
                    <xsl:with-param name="currentPosition" select="$currentPosition_SQ"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="extraCentralSubquireLeft"
                        select="$extraCentralSubquireLeft"/>
                    <xsl:with-param name="left1_Right2" select="$left1_Right2"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to count how many folios follow the current one in the subquire -->
            <xsl:variable name="followingComponents_SQ">
                <xsl:call-template name="followingComponents">
                    <xsl:with-param name="sq" select="1"/>
                    <xsl:with-param name="left1_Right2_SQ" select="$left1_Right2_SQ"/>
                    <xsl:with-param name="centralLeftLeafPos_SQ" select="$centralLeftLeafPos_SQ"/>
                    <xsl:with-param name="currentPosition_SQ" select="$currentPosition_SQ"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to count how many regular bifolia the current folio is wrapped around -->
            <xsl:variable name="followingRegularComponents_SQ">
                <xsl:call-template name="followingRegularComponents">
                    <xsl:with-param name="left1_Right2" select="$left1_Right2_SQ"/>
                    <xsl:with-param name="countRegularComponentsLeft"
                        select="count(following-sibling::vc:leaf[not(vc:q[1]/vc:single/@val = 'yes') and ./vc:q[1]/xs:integer(@position) le xs:integer($centralLeftLeafPos_SQ)])"/>
                    <xsl:with-param name="countRegularComponentsRight"
                        select="count(preceding-sibling::vc:leaf[not(vc:q[1]/vc:single/@val = 'yes') and ./vc:q[1]/xs:integer(@position) gt xs:integer($centralLeftLeafPos_SQ)])"
                    />
                </xsl:call-template>
            </xsl:variable>
            <!-- Centre coordinates -->
            <xsl:variable name="Cx">
                <xsl:call-template name="Cx"/>
            </xsl:variable>
            <xsl:variable name="Cy">
                <xsl:call-template name="Cy">
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="conjoinID">
                <!-- finds the ID of the conjoned leaf, removing the # symbol -->
                <xsl:value-of select="vc:q[1]/vc:conjoin/replace(@target, '#', '')"/>
            </xsl:variable>
            <!-- Finds the position of the conjoined leaf -->
            <xsl:variable name="conjoinPosition">
                <xsl:call-template name="conjoinPosition">
                    <xsl:with-param name="test" select="vc:q[1]/vc:conjoin"/>
                    <xsl:with-param name="conjoinPos"
                        select="parent::node()/vc:leaf[@xml:id = $conjoinID]/vc:q[1]/@position"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Variable to generate a unique ID that puts together conjoined leaf positions in the correct order -->
            <xsl:variable name="ID-conjoined">
                <xsl:call-template name="ID-conjoined">
                    <xsl:with-param name="currentPosition" select="$currentPosition_SQ"/>
                    <xsl:with-param name="conjoinPosition" select="
                            if ($conjoinPosition = '') then
                                xs:integer(0)
                            else
                                $conjoinPosition" as="xs:integer"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Set group and drawing direction -->
            <g xmlns="http://www.w3.org/2000/svg">
                <!-- Add the xml:id of the folio -->
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <!-- Folio description -->
                <desc xmlns="http://www.w3.org/2000/svg">
                    <xsl:text>Folio #</xsl:text>
                    <xsl:value-of select="vc:q[1]/@position"/>
                </desc>
                <!-- Draw folio -->
                <xsl:call-template name="leafPath_SQ">
                    <xsl:with-param name="first" select="$first"/>
                    <xsl:with-param name="last" select="$last"/>
                    <xsl:with-param name="textblock" select="$textblock"/>
                    <xsl:with-param name="subquireN" select="$subquireN"/>
                    <xsl:with-param name="Cx_SQ" select="$Cx"/>
                    <xsl:with-param name="Cy_SQ" select="$Cy"/>
                    <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"
                        as="xs:integer"/>
                    <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
                    <xsl:with-param name="countSubquireLeaves" select="$countSubquireLeaves"/>
                    <xsl:with-param name="followingComponents" select="$followingComponents"/>
                    <xsl:with-param name="followingComponents_SQ" select="$followingComponents_SQ"/>
                    <xsl:with-param name="followingRegularComponents_SQ"
                        select="$followingRegularComponents_SQ" as="xs:integer"/>
                    <xsl:with-param name="left1_Right2_SQ" select="$left1_Right2_SQ"/>
                    <xsl:with-param name="left1_Right2" select="$left1_Right2"/>
                    <xsl:with-param name="positions_SQ" select="$positions_SQ"/>
                    <xsl:with-param name="previousPositions_SQ" select="$previousPositions_SQ"/>
                    <xsl:with-param name="centralLeftLeafPos_SQ" select="$centralLeftLeafPos_SQ"/>
                    <xsl:with-param name="conjoinPosition" select="$conjoinPosition"/>
                    <xsl:with-param name="ID-conjoined" select="$ID-conjoined"/>
                    <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                    <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
                    <xsl:with-param name="countSingletons_SQ" select="$countSingletons_SQ"/>
                </xsl:call-template>
            </g>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="$counter le $NSubquires">
                <!--
                test="(string-length($subquires/tp:subquire[$counter]/vc:leaf[$counter]/vc:q[1]/@n) - string-length(translate($subquires/tp:subquire[$counter]/vc:leaf[$counter]/vc:q[1]/@n, '.', ''))) ge $counter">-->
                <xsl:call-template name="bifoliaDiagram_SQ">
                    <xsl:with-param name="counter" select="$counter + 1"/>
                    <xsl:with-param name="first" select="$first"/>
                    <xsl:with-param name="last" select="$last"/>
                    <xsl:with-param name="subquires" select="$subquires"/>
                    <xsl:with-param name="textblock" select="$textblock"/>
                    <xsl:with-param name="centralLeftLeafPos" select="$centralLeftLeafPos"/>
                    <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
                    <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
                    <xsl:with-param name="countSubquireLeaves" select="$countSubquireLeaves"/>
                    <xsl:with-param name="NSubquires" select="$NSubquires" as="xs:integer"/>
                    <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template checks if there are subquires with position greater than the central
                left leaf but still in the left half.</xd:p>
        </xd:desc>
        <xd:param name="subquires">
            <xd:p>Parameter to manage subquires.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="extraCentralSubquireLeft">
        <xsl:param name="subquires"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:choose>
            <xsl:when
                test="$subquires/tp:subquire[vc:leaf[1]/vc:q[1]/@position - xs:integer($centralLeftLeafPos) eq 1]">
                <xsl:variable name="extraCentralSubquireLeftN">
                    <xsl:value-of
                        select="$subquires/tp:subquire[vc:leaf[1]/vc:q[1]/@position - xs:integer($centralLeftLeafPos) eq 1]/vc:leaf[1]/vc:q[1]/@n"
                    />
                </xsl:variable>
                <xsl:value-of
                    select="count($subquires/tp:subquire/vc:leaf[vc:q[1]/@n eq $extraCentralSubquireLeftN])"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to determine if the current folio is in the left or the right half of the
                subquire.</xd:p>
        </xd:desc>
        <xd:param name="currentPosition_SQ">
            <xd:p>The position of the current leaf within the subquire.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos_SQ">
            <xd:p>Parameter to find the left regular inner leaf position within subquires.</xd:p>
        </xd:param>
        <xd:param name="counter">
            <xd:p>Counter for recursive template.</xd:p>
        </xd:param>
        <xd:param name="subquireN">
            <xd:p>The number of the subquire.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos">
            <xd:p>Parameter to find the left regular inner leaf position: it avoids singletons
                (inside complex gatherings) and leaves belonging to subquires.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="left1_Right2_SQ">
        <xsl:param name="currentPosition_SQ"/>
        <xsl:param name="centralLeftLeafPos_SQ"/>
        <xsl:param name="counter"/>
        <xsl:param name="subquireN"/>
        <xsl:param name="centralLeftLeafPos"/>
        <xsl:choose>
            <!-- Considers irregular folios: singletons -->
            <xsl:when test="vc:q[1]/vc:single/@val = 'yes'">
                <xsl:choose>
                    <!-- if its position is less than the middle bifolio it is in the left half -->
                    <xsl:when
                        test="xs:integer($currentPosition_SQ) le xs:integer($centralLeftLeafPos_SQ)">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <!-- if its position is greater than the central uppler leaf and is is attached to it
                            it is still in the left half-->
                    <xsl:when
                        test="(xs:integer($currentPosition_SQ) - xs:integer($centralLeftLeafPos_SQ) eq 1) and (vc:attachment-method/@target eq concat('#', preceding-sibling::vc:leaf[1]/@xml:id))">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Considers the position of further subquires -->
            <!-- Checks the number of dots in the quire number and compares it to the current counter -->
            <xsl:when
                test="(string-length(vc:q[1]/@n) - string-length(translate(vc:q[1]/@n, '.', ''))) gt $counter">
                <xsl:choose>
                    <!-- if the position is less than the middle bifolio it is in the left half -->
                    <xsl:when
                        test="xs:integer($currentPosition_SQ) le xs:integer($centralLeftLeafPos_SQ)">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <!-- if its position is greater than the central uppler leaf but is still in the left half-->
                    <xsl:when
                        test="(xs:integer(parent::tp:subquire/vc:leaf[vc:q[1]/@n = $subquireN][1]/vc:q[1]/@position) - xs:integer($centralLeftLeafPos)) le 1">
                        <!-- (xs:integer($currentPosition) gt xs:integer($centralLeftLeafPos)) and  -->
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Regular bifolia -->
            <xsl:otherwise>
                <xsl:value-of select="
                        if (xs:integer($currentPosition_SQ) le xs:integer($centralLeftLeafPos_SQ)) then
                            1
                        else
                            2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to find the left regular inner leaf position: it avoids singletons and
                leaves belonging to other subquires</xd:p>
        </xd:desc>
        <xd:param name="subquires">
            <xd:p>Parameter to manage subquires.</xd:p>
        </xd:param>
        <xd:param name="counter">
            <xd:p>Counter for recursive template.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="centralLeftLeafPos_SQ">
        <xsl:param name="subquires"/>
        <xsl:param name="counter"/>
        <xsl:choose>
            <!-- If a subquire is composed by all singletons, then there cannot be a middle leaf
                and there are no conjoines, so the variable simply returns the number of singletons in that quire -->
            <xsl:when test="
                    every $vc:leaf in $subquires/tp:subquire[$counter]/vc:leaf
                        satisfies $vc:leaf/q[1]/single[@val = 'yes']">
                <xsl:value-of select="count($subquires/tp:subquire[$counter]/vc:leaf)"/>
            </xsl:when>
            <!-- For normal and complex subquires, the variable returns the position of the last leaf 
                to be drawn in the left (upper) part of the quire -->
            <xsl:otherwise>
                <xsl:for-each select="$subquires/tp:subquire[$counter]/vc:leaf">
                    <xsl:variable name="ownIdRef_SQ">
                        <xsl:value-of select="concat('#', @xml:id)"/>
                    </xsl:variable>
                    <xsl:variable name="subquireN" select="vc:q[1]/@n"/>
                    <!-- The pattern looks for the next regular folio -->
                    <xsl:variable name="followingConjoinID_SQ">
                        <xsl:value-of
                            select="(following-sibling::vc:leaf[not(vc:q[1]/vc:single/@val = 'yes') and vc:q[1]/@n = $subquireN])[1]/vc:q[1]/vc:conjoin/@target"
                        />
                    </xsl:variable>
                    <!--  -->
                    <xsl:choose>
                        <xsl:when test="$followingConjoinID_SQ = $ownIdRef_SQ">
                            <xsl:value-of select="xs:integer(vc:q[1]/@position)"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template draws irregular bifolia. The parameters necessary to draw the
                gatherings are passed from the previous template.</xd:p>
        </xd:desc>
        <xd:param name="textblock">
            <xd:p>A copy of the whole textblock to manage inter-quire references.</xd:p>
        </xd:param>
        <xd:param name="subquireN">
            <xd:p>The number of the subquire.</xd:p>
        </xd:param>
        <xd:param name="Cx_SQ">
            <xd:p>The value of Cx for the subquire</xd:p>
        </xd:param>
        <xd:param name="Cy_SQ">
            <xd:p>The value of Cy for the subquire</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="countSubquireLeaves">
            <xd:p>Parameter to count the number of leaves in subquires.</xd:p>
        </xd:param>
        <xd:param name="followingComponents">
            <xd:p>Parameter to count how many folios the current one is wrapped around.</xd:p>
        </xd:param>
        <xd:param name="followingComponents_SQ">
            <xd:p>Parameter to count how many folios the current one is wrapped around within the
                subquire.</xd:p>
        </xd:param>
        <xd:param name="followingRegularComponents_SQ">
            <xd:p>Parameter to count how many regular bifolia the current folio is wrapped around
                within the subquire.</xd:p>
        </xd:param>
        <xd:param name="left1_Right2_SQ">
            <xd:p>If the current folio is in the left or the right half of the subquire.</xd:p>
        </xd:param>
        <xd:param name="left1_Right2">
            <xd:p>If the current folio is in the left or the right half of the gathering.</xd:p>
        </xd:param>
        <xd:param name="positions_SQ">
            <xd:p>Parameter to count the number of leaves in the current subquire.</xd:p>
        </xd:param>
        <xd:param name="previousPositions_SQ">
            <xd:p>Checks how many leaves before within the subquire.</xd:p>
        </xd:param>
        <xd:param name="centralLeftLeafPos_SQ">
            <xd:p>Parameter to find the left regular inner leaf position within subquires.</xd:p>
        </xd:param>
        <xd:param name="conjoinPosition">
            <xd:p>The position of the conjoined leaf.</xd:p>
        </xd:param>
        <xd:param name="ID-conjoined">
            <xd:p>The ID of the conjoined leaf.</xd:p>
        </xd:param>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="last">
            <xd:p>Last leaf in the gathering (that is not 'missing' or is not a stub).</xd:p>
        </xd:param>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
        <xd:param name="gatheringNumber">
            <xd:p>The gathering number.</xd:p>
        </xd:param>
        <xd:param name="countSingletons_SQ">
            <xd:p>Parameter to count the number of singletons in the subquire.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="leafPath_SQ">
        <xsl:param name="first"/>
        <xsl:param name="last"/>
        <xsl:param name="textblock"/>
        <xsl:param name="subquireN"/>
        <xsl:param name="Cx_SQ" select="$Ox + 20"/>
        <xsl:param name="Cy_SQ" select="$Cx_SQ"/>
        <xsl:param name="countRegularBifolia" as="xs:integer"/>
        <xsl:param name="countRegularBifolia2"/>
        <xsl:param name="countSubquireLeaves"/>
        <xsl:param name="followingComponents" select="1" as="xs:float"/>
        <xsl:param name="followingComponents_SQ"/>
        <xsl:param name="followingRegularComponents_SQ" select="1" as="xs:integer"/>
        <xsl:param name="left1_Right2_SQ"/>
        <xsl:param name="left1_Right2"/>
        <xsl:param name="positions_SQ"/>
        <xsl:param name="previousPositions_SQ"/>
        <xsl:param name="centralLeftLeafPos_SQ"/>
        <xsl:param name="conjoinPosition" select="0"/>
        <xsl:param name="ID-conjoined"/>
        <xsl:param name="direction" tunnel="yes"/>
        <xsl:param name="endOfLineX"/>
        <xsl:param name="gatheringNumber"/>
        <xsl:param name="countSingletons_SQ"/>
        <!-- FolioID for JS highlighting -->
        <xsl:variable name="folioID">
            <xsl:call-template name="folioID">
                <xsl:with-param name="test" select="vc:mode/@val"/>
                <xsl:with-param name="standard"
                    select="concat('g', vc:q[1]/translate(@n, '.', '_'), '-', $ID-conjoined, '_leaf')"
                />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="absoluteY" select="$delta + ($delta * $followingComponents)"/>
        <xsl:variable name="absoluteY_SQ"
            select="($delta div 2) + ($delta * $followingComponents_SQ)"/>
        <!-- Parametric Y values for each leaf -->
        <xsl:variable name="parametricY">
            <xsl:choose>
                <xsl:when test="xs:integer($left1_Right2) eq 1">
                    <xsl:value-of select="-$absoluteY"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$absoluteY"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Parametric Y values for each leaf of the subquire -->
        <xsl:variable name="parametricY_SQ">
            <xsl:choose>
                <xsl:when test="xs:integer($left1_Right2_SQ) eq 1">
                    <xsl:value-of select="$absoluteY_SQ"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="-$absoluteY_SQ"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- The line length varies for stubs, 
        and is legthened to gatherings with less leaves than the maximum in the textblock 
        (so that the diagrams, if aligned, are all the same width -->
        <xsl:variable name="parametricLeafLength">
            <xsl:choose>
                <xsl:when test="@stub = 'yes'">
                    <xsl:value-of select="$leafLength div 12"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- If all leaves in subquires are singletons -->
                        <xsl:when test="$countSingletons_SQ = $positions_SQ">
                            <xsl:value-of
                                select="($leafLength - (($delta * ($previousPositions_SQ div 2)))) + ((($maxRegFolIn1Gathering div 2) - $countRegularBifolia2) * $delta)"
                            />
                        </xsl:when>
                        <!-- If the whole quire is composed of a series of orphan subquires:
                        same results as above condition -->
                        <xsl:when test="
                                every $leaf in current-group()
                                    satisfies $leaf/q/contains(@n, '.')">
                            <xsl:value-of
                                select="($leafLength - (($delta * ($previousPositions_SQ div 2)))) + ((($maxRegFolIn1Gathering div 2) - $countRegularBifolia2) * $delta)"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="($leafLength - ((($positions_SQ div 2) * $delta) + ($delta * ($previousPositions_SQ div 2)))) + ((($maxRegFolIn1Gathering div 2) - $countRegularBifolia2) * $delta)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- The following two variables allow to set a singleton with the same position of a stub -->
        <xsl:variable name="leafPosition">
            <xsl:value-of select="./vc:q[1]/@position"/>
        </xsl:variable>
        <xsl:variable name="precPos">
            <xsl:value-of select="preceding-sibling::vc:leaf[1]/vc:q[1]/@position"/>
        </xsl:variable>
        <xsl:variable name="lineLength">
            <xsl:choose>
                <xsl:when test="$precPos eq $leafPosition">
                    <xsl:value-of select="$parametricLeafLength - (($leafLength div 12) + $delta)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$parametricLeafLength"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="parametricTranslation">
            <xsl:choose>
                <!-- If all leaves in subquires are singletons -->
                <xsl:when test="$countSingletons_SQ = $positions_SQ">
                    <xsl:value-of select="(($delta * ($previousPositions_SQ div 2)))"/>
                </xsl:when>
                <!-- If the whole quire is composed of a series of orphan subquires:
                        same results as above condition -->
                <xsl:when test="
                        every $leaf in current-group()
                            satisfies $leaf/q/contains(@n, '.')">
                    <xsl:value-of select="(($delta * ($previousPositions_SQ div 2)))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="((($positions_SQ div 2) * $delta) + ($delta * ($previousPositions_SQ div 2)))"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Variable to define the visualization of the mode of the folio.
                        Regularly, these are coded in the XML model, however, for parchment leaves,
                        the visualization requires to indicate flesh and hair sides, 
                        modes (missing, replaced, added) cannot also be visualized.
                        This variable is called only for path1 -->
        <xsl:variable name="folioMode">
            <xsl:choose>
                <xsl:when test="$doublePaths = 0">
                    <xsl:value-of select="vc:mode/@val"/>
                </xsl:when>
                <xsl:when test="$doublePaths = 1">
                    <!-- Variable to decide if the path1 is drawn for the left or right side -->
                    <xsl:variable name="leftRightSide">
                        <xsl:choose>
                            <xsl:when test="$left1_Right2_SQ = 1">
                                <xsl:value-of select="'left'"/>
                            </xsl:when>
                            <xsl:when test="$left1_Right2_SQ = 2">
                                <xsl:value-of select="'right'"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-fs']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:value-of select="'fleshside'"/>
                        </xsl:when>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-hs']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:value-of select="'hairside'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="folioMode2">
            <!-- Variable to decide if the path1 is drawn for the left or right side -->
            <xsl:variable name="leftRightSide">
                <xsl:choose>
                    <xsl:when test="$left1_Right2_SQ = 1">
                        <xsl:value-of select="'right'"/>
                    </xsl:when>
                    <xsl:when test="$left1_Right2_SQ = 2">
                        <xsl:value-of select="'left'"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-fs']/tp:target/@IDvalue = concat('#', @xml:id)">
                    <xsl:value-of select="'fleshside'"/>
                </xsl:when>
                <xsl:when
                    test="$targetLists/tp:targetLists/tp:targetList[@side = $leftRightSide][@term = '#id-hs']/tp:target/@IDvalue = concat('#', @xml:id)">
                    <xsl:value-of select="'hairside'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- Variable to insert the right displacement for double paths -->
        <xsl:variable name="leftOrRight">
            <xsl:choose>
                <xsl:when test="$left1_Right2_SQ = 1">
                    <xsl:value-of select="$doublePathDisplacementValue"/>
                </xsl:when>
                <xsl:when test="$left1_Right2_SQ = 2">
                    <xsl:value-of select="-$doublePathDisplacementValue"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- Variable to calculate the x value of the end of line -->
        <xsl:variable name="Mx">
            <xsl:value-of select="($Cx_SQ + ($delta * $countRegularBifolia - 2)) + $lineLength"/>
        </xsl:variable>
        <!-- Gathering number (if first folio) -->
        <xsl:call-template name="gatheringNumber">
            <xsl:with-param name="first" select="$first"/>
            <xsl:with-param name="Cx" select="$Cx_SQ"/>
            <xsl:with-param name="Cy" select="$Cy_SQ + $parametricY"/>
            <xsl:with-param name="direction" select="$direction"/>
            <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
            <xsl:with-param name="countRegularBifolia2" select="$countRegularBifolia2"/>
            <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
            <xsl:with-param name="gatheringNumber" select="$gatheringNumber"/>
            <xsl:with-param name="positions_SQ" select="$positions_SQ"/>
        </xsl:call-template>
        <g xmlns="http://www.w3.org/2000/svg">
            <!-- Move forward subquires -->
            <xsl:choose>
                <xsl:when test="contains(vc:q[1]/@n, '.')">
                    <xsl:attribute name="transform">
                        <xsl:value-of
                            select="concat('translate(', $parametricTranslation, ',', '0)')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!-- The arc is drawn only for complete bifolia -->
            <g>
                <xsl:choose>
                    <xsl:when
                        test="(vc:q[1]/vc:single/@certainty != 1) or not(vc:q[1]/vc:single/@val = 'yes')">
                        <!-- arc -->
                        <xsl:choose>
                            <xsl:when test="vc:q[1]/vc:single/@certainty = '2 | 3'">
                                <xsl:call-template name="certainty">
                                    <xsl:with-param name="certainty"
                                        select="vc:q[1]/vc:single/@certainty"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="vc:q[1]/vc:conjoin/@certainty != 1">
                                <xsl:call-template name="certainty">
                                    <xsl:with-param name="certainty"
                                        select="vc:q[1]/vc:conjoin/@certainty"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                        <!-- Description -->
                        <desc>
                            <xsl:text>Folio #</xsl:text>
                            <xsl:value-of select="vc:q[1]/@position"/>
                            <xsl:text>: arc</xsl:text>
                        </desc>
                        <!-- Arc path: bezier curve with controls set at a 90° angle  -->
                        <!-- When double paths are needed to encode visualizations for leaf sides, this corresponds to
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="arcPath_SQ">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY"/>
                                    <xsl:text>&#32;Q</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents_SQ * $delta))"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY"/>
                                    <xsl:text>&#32;</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents_SQ * $delta))"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY + $parametricY_SQ"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- When double paths are needed to encode visualizations for leaf sides, this path is drawn and it corresponds to
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="arcPath_SQ2">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY + $leftOrRight"/>
                                    <xsl:text>&#32;Q</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents_SQ * $delta)) + $doublePathDisplacementValue"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY"/>
                                    <xsl:text>&#32;</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia) - 2 - ($delta - 1 + ($followingRegularComponents_SQ * $delta)) + $doublePathDisplacementValue"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY + $parametricY_SQ"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- This draws the folio. When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:call-template name="arcPaths">
                            <xsl:with-param name="folioID" select="$folioID"/>
                            <xsl:with-param name="arcPath" select="$arcPath_SQ"/>
                            <xsl:with-param name="folioMode" select="$folioMode"/>
                            <xsl:with-param name="Q1_SQ2" select="2"/>
                        </xsl:call-template>
                        <!-- When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:choose>
                            <xsl:when test="$doublePaths = 1">
                                <xsl:call-template name="arcPaths">
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="arcPath" select="$arcPath_SQ2"/>
                                    <xsl:with-param name="folioMode" select="$folioMode2"/>
                                    <xsl:with-param name="Q1_SQ2" select="2"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </g>
            <g>
                <!-- Leaf and stub on same position -->
                <xsl:choose>
                    <xsl:when test="$precPos eq $leafPosition">
                        <xsl:attribute name="transform">
                            <xsl:value-of
                                select="concat('translate(', (($leafLength div 12) + $delta), ',', '0)')"
                            />
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <!-- The line is drawn only for complete bifolia or for singletons but not for further subquires-->
                <xsl:choose>
                    <xsl:when test="vc:q[1]/@n eq $subquireN">
                        <!-- line -->
                        <desc>
                            <xsl:text>Folio #</xsl:text>
                            <xsl:value-of select="vc:q[1]/@position"/>
                            <xsl:text>: line</xsl:text>
                        </desc>
                        <!-- Line path -->
                        <!-- When double paths are needed to encode visualizations for leaf sides, this corresponds to
                            tthe left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="linePath_SQ">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of select="$Mx"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY"/>
                                    <xsl:text>&#32;L</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- Line path -->
                        <!-- When double paths are needed to encode visualizations for leaf sides, this path is drawn and it corresponds to
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:variable name="linePath_SQ2">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of
                                        select="($Cx_SQ + ($delta * $countRegularBifolia - 2)) + $lineLength"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY + $leftOrRight"/>
                                    <xsl:text>&#32;L</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_SQ + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_SQ + $parametricY + $leftOrRight"/>
                                </xsl:attribute>
                            </path>
                        </xsl:variable>
                        <!-- This draws the folio. When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:call-template name="linepaths">
                            <xsl:with-param name="folioID" select="$folioID"/>
                            <xsl:with-param name="linePath" select="$linePath_SQ"/>
                            <xsl:with-param name="folioMode" select="$folioMode"/>
                            <xsl:with-param name="Q1_SQ2" select="2"/>
                        </xsl:call-template>
                        <!-- When double paths are needed to encode visualizations for leaf sides, this draws
                            the left side or right side depending on the position of the leaf (left or right of the centre)-->
                        <xsl:choose>
                            <xsl:when test="$doublePaths = 1">
                                <xsl:call-template name="linepaths">
                                    <xsl:with-param name="folioID" select="$folioID"/>
                                    <xsl:with-param name="linePath" select="$linePath_SQ2"/>
                                    <xsl:with-param name="folioMode" select="$folioMode2"/>
                                    <xsl:with-param name="Q1_SQ2" select="2"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                        <!-- Call attachment method template -->
                        <xsl:choose>
                            <xsl:when test="vc:attachment-method">
                                <xsl:for-each select="vc:attachment-method">
                                    <!-- Attachment Target Identification -->
                                    <xsl:choose>
                                        <xsl:when test="@target">
                                            <xsl:variable name="ownPosition">
                                                <xsl:value-of
                                                  select="parent::vc:leaf/vc:q[1]/@position"/>
                                            </xsl:variable>
                                            <xsl:variable name="ownQuireN">
                                                <xsl:value-of select="
                                                        if (contains(parent::vc:leaf/vc:q[1]/@n, '.')) then
                                                            substring-before(parent::vc:leaf/vc:q[1]/@n, '.')
                                                        else
                                                            parent::vc:leaf/vc:q[1]/@n"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="attachmentTargetID">
                                                <xsl:value-of select="substring-after(@target, '#')"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="attachmentTargetPosition">
                                                <xsl:value-of
                                                  select="$textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@position"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="attachmentTargetQuire">
                                                <xsl:value-of select="
                                                        if (contains($textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@n, '.')) then
                                                            substring-before($textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@n, '.')
                                                        else
                                                            $textblock/vc:textblock/vc:leaves/vc:leaf[@xml:id = $attachmentTargetID]/vc:q[1]/@n"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="attachmentDeviation">
                                                <xsl:variable name="attachmentDeviationValue">
                                                  <xsl:value-of
                                                  select="$ownPosition - $attachmentTargetPosition"
                                                  />
                                                </xsl:variable>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="$ownQuireN = $attachmentTargetQuire">
                                                  <xsl:value-of select="$attachmentDeviationValue"/>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$ownQuireN != $attachmentTargetQuire">
                                                  <xsl:value-of
                                                  select="-($attachmentDeviationValue)"/>
                                                  </xsl:when>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:call-template name="attachment-method">
                                                <xsl:with-param name="Cx_A" select="$Cx_SQ"/>
                                                <xsl:with-param name="Cy_A" select="
                                                        $Cy_SQ + $parametricY - (if (xs:integer($attachmentDeviation) gt 0) then
                                                            $delta
                                                        else
                                                            0)"/>
                                                <xsl:with-param name="countRegularBifolia"
                                                  select="$countRegularBifolia"/>
                                                <xsl:with-param name="countRegularBifolia2"
                                                  select="$countRegularBifolia2"/>
                                                <xsl:with-param name="lineLength"
                                                  select="$lineLength"/>
                                                <xsl:with-param name="parametricY"
                                                  select="$parametricY"/>
                                                <xsl:with-param name="attachmentDeviation"
                                                  select="$attachmentDeviation"/>
                                                <xsl:with-param name="certainty" select="@certainty"
                                                />
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- For patterns without the attachment target -->
                                            <xsl:call-template name="attachment-method">
                                                <xsl:with-param name="Cx_A" select="$Cx_SQ"/>
                                                <!--
                                                <xsl:with-param name="Cy_A"
                                                  select="
                                                        $Cy_SQ + $parametricY + ((if (xs:integer($left1_Right2_SQ) eq 1) then
                                                            1
                                                        else
                                                            -1) * ($delta div 2)) + ($delta * $followingComponents_SQ)"/>-->

                                                <xsl:with-param name="Cy_A">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="xs:integer($leafPosition) eq xs:integer($centralLeftLeafPos_SQ) or xs:integer($leafPosition) eq (xs:integer($centralLeftLeafPos_SQ) + 1)">
                                                  <xsl:value-of select="
                                                                    $Cy_SQ + $parametricY + ((if (xs:integer($left1_Right2_SQ) eq 1) then
                                                                        1
                                                                    else
                                                                        -1) * ($delta div 2)) + ($delta * $followingComponents_SQ)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="xs:integer($leafPosition) lt xs:integer($centralLeftLeafPos_SQ)">
                                                  <xsl:value-of select="
                                                                    $Cy_SQ + $parametricY + ((if (xs:integer($left1_Right2) eq 1) then
                                                                        1
                                                                    else
                                                                        -1) * ($delta div 2) + $delta)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="xs:integer($leafPosition) gt (xs:integer($centralLeftLeafPos_SQ) + 1)">
                                                  <xsl:value-of select="
                                                                    $Cy_SQ + $parametricY + ((if (xs:integer($left1_Right2_SQ) eq 1) then
                                                                        1
                                                                    else
                                                                        -1) * ($delta)) - ($delta div 2) + ($delta * $followingComponents_SQ)"
                                                  />
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:with-param>
                                                <xsl:with-param name="countRegularBifolia"
                                                  select="$countRegularBifolia"/>
                                                <xsl:with-param name="countRegularBifolia2"
                                                  select="$countRegularBifolia2"/>
                                                <xsl:with-param name="lineLength"
                                                  select="$lineLength"/>
                                                <xsl:with-param name="parametricY"
                                                  select="$parametricY"/>
                                                <xsl:with-param name="positions_SQ"
                                                  select="$positions_SQ"/>
                                                <xsl:with-param name="certainty" select="@certainty"
                                                />
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </g>
        </g>
        <!-- Folio Number variable: by default takes the content of the folioNumber element. 
            If empty, it'll take the value of folioNumber/@val. -->
        <xsl:variable name="folioNumberVar">
            <xsl:choose>
                <xsl:when test="vc:folioNumber/text()">
                    <xsl:value-of select="vc:folioNumber"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="vc:folioNumber/@val"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Add folio numbers to first and last -->
        <xsl:call-template name="firstLastFolioNumbers">
            <xsl:with-param name="first" select="$first"/>
            <xsl:with-param name="Cy" select="$Cy_SQ"/>
            <xsl:with-param name="parametricY" select="$parametricY"/>
            <xsl:with-param name="Cx" select="$Cx_SQ + $parametricTranslation"/>
            <xsl:with-param name="countRegularBifolia" select="$countRegularBifolia"/>
            <xsl:with-param name="lineLength" select="$parametricLeafLength"/>
            <xsl:with-param name="last" select="$last"/>
            <xsl:with-param name="folioNumber" select="$folioNumberVar"/>
            <xsl:with-param name="direction" select="$direction" tunnel="yes"/>
            <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template adds the folio numbers to the SVG.</xd:p>
        </xd:desc>
        <xd:param name="first">
            <xd:p>First leaf in the gathering (that is not 'missing' or is not a stub)</xd:p>
        </xd:param>
        <xd:param name="Cy">
            <xd:p>The value of Cy.</xd:p>
        </xd:param>
        <xd:param name="parametricY">
            <xd:p>Parametric Y values for each leaf: positive or negative depending on whether the
                leaf is in the left or right half pf the quire</xd:p>
        </xd:param>
        <xd:param name="Cx">
            <xd:p>The value of Cx.</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="lineLength">
            <xd:p>The line length varies for stubs, and is lengthened to gatherings with less leaves
                than the maximum in the textblock (so that the diagrams, if aligned, are all the
                same width.</xd:p>
        </xd:param>
        <xd:param name="last">
            <xd:p>Last leaf in the gathering (that is not 'missing' or is not a stub).</xd:p>
        </xd:param>
        <xd:param name="folioNumber">
            <xd:p>The numbering of the current folio</xd:p>
        </xd:param>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
        <xd:param name="endOfLineX">
            <xd:p>Parameter to store the end of line x value to write folio numbers (in R-L
                direction).</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="firstLastFolioNumbers">
        <xsl:param name="first"/>
        <xsl:param name="Cy"/>
        <xsl:param name="parametricY"/>
        <xsl:param name="Cx"/>
        <xsl:param name="countRegularBifolia" as="xs:integer"/>
        <xsl:param name="lineLength"/>
        <xsl:param name="last"/>
        <xsl:param name="folioNumber"/>
        <xsl:param name="direction" tunnel="yes"/>
        <xsl:param name="endOfLineX"/>
        <xsl:variable name="numberClass">
            <xsl:value-of select="
                    concat('folioNumber', if ($direction = 'r-l') then
                        ' folioNumber_R-L'
                    else
                        '')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$allNumbers = 0">
                <xsl:choose>
                    <xsl:when test="@xml:id eq $first">
                        <text xmlns="http://www.w3.org/2000/svg" dy="{$Cy + $parametricY}"
                            dx="{(($Cx + ($delta * $countRegularBifolia - 2)) + $lineLength) + ($delta div 2)}"
                            class="{$numberClass}">
                            <xsl:call-template name="writingDirRotation">
                                <xsl:with-param name="direction" select="$direction"/>
                                <xsl:with-param name="text" select="1"/>
                                <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                            </xsl:call-template>
                            <xsl:value-of select="$folioNumber"/>
                        </text>
                    </xsl:when>
                    <xsl:when test="@xml:id eq $last">
                        <text xmlns="http://www.w3.org/2000/svg" dy="{$Cy + $parametricY}"
                            dx="{(($Cx + ($delta * $countRegularBifolia - 2)) + $lineLength) + ($delta div 2)}"
                            class="{$numberClass}">
                            <xsl:call-template name="writingDirRotation">
                                <xsl:with-param name="direction" select="$direction"/>
                                <xsl:with-param name="text" select="1"/>
                                <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                            </xsl:call-template>
                            <xsl:value-of select="$folioNumber"/>
                        </text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <text xmlns="http://www.w3.org/2000/svg" dy="{$Cy + $parametricY}"
                    dx="{(($Cx + ($delta * $countRegularBifolia - 2)) + $lineLength) + ($delta div 2)}"
                    class="{$numberClass}">
                    <xsl:call-template name="writingDirRotation">
                        <xsl:with-param name="direction" select="$direction"/>
                        <xsl:with-param name="text" select="1"/>
                        <xsl:with-param name="endOfLineX" select="$endOfLineX"/>
                    </xsl:call-template>
                    <xsl:value-of select="$folioNumber"/>
                </text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>FolioID for JS highlighting.</xd:p>
        </xd:desc>
        <xd:param name="test">
            <xd:p>Checks if folio is missing.</xd:p>
        </xd:param>
        <xd:param name="standard">
            <xd:p>Standard ID text</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="folioID">
        <xsl:param name="test"/>
        <xsl:param name="standard"/>
        <xsl:choose>
            <xsl:when test="$test eq 'missing'">
                <xsl:value-of select="concat($standard, 'M')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$standard"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>CSS class attribute template.</xd:p>
        </xd:desc>
        <xd:param name="folioMode">
            <xd:p>Parameter to define the visualization of the mode of the folio. Regularly, these
                are coded in the XML model, however, for parchment leaves, the visualization
                requires to indicate flesh and hair sides, modes (missing, replaced, added) cannot
                also be visualized.</xd:p>
        </xd:param>
        <xd:param name="folioID">
            <xd:p>FolioID for JS highlighting</xd:p>
            <xd:p>One value for bifolium</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="CSSclass">
        <xsl:param name="folioMode" select="'original'"/>
        <xsl:param name="folioID" select="'notDef'"/>
        <xsl:variable name="classValue">
            <xsl:choose>
                <xsl:when test="$folioMode = 'original'">
                    <xsl:text>leaf </xsl:text>
                </xsl:when>
                <xsl:when test="$folioMode = 'missing'">
                    <xsl:text>missingLeaf </xsl:text>
                </xsl:when>
                <xsl:when test="$folioMode = 'replaced'">
                    <xsl:text>replacedLeaf </xsl:text>
                </xsl:when>
                <xsl:when test="$folioMode = 'added'">
                    <xsl:text>addedLeaf </xsl:text>
                </xsl:when>
                <!--<xsl:when test="$folioMode = 'added2'">
                    <xsl:text>addedLeaf2 </xsl:text>
                </xsl:when>-->
                <xsl:when test="$folioMode = 'fleshside'">
                    <xsl:text>fleshside </xsl:text>
                </xsl:when>
                <xsl:when test="$folioMode = 'hairside'">
                    <xsl:text>hairside </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- This adds the animal species colouring, if needed for biocodicolgy visualizations -->
        <xsl:variable name="animalSpeciesVar">
            <xsl:choose>
                <xsl:when test="$animalSpecies = 1">
                    <xsl:choose>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@term = '#id-calf']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:text>calfskin </xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@term = '#id-sheep']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:text>sheepskin </xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="$targetLists/tp:targetLists/tp:targetList[@term = '#id-goat']/tp:target/@IDvalue = concat('#', @xml:id)">
                            <xsl:text>goatskin </xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="class">
            <xsl:text>base </xsl:text>
            <xsl:copy-of select="$classValue"/>
            <xsl:choose>
                <xsl:when test="$animalSpecies = 1">
                    <xsl:copy-of select="$animalSpeciesVar"/>
                </xsl:when>
                <xsl:when test="$folioMode = 'missing'">
                    <!-- do nothing -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>leaf </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$folioID"/>
        </xsl:attribute>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>This template draws the attachment methods. The parameters necessary to draw the
                gatherings are passed from the previous template.</xd:p>
        </xd:desc>
        <xd:param name="Cx_A">
            <xd:p>The value of Cx for the attachment method.</xd:p>
        </xd:param>
        <xd:param name="Cy_A">
            <xd:p>The value of Cy for the attachment method.</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia">
            <xd:p>Variable to count how many bifolia should be drawn.</xd:p>
            <xd:p>If the total number of positions is an even number the components are the total
                number of positions/2, if odd = (the total number of positions - total number of
                singletons)/2</xd:p>
        </xd:param>
        <xd:param name="countRegularBifolia2">
            <xd:p>Refined parameter that only counts regular bifolia in the main gathering.</xd:p>
        </xd:param>
        <xd:param name="positions_SQ">
            <xd:p>Parameter to count the number of leaves in the current subquire.</xd:p>
        </xd:param>
        <xd:param name="lineLength">
            <xd:p>The line length varies for stubs, and is lengthened to gatherings with less leaves
                than the maximum in the textblock (so that the diagrams, if aligned, are all the
                same width.</xd:p>
        </xd:param>
        <xd:param name="parametricY">
            <xd:p>Parametric Y values for each leaf: positive or negative depending on whether the
                leaf is in the left or right half pf the quire</xd:p>
        </xd:param>
        <xd:param name="attachmentDeviation">
            <xd:p>Checks the deviation between the leaf and its attachment target: usually this
                would be the leaf before or after.</xd:p>
        </xd:param>
        <xd:param name="certainty">
            <xd:p>Certainty value.</xd:p>
        </xd:param>
        <xd:param name="direction">
            <xd:p>Writing direction.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="attachment-method">
        <xsl:param name="Cx_A"/>
        <xsl:param name="Cy_A"/>
        <xsl:param name="countRegularBifolia"/>
        <xsl:param name="countRegularBifolia2"/>
        <xsl:param name="positions_SQ" select="0"/>
        <xsl:param name="lineLength"/>
        <xsl:param name="parametricY"/>
        <xsl:param name="attachmentDeviation" select="1"/>
        <xsl:param name="certainty"/>
        <xsl:param name="direction" tunnel="yes"/>
        <g xmlns="http://www.w3.org/2000/svg">
            <!-- Uncertainty -->
            <xsl:call-template name="certainty">
                <xsl:with-param name="certainty" select="$certainty"/>
            </xsl:call-template>
            <xsl:attribute name="class">
                <xsl:text>leaf</xsl:text>
            </xsl:attribute>
            <desc xmlns="http://www.w3.org/2000/svg">
                <xsl:text>Attachment method - </xsl:text>
                <xsl:value-of select="@type"/>
            </desc>
            <xsl:choose>
                <xsl:when test="@type = 'sewn'">
                    <xsl:choose>
                        <xsl:when test="@target">
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of select="
                                            $Cx_A + ($delta * $countRegularBifolia - 2) + (if ($direction eq 'r-l') then
                                                1
                                            else
                                                1.5) * $delta"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_A - ($delta div 2)"/>
                                    <xsl:text>&#32;L</xsl:text>
                                    <xsl:value-of select="
                                            $Cx_A + ($delta * $countRegularBifolia - 2) + (if ($direction eq 'r-l') then
                                                1.5
                                            else
                                                1) * $delta"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="
                                            $Cy_A + ($delta * (if (xs:integer($attachmentDeviation) lt 0) then
                                                -$attachmentDeviation
                                            else
                                                $attachmentDeviation)) + ($delta div 2)"
                                    />
                                </xsl:attribute>
                            </path>
                        </xsl:when>
                        <xsl:otherwise>
                            <path>
                                <xsl:attribute name="d">
                                    <xsl:text>M</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_A + ($delta * $countRegularBifolia - 2)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_A"/>
                                    <xsl:text>&#32;L</xsl:text>
                                    <xsl:value-of
                                        select="$Cx_A + ($delta * $countRegularBifolia - 2) - ($delta * ($countRegularBifolia2 + 2)) - (($delta div 2) * $positions_SQ)"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$Cy_A"/>
                                </xsl:attribute>
                            </path>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@type = 'tacketed'">
                    <path>
                        <xsl:attribute name="d">
                            <xsl:text>M</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2)"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A - 3"/>
                            <xsl:text>&#32;Q</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2)"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A - 1"/>
                            <xsl:text>&#32;</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) - 2"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A - 1"/>
                            <xsl:text>M</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) - 2"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A - 1"/>
                            <xsl:text>&#32;L</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) - ($delta * ($countRegularBifolia2 + 2)) - (($delta div 2) * $positions_SQ)"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A - 1"/>                             
                        </xsl:attribute>
                    </path>
                    <path>
                        <xsl:attribute name="d">
                            <xsl:text>M</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2)"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A + 3"/>
                            <xsl:text>&#32;Q</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2)"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A + 1"/>
                            <xsl:text>&#32;</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) - 2"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A + 1"/>
                            <xsl:text>M</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) - 2"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A + 1"/>
                            <xsl:text>&#32;L</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) - ($delta * ($countRegularBifolia2 + 2)) - (($delta div 2) * $positions_SQ)"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A + 1"/>                             
                        </xsl:attribute>
                    </path>
                </xsl:when>
                <xsl:when test="@type = 'stitched'">
                    <xsl:variable name="exitPoint">
                        <xsl:choose>
                            <xsl:when test="
                                    every $leaf in current-group()
                                        satisfies $leaf/q[1]/single[@val = 'yes']">
                                <xsl:value-of select="$delta"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="2 * $delta - (2 * ($delta div 3))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <path>
                        <xsl:attribute name="d">
                            <xsl:text>M</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) + $delta"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of select="$Cy_A - ($delta div 3)"/>
                            <xsl:text>&#32;L</xsl:text>
                            <xsl:value-of
                                select="$Cx_A + ($delta * $countRegularBifolia - 2) + $delta"/>
                            <xsl:text>,</xsl:text>
                            <xsl:value-of
                                select="$Cy_A - ($delta * $attachmentDeviation) + $exitPoint"/>
                        </xsl:attribute>
                    </path>
                </xsl:when>
                <xsl:when test="@type = 'pasted'">
                    <rect x="{$Cx_A + ($delta * $countRegularBifolia - 2)}" y="{$Cy_A}"
                        width="{$lineLength}" height="{$delta}" fill="url(#gluedPattern)"
                        stroke-opacity="0.0"/>
                    <xsl:choose>
                        <xsl:when test="abs($attachmentDeviation) = 2">
                            <rect x="{$Cx_A + ($delta * $countRegularBifolia - 2)}"
                                y="{($Cy_A) - (if (xs:integer($attachmentDeviation) gt 0) then $delta else -1 * $delta)}"
                                width="{$lineLength}" height="{$delta}" fill="url(#gluedPattern)"
                                stroke-opacity="0.0"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@type = 'drummed'">
                    <rect x="{$Cx_A + ($delta * $countRegularBifolia - 2)}" y="{$Cy_A}"
                        width="{$lineLength div 4}" height="{$delta}" fill="url(#gluedPattern)"
                        stroke-opacity="0.0"/>
                    <rect
                        x="{$Cx_A + ($delta * $countRegularBifolia - 2) + (($lineLength div 4) * 3)}"
                        y="{$Cy_A}" width="{$lineLength div 4}" height="{$delta}"
                        fill="url(#gluedPattern)" stroke-opacity="0.0"/>
                </xsl:when>
                <xsl:when test="@type = 'tipped'">
                    <rect x="{$Cx_A + ($delta * $countRegularBifolia - 2)}" y="{$Cy_A}"
                        width="{$lineLength div 10}" height="{$delta}" fill="url(#gluedPattern)"
                        stroke-opacity="0.0"/>
                </xsl:when>
            </xsl:choose>
        </g>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>SVG definitions' template</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="defs">
        <defs xmlns="http://www.w3.org/2000/svg">
            <style type="text/css">
            <xsl:choose>                        
                <xsl:when test="$embedCSS = 1">
                    <!-- copy the CSS file content into the SVG -->
                    <xsl:text disable-output-escaping="yes"/>    
                    <xsl:copy-of select="unparsed-text($pathToCSS)"/>
                    <xsl:text disable-output-escaping="yes"/>                
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('@import url(', $pathToCSS, ')')"/>
                </xsl:otherwise>
            </xsl:choose>
            </style>
            <!-- Uncertainty can have three values: 1 = very certain, 2 = fairly certain, 3 = not certain -->
            <filter id="f1" filterUnits="userSpaceOnUse">
                <feGaussianBlur in="SourceGraphic" stdDeviation="0"/>
            </filter>
            <filter id="f2" filterUnits="userSpaceOnUse">
                <feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
            </filter>
            <filter id="f3" filterUnits="userSpaceOnUse">
                <feGaussianBlur in="SourceGraphic" stdDeviation="2"/>
            </filter>
            <!-- Pasted pattern -->
            <pattern id="gluedPattern" patternUnits="userSpaceOnUse" width="2" height="{$delta}"
                xlink:type="simple" xlink:show="other" xlink:actuate="onLoad"
                preserveAspectRatio="xMidYMid meet">
                <desc>Glue pattern</desc>
                <path d="{concat('M 0,0 L 4,',2*$delta)}" class="glued"/>
            </pattern>
        </defs>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Uncertainty template</xd:p>
        </xd:desc>
        <xd:param name="certainty">
            <xd:p>Certainty value.</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="certainty">
        <xsl:param name="certainty" select="1" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="$certainty eq 2 or 3">
                <xsl:attribute name="filter">
                    <xsl:value-of select="concat('url(#f', $certainty, ')')"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
