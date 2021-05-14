<?xml version="1.0" encoding="UTF-8"?>

<!-- TO DO:

* Only output one units folder (make sure the paths are the same for both single-page and multi-page views)
* Incorporate terms!

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:vc="http://viscoll.org/schema/collation/"
    exclude-result-prefixes="ss xd vc svg" version="2.0">

    <xsl:output name="html5" method="html" encoding="UTF-8" version="5" indent="yes"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
            <xd:p><xd:b>Modified on:</xd:b>April 29, 2016</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
            <xd:p><xd:b>Modified on:</xd:b> 2019-06-06</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Alberto Campagnolo</xd:p>
            <xd:p>This document takes as its input the output from
                viscoll_mod2_XML_to_processed-XML.xsl</xd:p>
            <xd:p>It generates: <xd:ul>
                    <xd:li>several HTML files that make up a collation site for a manuscript</xd:li>
                    <xd:li>a single HTML document (with -diagrams appended) containing diagrams for
                        each quire</xd:li>
                    <xd:li>a single HTML document containing digrams and bifolia view for the entire
                        manuscript</xd:li>
                    <xd:li>a single HTML containing collation formulas</xd:li>
                </xd:ul></xd:p>
            <xd:p>Congratulations! You are done!</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- Variable to find the path to the top folder of the textblock 
        (containing all the XML, SVG, HTML, CSS, JS, etc. files) -->
    <xsl:variable name="base-uri">
        <xsl:value-of select="tokenize(base-uri(), 'XML/')[1]"/>
    </xsl:variable>

    <!-- Variable setting "X", to be used when another folio number is empty -->
    <xsl:variable name="folNoX">
        <xsl:text>X</xsl:text>
    </xsl:variable>

    <!-- Variable setting "STUB", to be used when a folio number is empty because it is a stub -->
    <xsl:variable name="stubNoX">
        <xsl:text>STUB</xsl:text>
    </xsl:variable>

    <!--Variable setting the URL to the "X" image-->
    <xsl:variable name="imgX">
        <xsl:text>https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/x.jpg</xsl:text>
    </xsl:variable>

    <!--Variable setting the URL to the Stub Visualization-->
    <xsl:variable name="stubVis">
        <!-- Link to a stub visulization -->
        <xsl:text>STUB</xsl:text>
    </xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>Root template</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/viscoll">
        <xsl:apply-templates/>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to create the HTML files.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="textblock">
        <xsl:variable name="idno" select="@tbID"/>
        <xsl:variable name="tbName" select="title"/>
        <xsl:variable name="empty"/>
        <xsl:variable name="tbURL">
            <xsl:value-of select="@tbURL"/>
        </xsl:variable>
        <xsl:variable name="shelfmark">
            <xsl:value-of select="@shelfmark"/>
        </xsl:variable>
        <!-- Create one HTML files for each gathering -->
        <xsl:for-each select="gatherings/gathering">
            <xsl:variable name="gatheringNo" select="@n"/>
            <xsl:variable name="positions" select="@positions"/>
            <xsl:variable name="filename" select="concat($idno, '-', $gatheringNo, '.html')"/>
            <xsl:variable name="titleText">
                <xsl:text>Collation of </xsl:text>
                <xsl:value-of select="$shelfmark"/>
                <xsl:text>: gathering </xsl:text>
                <xsl:value-of select="$gatheringNo"/>
            </xsl:variable>
            <!-- Call template for Multiple HTML Files output -->
            <xsl:call-template name="multipleHTMLs">
                <xsl:with-param name="href"
                    select="concat($base-uri, 'HTML/gatherings/', $filename)"/>
                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                <xsl:with-param name="titleText" select="$titleText"/>
                <xsl:with-param name="shelfmark" select="$shelfmark"/>
                <xsl:with-param name="tbURL" select="$tbURL"/>
                <xsl:with-param name="tbName" select="$tbName"/>
                <xsl:with-param name="idno" select="$idno"/>
                <xsl:with-param name="positions" select="$positions"/>
                <xsl:with-param name="empty" select="$empty"/>
            </xsl:call-template>
        </xsl:for-each>
        <!--Diagram HTML output below-->
        <xsl:call-template name="HTMLdiagrams">
            <xsl:with-param name="idno" select="$idno"/>
            <xsl:with-param name="shelfmark" select="$shelfmark"/>
            <xsl:with-param name="tbName" select="$tbName"/>
            <xsl:with-param name="tbURL" select="$tbURL"/>
        </xsl:call-template>
        <!--One single page for all bifolia output below -->
        <xsl:call-template name="singlePageHTML">
            <xsl:with-param name="idno" select="$idno"/>
            <xsl:with-param name="shelfmark" select="$shelfmark"/>
            <xsl:with-param name="tbName" select="$tbName"/>
            <xsl:with-param name="tbURL" select="$tbURL"/>
            <xsl:with-param name="empty" select="$empty"/>
        </xsl:call-template>
        <!-- Collation Formulas -->
        <xsl:call-template name="collationFormulas">
            <xsl:with-param name="idno" select="$idno"/>
            <xsl:with-param name="shelfmark" select="$shelfmark"/>
            <xsl:with-param name="tbName" select="$tbName"/>
            <xsl:with-param name="tbURL" select="$tbURL"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>Template to generate HTML page with collation formulas.</xd:desc>
        <xd:param name="idno"/>
        <xd:param name="shelfmark"/>
        <xd:param name="tbName"/>
        <xd:param name="tbURL"/>
    </xd:doc>
    <xsl:template name="collationFormulas">
        <xsl:param name="idno"/>
        <xsl:param name="shelfmark"/>
        <xsl:param name="tbName"/>
        <xsl:param name="tbURL"/>
        <xsl:variable name="filename-formulas" select="concat($idno, '-formulas.html')"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base-uri, 'HTML/', $filename-formulas)"/>
        </xsl:variable>
        <xsl:result-document href="{$href}" format="html5">
            <xsl:variable name="titleText">
                <xsl:text>Gathering structure of </xsl:text>
                <xsl:value-of select="$shelfmark"/>
                <xsl:text>.</xsl:text>
            </xsl:variable>
            <!-- Record date and time of transformation -->
            <xsl:call-template name="DateTimeTransformationNote"/>
            <html lang="en">
                <xsl:call-template name="htmlHead">
                    <xsl:with-param name="shelfmark" select="$shelfmark"/>
                    <xsl:with-param name="titleText" select="$titleText"/>
                    <xsl:with-param name="titleText2"
                        select="concat('Collation Formulas - ', $tbName)"/>
                </xsl:call-template>
                <body>
                    <!-- this div is the same for all quires -->
                    <xsl:call-template name="divTop"/>
                    <p>
                        <xsl:text>Collation Formula for </xsl:text>
                        <a href="{$tbURL}">
                            <xsl:value-of select="$tbName"/>
                        </a>
                    </p>
                    <p>
                        <xsl:text>Formula 1: </xsl:text>
                        <xsl:copy-of
                            select="unparsed-text(concat($base-uri, 'XML/', $idno, '-formula_01.txt'))"
                        />
                    </p>
                    <p>
                        <xsl:text>Formula 2: </xsl:text>
                        <xsl:copy-of
                            select="unparsed-text(concat($base-uri, 'XML/', $idno, '-formula_02.txt'))"
                        />
                    </p>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc>Single page HTML</xd:desc>
        <xd:param name="idno"/>
        <xd:param name="shelfmark"/>
        <xd:param name="tbName"/>
        <xd:param name="tbURL"/>
        <xd:param name="empty"/>
    </xd:doc>
    <xsl:template name="singlePageHTML">
        <xsl:param name="idno"/>
        <xsl:param name="shelfmark"/>
        <xsl:param name="tbName"/>
        <xsl:param name="tbURL"/>
        <xsl:param name="empty"/>
        <xsl:variable name="filename" select="concat($idno, '.html')"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base-uri, 'HTML/', $filename)"/>
        </xsl:variable>
        <xsl:result-document href="{$href}" format="html5">
            <xsl:variable name="titleText">
                <xsl:call-template name="titleText">
                    <xsl:with-param name="shelfmark" select="$shelfmark"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Call template to record the date and time of the transformation -->
            <xsl:call-template name="DateTimeTransformationNote"/>
            <html lang="en">
                <!-- Call template to generate the HEAD of the file -->
                <xsl:call-template name="htmlHead">
                    <xsl:with-param name="titleText" select="$titleText"/>
                    <xsl:with-param name="titleText2"
                        select="concat('Gatherings - Gathering ', $tbName)"/>
                    <xsl:with-param name="shelfmark" select="$shelfmark"/>
                </xsl:call-template>
                <body>
                    <!-- Call topDiv template -->
                    <xsl:call-template name="divTop"/>
                    <!-- List of gatherings -->
                    <xsl:call-template name="listofquires">
                        <xsl:with-param name="tbURL" select="$tbURL"/>
                        <xsl:with-param name="tbName" select="$tbName"/>
                        <xsl:with-param name="idno" select="$idno"/>
                    </xsl:call-template>
                    <!-- Show/Hide units -->
                    <xsl:call-template name="helpTxtShowHideUnits"/>
                    <!-- For each gathering... -->
                    <xsl:for-each select="gatherings/gathering">
                        <xsl:variable name="gatheringNo" select="@n"/>
                        <xsl:variable name="positions" select="@positions"/>
                        <!-- Here we get one div class newquire, and then a quireset with three divs \
                            - one svg and two images (img1 and img2) -->
                        <xsl:for-each select="units/unit">
                            <xsl:comment>
                                begin set
                            </xsl:comment>
                            <!-- This sets up the pairs -->
                            <!--Variables set for the left and right positions, inside-->
                            <xsl:variable name="bi1" select="inside/left/leaf/vc:q/@position"/>
                            <xsl:variable name="bi2" select="inside/right/leaf/vc:q/@position"/>
                            <!-- Variables grabbing the image URLs for all four sides in the unit -->
                            <xsl:variable name="insideLeftImgTest" select="inside/left/leaf/@url"/>
                            <xsl:variable name="insideRightImgTest" select="inside/right/leaf/@url"/>
                            <xsl:variable name="outsideLeftImgTest" select="outside/left/leaf/@url"/>
                            <xsl:variable name="outsideRightImgTest"
                                select="outside/right/leaf/@url"/>
                            <!-- Variables checking when image URLs are empty and mode is missing, and replacing them with X image if they are -->
                            <xsl:variable name="insideLeftImg">
                                <xsl:call-template name="img">
                                    <xsl:with-param name="imgTest" select="$insideLeftImgTest"/>
                                    <xsl:with-param name="empty" select="$empty"/>
                                    <xsl:with-param name="stubVis" select="$stubVis"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="inside/left/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="inside/left/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="insideRightImg">
                                <xsl:call-template name="img">
                                    <xsl:with-param name="imgTest" select="$insideRightImgTest"/>
                                    <xsl:with-param name="empty" select="$empty"/>
                                    <xsl:with-param name="stubVis" select="$stubVis"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="inside/right/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="inside/right/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="outsideLeftImg">
                                <xsl:call-template name="img">
                                    <xsl:with-param name="imgTest" select="$outsideLeftImgTest"/>
                                    <xsl:with-param name="empty" select="$empty"/>
                                    <xsl:with-param name="stubVis" select="$stubVis"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="outside/left/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="outside/left/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="outsideRightImg">
                                <xsl:call-template name="img">
                                    <xsl:with-param name="imgTest" select="$outsideRightImgTest"/>
                                    <xsl:with-param name="empty" select="$empty"/>
                                    <xsl:with-param name="stubVis" select="$stubVis"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="outside/right/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="outside/right/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
                            <xsl:variable name="insideLeftFolNoTest" select="inside/left/leaf/@folN"/>
                            <xsl:variable name="insideRightFolNoTest"
                                select="inside/right/leaf/@folN"/>
                            <xsl:variable name="outsideLeftFolNoTest"
                                select="outside/left/leaf/@folN"/>
                            <xsl:variable name="outsideRightFolNoTest"
                                select="outside/right/leaf/@folN"/>
                            <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                            <xsl:variable name="insideLeftFolNo">
                                <xsl:call-template name="folNo">
                                    <xsl:with-param name="test" select="$insideLeftFolNoTest"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="inside/left/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="inside/left/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="insideRightFolNo">
                                <xsl:call-template name="folNo">
                                    <xsl:with-param name="test" select="$insideRightFolNoTest"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="inside/right/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="inside/right/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="outsideLeftFolNo">
                                <xsl:call-template name="folNo">
                                    <xsl:with-param name="test" select="$outsideLeftFolNoTest"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="outside/left/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="outside/left/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="outsideRightFolNo">
                                <xsl:call-template name="folNo">
                                    <xsl:with-param name="test" select="$outsideRightFolNoTest"/>
                                    <xsl:with-param name="pathToMissing"
                                        select="outside/right/leaf/vc:mode/@val"/>
                                    <xsl:with-param name="pathToStub"
                                        select="outside/right/leaf/@stub"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
                            <!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
                            <xsl:variable name="leftFolTest">
                                <xsl:call-template name="folTest">
                                    <xsl:with-param name="folNo" select="$insideLeftFolNo"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="rightFolTest">
                                <xsl:call-template name="folTest">
                                    <xsl:with-param name="folNo" select="$insideRightFolNo"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                            <xsl:variable name="leftFol">
                                <xsl:call-template name="fol">
                                    <xsl:with-param name="folTest" select="$leftFolTest"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="rightFol">
                                <xsl:call-template name="fol">
                                    <xsl:with-param name="folTest" select="$rightFolTest"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="leftFolFileName">
                                <xsl:call-template name="folFileName">
                                    <xsl:with-param name="fol" select="$leftFol"/>
                                    <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                    <xsl:with-param name="bi1" select="$bi1"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="rightFolFileName">
                                <xsl:call-template name="folFileName">
                                    <xsl:with-param name="fol" select="$rightFol"/>
                                    <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                    <xsl:with-param name="bi1" select="$bi1"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:call-template name="newGathering">
                                <xsl:with-param name="extended" select="'yes'"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="leftFol" select="$leftFol"/>
                                <xsl:with-param name="rightFol" select="$rightFol"/>
                            </xsl:call-template>
                            <div class="quireset">
                                <div class="quireset">
                                    <xsl:call-template name="SVGobject">
                                        <xsl:with-param name="idno" select="$idno"/>
                                        <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                        <xsl:with-param name="relativePath" select="'../SVG/'"/>
                                    </xsl:call-template>
                                </div>
                                <!-- Division with img1 -->
                                <xsl:call-template name="img1">
                                    <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                    <xsl:with-param name="leftFol" select="$leftFol"/>
                                    <xsl:with-param name="rightFol" select="$rightFol"/>
                                    <xsl:with-param name="leftFolFileName" select="$leftFolFileName"/>
                                    <xsl:with-param name="rightFolFileName"
                                        select="$rightFolFileName"/>
                                    <xsl:with-param name="insideLeftImg" select="$insideLeftImg"/>
                                    <xsl:with-param name="insideLeftFolNo" select="$insideLeftFolNo"/>
                                    <xsl:with-param name="insideRightImg" select="$insideRightImg"/>
                                    <xsl:with-param name="insideRightFolNo"
                                        select="$insideRightFolNo"/>
                                </xsl:call-template>
                                <!-- Division with img2 -->
                                <xsl:call-template name="img2">
                                    <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                    <xsl:with-param name="leftFol" select="$leftFol"/>
                                    <xsl:with-param name="rightFol" select="$rightFol"/>
                                    <xsl:with-param name="leftFolFileName" select="$leftFolFileName"/>
                                    <xsl:with-param name="rightFolFileName"
                                        select="$rightFolFileName"/>
                                    <xsl:with-param name="outsideLeftImg" select="$outsideLeftImg"/>
                                    <xsl:with-param name="outsideLeftFolNo"
                                        select="$outsideLeftFolNo"/>
                                    <xsl:with-param name="outsideRightImg" select="$outsideRightImg"/>
                                    <xsl:with-param name="outsideRightFolNo"
                                        select="$outsideRightFolNo"/>
                                </xsl:call-template>
                            </div>
                            <!-- inside table HTML -->
                            <xsl:call-template name="insideTableHTML">
                                <xsl:with-param name="idno" select="$idno"/>
                                <xsl:with-param name="leftFolFileName" select="$leftFolFileName"/>
                                <xsl:with-param name="rightFolFileName" select="$rightFolFileName"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="leftFol" select="$leftFol"/>
                                <xsl:with-param name="rightFol" select="$rightFol"/>
                                <xsl:with-param name="insideLeftImg" select="$insideLeftImg"/>
                                <xsl:with-param name="insideLeftFolNo" select="$insideLeftFolNo"/>
                                <xsl:with-param name="insideRightImg" select="$insideRightImg"/>
                                <xsl:with-param name="insideRightFolNo" select="$insideRightFolNo"/>
                            </xsl:call-template>
                            <!-- outside table HTML -->
                            <xsl:call-template name="outsideTableHTML">
                                <xsl:with-param name="idno" select="$idno"/>
                                <xsl:with-param name="leftFolFileName" select="$leftFolFileName"/>
                                <xsl:with-param name="rightFolFileName" select="$rightFolFileName"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="leftFol" select="$leftFol"/>
                                <xsl:with-param name="rightFol" select="$rightFol"/>
                                <xsl:with-param name="outsideLeftImg" select="$outsideLeftImg"/>
                                <xsl:with-param name="outsideLeftFolNo" select="$outsideLeftFolNo"/>
                                <xsl:with-param name="outsideRightImg" select="$outsideRightImg"/>
                                <xsl:with-param name="outsideRightFolNo" select="$outsideRightFolNo"
                                />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:for-each>
                </body>
                <xsl:call-template name="js-highlight"/>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc>One webpage per leaf according to the visualization structure</xd:desc>
        <xd:param name="idno"/>
        <xd:param name="leftFolFileName"/>
        <xd:param name="rightFolFileName"/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="outsideLeftImg"/>
        <xd:param name="outsideLeftFolNo"/>
        <xd:param name="outsideRightImg"/>
        <xd:param name="outsideRightFolNo"/>
    </xd:doc>
    <xsl:template name="outsideTableHTML">
        <xsl:param name="idno"/>
        <xsl:param name="leftFolFileName"/>
        <xsl:param name="rightFolFileName"/>
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="outsideLeftImg"/>
        <xsl:param name="outsideLeftFolNo"/>
        <xsl:param name="outsideRightImg"/>
        <xsl:param name="outsideRightFolNo"/>
        <xsl:variable name="filename_o"
            select="concat('/units/', $leftFolFileName, '_', $rightFolFileName, '_o.html')"/>
        <xsl:variable name="href_o">
            <xsl:value-of select="concat($base-uri, 'HTML/', $filename_o)"/>
        </xsl:variable>
        <xsl:result-document href="{$href_o}" format="html5">
            <xsl:for-each select="outside">
                <xsl:variable name="titleText">
                    <xsl:call-template name="titleText">
                        <xsl:with-param name="shelfmark"/>
                    </xsl:call-template>
                </xsl:variable>
                <!-- Record date and time of transformation -->
                <xsl:call-template name="DateTimeTransformationNote"/>
                <html lang="en">
                    <head>
                        <xsl:call-template name="titleText2">
                            <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                            <xsl:with-param name="leftFol" select="$leftFol"/>
                            <xsl:with-param name="rightFol" select="$rightFol"/>
                            <xsl:with-param name="insideOutside" select="'outside'"/>
                        </xsl:call-template>
                        <!-- ADD META??? -->
                        <xsl:call-template name="linkCSS"/>
                    </head>
                    <xsl:call-template name="tableImg">
                        <xsl:with-param name="leftImg" select="$outsideLeftImg"/>
                        <xsl:with-param name="leftFolNo" select="$outsideLeftFolNo"/>
                        <xsl:with-param name="rightImg" select="$outsideRightImg"/>
                        <xsl:with-param name="rightFolNo" select="$outsideRightFolNo"/>
                    </xsl:call-template>
                </html>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="idno"/>
        <xd:param name="leftFolFileName"/>
        <xd:param name="rightFolFileName"/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="insideLeftImg"/>
        <xd:param name="insideLeftFolNo"/>
        <xd:param name="insideRightImg"/>
        <xd:param name="insideRightFolNo"/>
    </xd:doc>
    <xsl:template name="insideTableHTML">
        <xsl:param name="idno"/>
        <xsl:param name="leftFolFileName"/>
        <xsl:param name="rightFolFileName"/>
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="insideLeftImg"/>
        <xsl:param name="insideLeftFolNo"/>
        <xsl:param name="insideRightImg"/>
        <xsl:param name="insideRightFolNo"/>
        <xsl:variable name="filename_i"
            select="concat('/units/', $leftFolFileName, '_', $rightFolFileName, '_i.html')"/>
        <xsl:variable name="href_i">
            <xsl:value-of select="concat($base-uri, 'HTML/', $filename_i)"/>
        </xsl:variable>
        <xsl:result-document href="{$href_i}" format="html5">
            <xsl:for-each select="inside">
                <xsl:variable name="titleText">
                    <xsl:call-template name="titleText">
                        <xsl:with-param name="shelfmark"/>
                    </xsl:call-template>
                </xsl:variable>
                <!-- Record date and time of transformation -->
                <xsl:call-template name="DateTimeTransformationNote"/>
                <html lang="en">
                    <head>
                        <xsl:call-template name="titleText2">
                            <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                            <xsl:with-param name="leftFol" select="$leftFol"/>
                            <xsl:with-param name="rightFol" select="$rightFol"/>
                            <xsl:with-param name="insideOutside" select="'inside'"/>
                        </xsl:call-template>
                        <!-- ADD META??? -->
                        <xsl:call-template name="linkCSS"/>
                    </head>
                    <xsl:call-template name="tableImg">
                        <xsl:with-param name="leftImg" select="$insideLeftImg"/>
                        <xsl:with-param name="leftFolNo" select="$insideLeftFolNo"/>
                        <xsl:with-param name="rightImg" select="$insideRightImg"/>
                        <xsl:with-param name="rightFolNo" select="$insideRightFolNo"/>
                    </xsl:call-template>
                </html>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="leftImg"/>
        <xd:param name="leftFolNo"/>
        <xd:param name="rightImg"/>
        <xd:param name="rightFolNo"/>
    </xd:doc>
    <xsl:template name="tableImg">
        <xsl:param name="leftImg"/>
        <xsl:param name="leftFolNo"/>
        <xsl:param name="rightImg"/>
        <xsl:param name="rightFolNo"/>
        <body>
            <table id="tblimages">
                <tr>
                    <td>
                        <img src="{$leftImg}" class="bifolimage" alt="{$leftFolNo}"/>
                    </td>
                    <td>
                        <img src="{$rightImg}" class="bifolimage" alt="{$rightFolNo}"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <xsl:value-of select="$leftFolNo"/>
                    </td>
                    <td>
                        <xsl:value-of select="$rightFolNo"/>
                    </td>
                </tr>
            </table>
        </body>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="linkCSS">
        <link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/imagepages.css"
            rel="stylesheet" type="text/css"/>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="insideOutside"/>
    </xd:doc>
    <xsl:template name="titleText2">
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="insideOutside"/>
        <title>
            <xsl:text>Quire </xsl:text>
            <xsl:value-of select="$gatheringNo"/>
            <xsl:text>, Unit </xsl:text>
            <xsl:value-of select="$leftFol"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$rightFol"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$insideOutside"/>
        </title>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="idno"/>
        <xd:param name="shelfmark"/>
        <xd:param name="tbName"/>
        <xd:param name="tbURL"/>
    </xd:doc>
    <xsl:template name="HTMLdiagrams">
        <xsl:param name="idno"/>
        <xsl:param name="shelfmark"/>
        <xsl:param name="tbName"/>
        <xsl:param name="tbURL"/>
        <xsl:variable name="filename-diagrams" select="concat($idno, '-diagrams.html')"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base-uri, 'HTML/', $filename-diagrams)"/>
        </xsl:variable>
        <xsl:result-document href="{$href}" format="html5">
            <xsl:variable name="titleText">
                <xsl:call-template name="titleText">
                    <xsl:with-param name="shelfmark" select="$shelfmark"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Call template to record the date and time of the transformation -->
            <xsl:call-template name="DateTimeTransformationNote"/>
            <html lang="en">
                <!-- Call template to generate the HEAD of the file -->
                <xsl:call-template name="htmlHead">
                    <xsl:with-param name="titleText" select="$titleText"/>
                    <xsl:with-param name="titleText2"
                        select="concat('Gatherings - Gathering ', $tbName)"/>
                    <xsl:with-param name="shelfmark" select="$shelfmark"/>
                </xsl:call-template>
                <body>
                    <!-- Call topDiv template -->
                    <xsl:call-template name="divTop"/>
                    <!-- List of gatherings -->
                    <xsl:call-template name="listofquires">
                        <xsl:with-param name="tbURL" select="$tbURL"/>
                        <xsl:with-param name="tbName" select="$tbName"/>
                        <xsl:with-param name="idno" select="$idno"/>
                    </xsl:call-template>
                    <!-- Show/Hide units -->
                    <xsl:call-template name="helpTxtShowHideUnits"/>
                    <!-- For each gathering... -->
                    <xsl:for-each select="gatherings/gathering">
                        <xsl:variable name="gatheringNo" select="@n"/>
                        <xsl:variable name="positions" select="@positions"/>
                        <!-- Here we get one div class newquire, and then a quireset with three divs
                            - one svg and two images (img1 and img2) -->
                        <xsl:comment>
                                begin set
                        </xsl:comment>
                        <!-- This sets up the pairs -->
                        <!--Variables set for the left and right positions, inside-->
                        <xsl:variable name="bi1" select="units/unit/inside/left/leaf/vc:q/@position"/>
                        <xsl:variable name="bi2"
                            select="units/unit/inside/right/leaf/vc:q/@position"/>
                        <!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
                        <xsl:variable name="insideLeftFolNoTest"
                            select="units/unit[@n = '1']/inside/left/leaf/@folN"/>
                        <xsl:variable name="insideRightFolNoTest"
                            select="units/unit[@n = '1']/inside/right/leaf/@folN"/>
                        <xsl:variable name="outsideLeftFolNoTest"
                            select="units/unit[@n = '1']/outside/left/leaf/@folN"/>
                        <xsl:variable name="outsideRightFolNoTest"
                            select="units/unit[@n = '1']/outside/right/leaf/@folN"/>
                        <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                        <xsl:variable name="insideLeftFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$insideLeftFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="units/unit/inside/left/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub"
                                    select="units/unit/inside/left/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="insideRightFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$insideRightFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="units/unit/inside/right/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub"
                                    select="units/unit/inside/right/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="outsideLeftFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$outsideLeftFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="units/unit/outside/left/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub"
                                    select="units/unit/outside/left/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="outsideRightFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$outsideRightFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="units/unit/outside/right/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub"
                                    select="units/unit/outside/right/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
                        <!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
                        <xsl:variable name="leftFolTest">
                            <xsl:call-template name="folTest">
                                <xsl:with-param name="folNo" select="$insideLeftFolNo"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="rightFolTest">
                            <xsl:call-template name="folTest">
                                <xsl:with-param name="folNo" select="$insideRightFolNo"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                        <xsl:variable name="leftFol">
                            <xsl:call-template name="fol">
                                <xsl:with-param name="folTest" select="$leftFolTest"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="rightFol">
                            <xsl:call-template name="fol">
                                <xsl:with-param name="folTest" select="$rightFolTest"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="newGathering">
                            <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                            <xsl:with-param name="extended" select="'no'"/>
                        </xsl:call-template>
                        <div class="quireset">
                            <xsl:call-template name="SVGobject">
                                <xsl:with-param name="idno" select="$idno"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="relativePath" select="'../SVG/'"/>
                            </xsl:call-template>
                        </div>
                    </xsl:for-each>
                </body>
                <xsl:call-template name="js-highlight"/>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="shelfmark"/>
    </xd:doc>
    <xsl:template name="titleText">
        <xsl:param name="shelfmark"/>
        <xsl:text>Gathering structure of </xsl:text>
        <xsl:value-of select="$shelfmark"/>
        <xsl:text>.</xsl:text>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="extended"/>
    </xd:doc>
    <xsl:template name="newGathering">
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="extended"/>
        <div class="newquire">
            <span class="bititles">
                <a href="javascript:void(0);">
                    <xsl:text>Quire</xsl:text>
                    <xsl:value-of select="$gatheringNo"/>
                    <xsl:choose>
                        <xsl:when test="$extended eq 'yes'">
                            <xsl:text>, Unit </xsl:text>
                            <xsl:value-of select="$leftFol"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="$rightFol"/>
                        </xsl:when>
                    </xsl:choose>
                </a>
            </span>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="helpTxtShowHideUnits">
        <br/>
        <span class="helptext">Select a unit to display/hide, or </span>
        <br/>
        <span class="btn2">Show All Units</span>
        <xsl:text> </xsl:text>
        <xsl:text> </xsl:text>
        <span class="btn1">Hide All Units</span>
        <xsl:text> </xsl:text>
        <xsl:text> </xsl:text>
        <xsl:text> </xsl:text>
        <br/>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="tbURL"/>
        <xd:param name="tbName"/>
        <xd:param name="idno"/>
    </xd:doc>
    <xsl:template name="listofquires">
        <xsl:param name="tbURL"/>
        <xsl:param name="tbName"/>
        <xsl:param name="idno"/>
        <!-- This div will be the same for all quires -->
        <div id="listofquires">
            <span class="mstitle">
                <a href="{$tbURL}" target="_blank"><xsl:value-of select="$tbName"/>, <xsl:value-of
                        select="$idno"/></a>
            </span>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="href"/>
        <xd:param name="gatheringNo"/>
        <xd:param name="titleText"/>
        <xd:param name="shelfmark"/>
        <xd:param name="tbURL"/>
        <xd:param name="tbName"/>
        <xd:param name="idno"/>
        <xd:param name="positions"/>
        <xd:param name="empty"/>
    </xd:doc>
    <xsl:template name="multipleHTMLs">
        <xsl:param name="href"/>
        <xsl:param name="gatheringNo"/>
        <xsl:param name="titleText"/>
        <xsl:param name="shelfmark"/>
        <xsl:param name="tbURL"/>
        <xsl:param name="tbName"/>
        <xsl:param name="idno"/>
        <xsl:param name="positions"/>
        <xsl:param name="empty"/>
        <xsl:result-document href="{$href}" format="html5">
            <!-- Call template to record the date and time of the transformation -->
            <xsl:call-template name="DateTimeTransformationNote"/>
            <html lang="en">
                <!-- Call template to generate the HEAD of the file -->
                <xsl:call-template name="htmlHead">
                    <xsl:with-param name="titleText" select="$titleText"/>
                    <xsl:with-param name="titleText2"
                        select="concat('Collation - Quire ', $gatheringNo)"/>
                    <xsl:with-param name="shelfmark" select="$shelfmark"/>
                </xsl:call-template>
                <body>
                    <!-- Call topDiv template -->
                    <xsl:call-template name="divTop"/>
                    <!-- This div will be the same for all quires -->
                    <div id="listofquires">
                        <span class="mstitle"><a href="{$tbURL}" target="_blank"><xsl:value-of
                                    select="$tbName"/>, <xsl:value-of select="$idno"/></a></span>
                        <xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text><xsl:text> </xsl:text>
                        <select name="quirelist" id="quirelist"
                            onchange="MM_jumpMenu('parent',this,1)">
                            <option>Select a Gathering</option>
                            <xsl:for-each select="parent::gatherings/gathering">
                                <xsl:element name="option">
                                    <xsl:attribute name="value"><xsl:value-of
                                            select="concat($idno, '-', @n, '.html')"
                                        /></xsl:attribute> Gathering <xsl:value-of select="@n"/>
                                        (<xsl:value-of select="@positions"/>) </xsl:element>
                            </xsl:for-each>
                        </select>
                    </div>
                    <br/> Gathering <xsl:value-of select="$gatheringNo"/> (<xsl:value-of
                        select="$positions"/>)<xsl:text> </xsl:text><xsl:text> </xsl:text>
                    <xsl:for-each select="units/unit">
                        <xsl:comment>
                                begin set
                            </xsl:comment>
                        <!-- This sets up the pairs -->
                        <!--Variables set for the left and right positions, inside-->
                        <xsl:variable name="bi1" select="inside/left/leaf/vc:q/@position"/>
                        <xsl:variable name="bi2" select="inside/right/leaf/vc:q/@position"/>
                        <!-- Variables grabbing the image URLs for all four sides in the unit -->
                        <xsl:variable name="insideLeftImgTest" select="inside/left/leaf/@url"/>
                        <xsl:variable name="insideRightImgTest" select="inside/right/leaf/@url"/>
                        <xsl:variable name="outsideLeftImgTest" select="outside/left/leaf/@url"/>
                        <xsl:variable name="outsideRightImgTest" select="outside/right/leaf/@url"/>
                        <!-- Variables checking when image URLs are empty and mode is missing, and replacing them with X image if they are -->
                        <xsl:variable name="insideLeftImg">
                            <xsl:call-template name="img">
                                <xsl:with-param name="imgTest" select="$insideLeftImgTest"/>
                                <xsl:with-param name="empty" select="$empty"/>
                                <xsl:with-param name="stubVis" select="$stubVis"/>
                                <xsl:with-param name="pathToMissing"
                                    select="inside/left/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="inside/left/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="insideRightImg">
                            <xsl:call-template name="img">
                                <xsl:with-param name="imgTest" select="$insideRightImgTest"/>
                                <xsl:with-param name="empty" select="$empty"/>
                                <xsl:with-param name="stubVis" select="$stubVis"/>
                                <xsl:with-param name="pathToMissing"
                                    select="inside/right/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="inside/right/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="outsideLeftImg">
                            <xsl:call-template name="img">
                                <xsl:with-param name="imgTest" select="$outsideLeftImgTest"/>
                                <xsl:with-param name="empty" select="$empty"/>
                                <xsl:with-param name="stubVis" select="$stubVis"/>
                                <xsl:with-param name="pathToMissing"
                                    select="outside/left/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="outside/left/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="outsideRightImg">
                            <xsl:call-template name="img">
                                <xsl:with-param name="imgTest" select="$outsideRightImgTest"/>
                                <xsl:with-param name="empty" select="$empty"/>
                                <xsl:with-param name="stubVis" select="$stubVis"/>
                                <xsl:with-param name="pathToMissing"
                                    select="outside/right/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="outside/right/leaf/@stub"
                                />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
                        <xsl:variable name="insideLeftFolNoTest" select="inside/left/leaf/@folN"/>
                        <xsl:variable name="insideRightFolNoTest" select="inside/right/leaf/@folN"/>
                        <xsl:variable name="outsideLeftFolNoTest" select="outside/left/leaf/@folN"/>
                        <xsl:variable name="outsideRightFolNoTest" select="outside/right/leaf/@folN"/>
                        <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                        <xsl:variable name="insideLeftFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$insideLeftFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="inside/left/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="inside/left/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="insideRightFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$insideRightFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="inside/right/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="inside/right/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="outsideLeftFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$outsideLeftFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="outside/left/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="outside/left/leaf/@stub"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="outsideRightFolNo">
                            <xsl:call-template name="folNo">
                                <xsl:with-param name="test" select="$outsideRightFolNoTest"/>
                                <xsl:with-param name="pathToMissing"
                                    select="outside/right/leaf/vc:mode/@val"/>
                                <xsl:with-param name="pathToStub" select="outside/right/leaf/@stub"
                                />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
                        <!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
                        <xsl:variable name="leftFolTest">
                            <xsl:call-template name="folTest">
                                <xsl:with-param name="folNo" select="$insideLeftFolNo"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="rightFolTest">
                            <xsl:call-template name="folTest">
                                <xsl:with-param name="folNo" select="$insideRightFolNo"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
                        <xsl:variable name="leftFol">
                            <xsl:call-template name="fol">
                                <xsl:with-param name="folTest" select="$leftFolTest"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="rightFol">
                            <xsl:call-template name="fol">
                                <xsl:with-param name="folTest" select="$rightFolTest"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="leftFolFileName">
                            <xsl:call-template name="folFileName">
                                <xsl:with-param name="fol" select="$leftFol"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="bi1" select="$bi1"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="rightFolFileName">
                            <xsl:call-template name="folFileName">
                                <xsl:with-param name="fol" select="$rightFol"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="bi1" select="$bi1"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="divsetNo" select="@n"/>
                        <!-- Code to show/hide gatherings. N.B. Uncomment to activate -->
                        <xsl:call-template name="showHideGatherings">
                            <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                            <xsl:with-param name="leftFol" select="$leftFol"/>
                            <xsl:with-param name="rightFol" select="$rightFol"/>
                            <xsl:with-param name="divsetNo" select="$divsetNo"/>
                        </xsl:call-template>
                        <br/>
                        <div>
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('divset', $divsetNo)"/>
                            </xsl:attribute>
                            <!-- Call template with SVG object division -->
                            <xsl:call-template name="SVGobject">
                                <xsl:with-param name="idno" select="$idno"/>
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="relativePath" select="'../../SVG/'"/>
                            </xsl:call-template>
                            <!-- Division with img1 -->
                            <xsl:call-template name="img1">
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="leftFol" select="$leftFol"/>
                                <xsl:with-param name="rightFol" select="$rightFol"/>
                                <xsl:with-param name="leftFolFileName" select="$leftFolFileName"/>
                                <xsl:with-param name="rightFolFileName" select="$rightFolFileName"/>
                                <xsl:with-param name="insideLeftImg" select="$insideLeftImg"/>
                                <xsl:with-param name="insideLeftFolNo" select="$insideLeftFolNo"/>
                                <xsl:with-param name="insideRightImg" select="$insideRightImg"/>
                                <xsl:with-param name="insideRightFolNo" select="$insideRightFolNo"/>
                            </xsl:call-template>
                            <!-- Division with img2 -->
                            <xsl:call-template name="img2">
                                <xsl:with-param name="gatheringNo" select="$gatheringNo"/>
                                <xsl:with-param name="leftFol" select="$leftFol"/>
                                <xsl:with-param name="rightFol" select="$rightFol"/>
                                <xsl:with-param name="leftFolFileName" select="$leftFolFileName"/>
                                <xsl:with-param name="rightFolFileName" select="$rightFolFileName"/>
                                <xsl:with-param name="outsideLeftImg" select="$outsideLeftImg"/>
                                <xsl:with-param name="outsideLeftFolNo" select="$outsideLeftFolNo"/>
                                <xsl:with-param name="outsideRightImg" select="$outsideRightImg"/>
                                <xsl:with-param name="outsideRightFolNo" select="$outsideRightFolNo"
                                />
                            </xsl:call-template>
                        </div>
                    </xsl:for-each>
                </body>
                <!-- insert javascript to highlight current leaf in svg diagrams -->
                <xsl:call-template name="js-highlight"/>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="divsetNo"/>
    </xd:doc>
    <xsl:template name="showHideGatherings">
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="divsetNo"/>
        <xsl:comment> If you would like to include the ability to show and hide gatherings, uncomment the code below </xsl:comment>
        <xsl:comment>
                                <div class="bititles">
                                    <xsl:text>Gathering</xsl:text>
                                    <xsl:value-of select="$gatheringNo"/>
                                    <xsl:text>, Unit </xsl:text>
                                    <xsl:value-of select="$leftFol"/>
                                    <xsl:text>, </xsl:text>
                                    <xsl:value-of select="$rightFol"/>
                                    <xsl:text> </xsl:text><xsl:text> </xsl:text>
                                    <a href="#" onclick="MM_changeProp('divset{$divsetNo}','','height','auto','DIV')">
                                        <img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/open.gif" alt="Open" class="openimage"/>
                                    </a>
                                    <a href="#" onclick="MM_changeProp('divset{$divsetNo}','','height','0px','DIV')">
                                        <img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/close.gif" alt="Close" class="closeimage"/>
                                    </a>
                                </div>
                            </xsl:comment>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="fol"/>
        <xd:param name="gatheringNo"/>
        <xd:param name="bi1"/>
    </xd:doc>
    <xsl:template name="folFileName">
        <xsl:param name="fol"/>
        <xsl:param name="gatheringNo"/>
        <xsl:param name="bi1"/>
        <xsl:choose>
            <xsl:when test="$fol = $folNoX">
                <xsl:value-of select="concat($folNoX, $gatheringNo, $bi1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fol"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="folTest"/>
    </xd:doc>
    <xsl:template name="fol">
        <xsl:param name="folTest"/>
        <xsl:choose>
            <xsl:when test="not($folTest)">
                <!-- change for stubs? -->
                <xsl:value-of select="$folNoX"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$folTest"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="folNo"/>
    </xd:doc>
    <xsl:template name="folTest">
        <xsl:param name="folNo"/>
        <xsl:choose>
            <xsl:when test="contains($folNo, 'r') or contains($folNo, 'v')">
                <xsl:value-of
                    select="concat(substring-before($folNo, 'r'), substring-before($folNo, 'v'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$folNo"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="test"/>
        <xd:param name="pathToMissing"/>
        <xd:param name="pathToStub"/>
    </xd:doc>
    <xsl:template name="folNo">
        <xsl:param name="test"/>
        <xsl:param name="pathToMissing"/>
        <xsl:param name="pathToStub"/>
        <xsl:choose>
            <xsl:when test="not($test)">
                <xsl:choose>
                    <xsl:when test="$pathToMissing eq 'missing'">
                        <xsl:value-of select="$folNoX"/>
                    </xsl:when>
                    <xsl:when test="$pathToStub eq 'yes'">
                        <xsl:value-of select="$stubNoX"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$test"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
        <xd:param name="imgTest"/>
        <xd:param name="empty"/>
        <xd:param name="stubVis"/>
        <xd:param name="pathToMissing"/>
        <xd:param name="pathToStub"/>
    </xd:doc>
    <xsl:template name="img">
        <xsl:param name="imgTest"/>
        <xsl:param name="empty"/>
        <xsl:param name="stubVis"/>
        <xsl:param name="pathToMissing"/>
        <xsl:param name="pathToStub"/>
        <xsl:choose>
            <xsl:when test="$imgTest = $empty">
                <xsl:choose>
                    <xsl:when test="$pathToMissing eq 'missing'">
                        <xsl:value-of select="$imgX"/>
                    </xsl:when>
                    <xsl:when test="$pathToStub eq 'yes'">
                        <xsl:value-of select="$stubVis"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$imgTest"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="idno"/>
        <xd:param name="gatheringNo"/>
        <xd:param name="relativePath"/>
    </xd:doc>
    <xsl:template name="SVGobject">
        <xsl:param name="idno"/>
        <xsl:param name="gatheringNo"/>
        <xsl:param name="relativePath"/>
        <xsl:variable name="SVGfilename" select="concat($idno, '-', $gatheringNo, '.svg')"/>
        <div class="bif">
            <!-- INSERT SVG REF HERE -->
            <!-- EXAMPLE OF FINISHED CODE THAT WORKS WITH JS SCRIPT
                                    <object data-current-id="q2-3-14_leaf" class="svg" data="../SVG/id-OthmerMS8/id-OthmerMS8-2.svg" type="image/svg+xml">file not found</object>
                                    -->
            <object>
                <xsl:attribute name="data-current-id">
                    <xsl:value-of select="@folioID"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>svg</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data">
                    <!-- Path relative to the HTML file -->
                    <xsl:value-of select="concat($relativePath, $SVGfilename)"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:text>image/svg+xml</xsl:text>
                </xsl:attribute>
                <xsl:text>Error: SVG file not found</xsl:text>
            </object>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="leftFolFileName"/>
        <xd:param name="rightFolFileName"/>
        <xd:param name="insideLeftImg"/>
        <xd:param name="insideLeftFolNo"/>
        <xd:param name="insideRightImg"/>
        <xd:param name="insideRightFolNo"/>
    </xd:doc>
    <xsl:template name="img1">
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="leftFolFileName"/>
        <xsl:param name="rightFolFileName"/>
        <xsl:param name="insideLeftImg"/>
        <xsl:param name="insideLeftFolNo"/>
        <xsl:param name="insideRightImg"/>
        <xsl:param name="insideRightFolNo"/>
        <div class="img1">
            <a class="fancybox fancybox.iframe" rel="set{@n}"
                title="(Quire {$gatheringNo}, Unit {$leftFol}.{$rightFol}, inside)"
                href="../units/{$leftFolFileName}_{$rightFolFileName}_i.html">
                <xsl:choose>
                    <xsl:when test="contains($insideLeftImg, '.')">
                        <img height="225" src="{$insideLeftImg}" alt="{$insideLeftFolNo}"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="contains($insideRightImg, '.')">
                        <img height="225" src="{$insideRightImg}" alt="{$insideRightFolNo}"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </a>
            <br/>
            <xsl:value-of select="$insideLeftFolNo"/>
            <xsl:if test="contains($insideRightImg, '.') and contains($insideLeftImg, '.')">
                <span class="spacer">
                    <xsl:text> </xsl:text>
                </span>
            </xsl:if>
            <xsl:value-of select="$insideRightFolNo"/>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="gatheringNo"/>
        <xd:param name="leftFol"/>
        <xd:param name="rightFol"/>
        <xd:param name="leftFolFileName"/>
        <xd:param name="rightFolFileName"/>
        <xd:param name="outsideLeftImg"/>
        <xd:param name="outsideLeftFolNo"/>
        <xd:param name="outsideRightImg"/>
        <xd:param name="outsideRightFolNo"/>
    </xd:doc>
    <xsl:template name="img2">
        <xsl:param name="gatheringNo"/>
        <xsl:param name="leftFol"/>
        <xsl:param name="rightFol"/>
        <xsl:param name="leftFolFileName"/>
        <xsl:param name="rightFolFileName"/>
        <xsl:param name="outsideLeftImg"/>
        <xsl:param name="outsideLeftFolNo"/>
        <xsl:param name="outsideRightImg"/>
        <xsl:param name="outsideRightFolNo"/>
        <div class="img2">
            <a class="fancybox fancybox.iframe" rel="set{@n}"
                title="(Quire {$gatheringNo}, Unit {$leftFol}.{$rightFol}, outside)"
                href="../units/{$leftFolFileName}_{$rightFolFileName}_o.html">
                <xsl:choose>
                    <xsl:when test="contains($outsideLeftImg, '.')">
                        <img height="225" src="{$outsideLeftImg}" alt="{$outsideLeftFolNo}"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="contains($outsideRightImg, '.')">
                        <img height="225" src="{$outsideRightImg}" alt="{$outsideRightFolNo}"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </a>
            <br/>
            <xsl:value-of select="$outsideLeftFolNo"/>
            <xsl:if test="contains($outsideLeftImg, '.') and contains($outsideRightImg, '.')">
                <span class="spacer">
                    <xsl:text> </xsl:text>
                </span>
            </xsl:if>
            <xsl:value-of select="$outsideRightFolNo"/>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Top division</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="divTop">
        <!-- this div is the same for all quires -->
        <div id="divtop">
            <span class="topheader">
                <a href="http://www.library.upenn.edu" target="_blank">
                    <img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/pennlogo.gif"
                        width="28" height="27" alt="UPenn"/>
                </a>
                <xsl:text>Generated using the </xsl:text>
                <a href="http://www.schoenberginstitute.org" target="blank">
                    <xsl:text>Schoenberg Institute for Manuscript Studies</xsl:text>
                </a>
                <a href="https://github.com/leoba/VisColl" target="blank">
                    <xsl:text> Collation Modeller</xsl:text>
                </a>
            </span>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Record date and time of transformation</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="DateTimeTransformationNote">
        <!-- Record date and time of transformation -->
        <xsl:comment>
                    <xsl:text>HTML file generated on: </xsl:text>
                    <xsl:value-of select="format-dateTime(current-dateTime(), '[D] [MNn] [Y] at [H]:[m]:[s]')"/>
                    <xsl:text> using </xsl:text>
                    <xsl:value-of select="system-property('xsl:product-name')"/>
                    <xsl:text> version </xsl:text>
                    <xsl:value-of select="system-property('xsl:product-version')"/>
                </xsl:comment>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p> HTML <head/> information </xd:p>
        </xd:desc>
        <xd:param name="gatheringNo"/>
        <xd:param name="titleText"/>
        <xd:param name="shelfmark"/>
        <xd:param name="titleText2"/>
    </xd:doc>
    <xsl:template name="htmlHead">
        <xsl:param name="gatheringNo"/>
        <xsl:param name="titleText"/>
        <xsl:param name="titleText2"/>
        <xsl:param name="shelfmark"/>
        <head>
            <title>
                <xsl:value-of select="$titleText2"/>
            </title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <meta name="description" content="{$titleText}"/>
            <meta name="keywords" content="HTML,CSS,XML,SVG,JavaScript"/>
            <meta name="keywords" content="collation, gathering structure"/>
            <meta name="source" content="{$shelfmark}"/>
            <meta name="creator" content="VisColl 2.0"/>
            <meta name="software" content="https://github.com/leoba/VisColl"/>
            <meta name="date"
                content="{format-dateTime(current-dateTime(), '[D] [MNn] [Y] at [H]:[m]:[s]')}"/>
            <meta name="rights" content="CC BY 3.0"/>
            <!-- Add jQuery library -->
            <script src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/lib/jquery-1.10.1.min.js"/>
            <!-- Add fancyBox main JS and CSS files -->
            <script src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/jquery.fancybox.js?v=2.1.5"/>
            <script src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/iframescript.js"/>
            <script src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/querys.js"/>
            <script src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/collation.js"/>
            <link rel="stylesheet" type="text/css"
                href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/jquery.fancybox.css?v=2.1.5"
                media="screen"/>
            <link rel="stylesheet" type="text/css"
                href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/jquery.fancybox.css"/>
            <link rel="stylesheet" type="text/css"
                href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/collation.css"/>
            <style><![CDATA[
                .svg {
                    width: 100%;
                    height: 100%;
                    align-self: center;
                }
                
                .bif {
                    display: flex;
                    align-items: center;
                }]]>
                        </style>
        </head>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template containing the javascript code to be inserted to highlight the current
                leaf in the svg diagrams.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="js-highlight">
        <script type="text/javascript"><![CDATA[
        // Find all html object element for the SVG files
        const svgObjects = document.querySelectorAll("object");
        // Iterate code for each SVG object
        for (let i = 0; i < svgObjects.length; i++) {
            // wait for each SVG object to load
            svgObjects[i].addEventListener("load", function () {
                // get data-attribute value of the SVG object in question
                var currentID = this.getAttribute("data-current-id");
                // If data-attribute of SVG object is equal to the leaf path class value, then assign "current" class
                const doc = this.contentDocument.querySelectorAll("g." + currentID);
                // capture both arcs and lines of the current leaf
                for (let i = 0; i < doc.length; i++) {
                    // change the class to current for highlight
                    doc[i].classList = "leaf current";
                };
            });
        };//]]>
        </script>
    </xsl:template>

</xsl:stylesheet>
