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
                <p>Formula 1 (shows singletons):<br/> 
                    <xsl:for-each select="quire">
                        <!-- to be in the format 1(8, -4, +3) showing singletons-->
                        <xsl:variable name="quire-no" select="@n"/>
                        <xsl:variable name="no-leaves">
                            <xsl:choose>
                                <xsl:when test="child::leaf[last()]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()]/@n"/></xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="child::leaf[last()-1]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-1]/@n"/></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="child::leaf[last()-2]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-2]/@n"/></xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original and @single=true, to add : -->
                        <xsl:choose>
                            <xsl:when test="child::leaf[not(@mode='original')] or child::leaf[@single='true']">: </xsl:when>
                        </xsl:choose>
                        <xsl:for-each select="child::leaf">
                            <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="@mode='added'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                            <xsl:if test="@single='true'"><xsl:text> </xsl:text><xsl:value-of select="@n"/><sup>s</sup></xsl:if>
                            <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                        </xsl:for-each>
                        <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                    </xsl:for-each>
                </p>
                
                <p>Formula 2 (equates added singletons and original singletons):<br/> 
                    <xsl:for-each select="quire">
                        <!-- to be in the format 1(8, -4, +3) -->
                        <xsl:variable name="quire-no" select="@n"/>
                        <xsl:variable name="no-leaves">
                            <xsl:choose>
                                <xsl:when test="child::leaf[last()]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()]/@n"/></xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="child::leaf[last()-1]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-1]/@n"/></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="child::leaf[last()-2]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-2]/@n"/></xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original and @single=true, to add : -->
                        <xsl:choose>
                            <xsl:when test="child::leaf[@mode='missing'][@mode='added'][@mode='replaced']">: </xsl:when>
                        </xsl:choose>
                        <xsl:for-each select="child::leaf">
                            <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="@mode='added'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                            <xsl:if test="@single='true'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                        </xsl:for-each>
                        <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                    </xsl:for-each>
                </p>                
                
                <p>Formula 3 (does not show singletons, indicates folio numbers around missing and added leaves):<br/> 
                    <xsl:for-each select="quire">
                        <!-- to be in the format 1(8, leaf missing between fol. X and fol. Y, leaf added after fol. X) -->
                        <xsl:variable name="quire-no" select="@n"/>
                        <xsl:variable name="no-leaves">
                            <xsl:choose>
                                <xsl:when test="child::leaf[last()]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()]/@n"/></xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="child::leaf[last()-1]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-1]/@n"/></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="child::leaf[last()-2]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-2]/@n"/></xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original and @single=true, to add : -->
                        <xsl:choose>
                            <xsl:when test="child::leaf[@mode='missing'] or child::leaf[@mode='added'] or child::leaf[@mode='replaced']">: </xsl:when>
                        </xsl:choose>
                        <xsl:for-each select="child::leaf">
                            <!--<xsl:if test="@mode='missing'">
                                <xsl:text> </xsl:text>
                                <xsl:choose>
                                <xsl:when test="preceding-sibling::leaf">, leaf missing after fol. <xsl:value-of
                                    select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:otherwise>, first leaf is missing</xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>-->
                            <xsl:if test="@mode='missing'">
                                <xsl:text> </xsl:text>
                                <xsl:choose>
                                    <xsl:when test="preceding-sibling::leaf and following-sibling::leaf[1][@mode='missing'] and following-sibling::leaf[2][@mode='missing'] and following-sibling::leaf[3][@mode='missing'] and following-sibling::leaf[4][@mode='missing'] and following-sibling::leaf[5][@mode='missing']"> six leaves missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:when test="preceding-sibling::leaf and following-sibling::leaf[1][@mode='missing'] and following-sibling::leaf[2][@mode='missing'] and following-sibling::leaf[3][@mode='missing'] and following-sibling::leaf[4][@mode='missing']"> five leaves missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:when test="preceding-sibling::leaf and following-sibling::leaf[1][@mode='missing'] and following-sibling::leaf[2][@mode='missing'] and following-sibling::leaf[3][@mode='missing']"> four leaves missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:when test="preceding-sibling::leaf and following-sibling::leaf[1][@mode='missing'] and following-sibling::leaf[2][@mode='missing']"> three leaves missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:when test="preceding-sibling::leaf and following-sibling::leaf[1][@mode='missing']"> two leaves missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:when test="preceding-sibling::leaf[@mode='missing']"/>
                                    <xsl:when test="preceding-sibling::leaf[1] and following-sibling::leaf[1][not(@mode='missing')]"> leaf missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:when test="position() = last()"> leaf missing after fol. <xsl:value-of
                                        select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:otherwise> first leaf is missing</xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="@mode='added'">
                                <xsl:text> </xsl:text>
                                <xsl:choose>
                                <xsl:when test="preceding-sibling::leaf"> leaf added after fol. <xsl:value-of
                                    select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when><xsl:otherwise> first leaf is added</xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="@mode='replaced'">
                                <xsl:text> </xsl:text>
                                <xsl:choose>
                                    <xsl:when test="preceding-sibling::leaf"> leaf replaced after fol. <xsl:value-of
                                select="preceding-sibling::leaf[1]/@folio_number"/></xsl:when>
                                    <xsl:otherwise> first leaf is replaced</xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                        </xsl:for-each>
                        <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                    </xsl:for-each>
                        <!--<xsl:variable name="quire-no" select="@n"/>
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
                    </xsl:for-each>-->
                </p>

                <p>Formula 4 (equates added singletons and original singletons, collapses like-numbered quires):<br/>
                    <xsl:for-each select="quire">
                        <!-- to be in the format 1(8, -4, +3) -->
                        <xsl:variable name="quire-no" select="@n"/>
                        <xsl:variable name="no-leaves">
                            <xsl:choose>
                                <xsl:when test="child::leaf[last()]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()]/@n"/></xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="child::leaf[last()-1]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-1]/@n"/></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="child::leaf[last()-2]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-2]/@n"/></xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="child::leaf[last()-3]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-3]/@n"/></xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:choose>
                                                                <xsl:when test="child::leaf[last()-4]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-4]/@n"/></xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:choose>
                                                                        <xsl:when test="child::leaf[last()-5]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-5]/@n"/></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:choose>
                                                                                <xsl:when test="child::leaf[last()-6]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-6]/@n"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="child::leaf[last()-7]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-7]/@n"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="child::leaf[last()-8]/string-length(@n)!=0"><xsl:value-of select="child::leaf[last()-8]/@n"/></xsl:when>
                                                                                            </xsl:choose>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="nextQuire-no-leaves">
                            <xsl:choose>
                                <xsl:when test="following-sibling::quire[1]/child::leaf[last()]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()]/@n"/></xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="following-sibling::quire[1]/child::leaf[last()-1]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-1]/@n"/></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="following-sibling::quire[1]/child::leaf[last()-2]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-2]/@n"/></xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="following-sibling::quire[1]/child::leaf[last()-3]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-3]/@n"/></xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:choose>
                                                                <xsl:when test="following-sibling::quire[1]/child::leaf[last()-4]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-4]/@n"/></xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:choose>
                                                                        <xsl:when test="following-sibling::quire[1]/child::leaf[last()-5]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-5]/@n"/></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:choose>
                                                                                <xsl:when test="following-sibling::quire[1]/child::leaf[last()-6]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-6]/@n"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="following-sibling::quire[1]/child::leaf[last()-7]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-7]/@n"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="following-sibling::quire[1]/child::leaf[last()-8]/string-length(@n)!=0"><xsl:value-of select="following-sibling::quire[1]/child::leaf[last()-8]/@n"/></xsl:when>
                                                                                            </xsl:choose>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="prevQuire-no-leaves">
                            <xsl:choose>
                                <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()]/@n"/></xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-1]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-1]/@n"/></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-2]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-2]/@n"/></xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-3]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-3]/@n"/></xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:choose>
                                                                <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-4]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-4]/@n"/></xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:choose>
                                                                        <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-5]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-5]/@n"/></xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:choose>
                                                                                <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-6]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-6]/@n"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-7]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-7]/@n"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="preceding-sibling::quire[1]/child::leaf[last()-8]/string-length(@n)!=0"><xsl:value-of select="preceding-sibling::quire[1]/child::leaf[last()-8]/@n"/></xsl:when>
                                                                                            </xsl:choose>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            
                            <xsl:when test="leaf[@mode='missing'] or leaf[@mode='added'] or leaf[@mode='replaced'] or leaf[@single='true']">
                                <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original, to add , -->
                                <xsl:choose>
                                    <xsl:when test="child::leaf[@mode='missing']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='added'] or child::leaf[@single='true']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='replaced']">, </xsl:when>
                                </xsl:choose>
                                <xsl:for-each select="child::leaf">
                                    <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='added' or @single='true'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                                    <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                                </xsl:for-each>
                                <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                                <!--</xsl:when>-->
                            </xsl:when>
                            
                            <xsl:when test="following-sibling::quire[1]/leaf[@mode='missing'] or following-sibling::quire[1]/leaf[@mode='added'] or following-sibling::quire[1]/leaf[@mode='replaced'] or following-sibling::quire[1]/leaf[@single='true']">
                                <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original, to add , -->
                                <xsl:choose>
                                    <xsl:when test="child::leaf[@mode='missing']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='added'] or child::leaf[@single='true']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='replaced']">, </xsl:when>
                                </xsl:choose>
                                <xsl:for-each select="child::leaf">
                                    <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='added' or @single='true'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                                    <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                                </xsl:for-each>
                                <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                                <!--</xsl:when>-->
                            </xsl:when>
                            
                            
                            
                            <xsl:when test="$no-leaves != $prevQuire-no-leaves and $no-leaves = $nextQuire-no-leaves"><xsl:value-of select="$quire-no"/>-</xsl:when>
                            
                            <xsl:when test="($no-leaves = $prevQuire-no-leaves and $no-leaves = $nextQuire-no-leaves) and (following-sibling::quire[1]/leaf[@mode='missing'] or following-sibling::quire[1]/leaf[@mode='added'] or following-sibling::quire[1]/leaf[@mode='replaced'] or following-sibling::quire[1]/leaf[@single='true'])">
                                <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original, to add , -->
                                <xsl:choose>
                                    <xsl:when test="child::leaf[@mode='missing']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='added'] or child::leaf[@single='true']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='replaced']">, </xsl:when>
                                </xsl:choose>
                                <xsl:for-each select="child::leaf">
                                    <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='added' or @single='true'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                                    <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                                </xsl:for-each>
                                <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                                <!--</xsl:when>-->
                            </xsl:when>
                            
                            <xsl:when test="leaf[@mode='missing'] or leaf[@mode='added'] or leaf[@mode='replaced'] or leaf[@single='true']">
                                <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original, to add , -->
                                <xsl:choose>
                                    <xsl:when test="child::leaf[@mode='missing']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='added'] or child::leaf[@single='true']">, </xsl:when>
                                    <xsl:when test="child::leaf[@mode='replaced']">, </xsl:when>
                                </xsl:choose>
                                <xsl:for-each select="child::leaf">
                                    <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='added' or @single='true'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                                    <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                                    <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                                </xsl:for-each>
                                <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                                <!--</xsl:when>-->
                            </xsl:when>
                            
                            <xsl:when test="($no-leaves = $prevQuire-no-leaves and $no-leaves = $nextQuire-no-leaves) and (preceding-sibling::quire[1]/leaf[@mode='missing'] or preceding-sibling::quire[1]/leaf[@mode='added'] or preceding-sibling::quire[1]/leaf[@mode='replaced'] or preceding-sibling::quire[1]/leaf[@single='true'])"><xsl:value-of select="$quire-no"/>-</xsl:when>
                            <xsl:when test="$no-leaves = $prevQuire-no-leaves and $no-leaves = $nextQuire-no-leaves"/>
                            <xsl:otherwise>
                                <xsl:value-of select="$quire-no"/> (<xsl:value-of select="$no-leaves"/><!-- add xsl:choose to see if @mode != original, to add , -->
                        <xsl:choose>
                            <xsl:when test="child::leaf[@mode='missing']">, </xsl:when>
                            <xsl:when test="child::leaf[@mode='added'] or child::leaf[@single='true']">, </xsl:when>
                            <xsl:when test="child::leaf[@mode='replaced']">, </xsl:when>
                        </xsl:choose>
                        <xsl:for-each select="child::leaf">
                            <xsl:if test="@mode='missing'"><xsl:text> </xsl:text>-<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="@mode='added' or @single='true'"><xsl:text> </xsl:text>+<xsl:value-of select="@n"/></xsl:if>
                            <xsl:if test="@mode='replaced'"><xsl:text> </xsl:text>leaf in position <xsl:value-of select="@n"/> has been replaced</xsl:if>
                            <xsl:if test="not(following-sibling::leaf)">)</xsl:if>
                        </xsl:for-each>
                        <xsl:choose><xsl:when test="position() != last()">,<xsl:text> </xsl:text></xsl:when></xsl:choose>
                            <!--</xsl:when>-->
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </p>                
                
            </body>
        </html></xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
