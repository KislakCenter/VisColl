<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://schoenberginstitute.org/schema/collation" exclude-result-prefixes="xs"
    version="2.0">


    <xsl:template match="/">
        <xsl:for-each select="collection(iri-to-uri('../../../BiblioPhilly/VisColl/collationmodels/?select=*.xml;recurse=yes'))">
            <xsl:variable name="fileName-1" select="tokenize(replace(document-uri(.), '.xml', ''), '/')[position() = last()]"/>
            <xsl:variable name="fileName" select="replace(replace($fileName-1,'\(',''),'\)','')"/>
            <!--<xsl:if test="starts-with($fileName,'Lewis')">-->
                <!--<xsl:variable name="part1" select="lower-case(tokenize($fileName,'_')[position() = 1])"/>-->
                <!--<xsl:variable name="part3" select="format-number(number(tokenize($fileName,'_')[position() = 3]),'000')"/>-->
            <xsl:variable name="msdesc" select="concat($fileName,'_TEI.xml')"/>
            <xsl:variable name="url" select="//url"/>
            <xsl:variable name="title" select="//title"/>
            <xsl:variable name="shelfmark" select="//shelfmark"/>
            <xsl:variable name="teiRoot" select="string(concat('TEI/',$msdesc))"/>
            <xsl:variable name="date" select="document($teiRoot)//tei:origin/tei:p"/>
            <xsl:variable name="origPlace" select="document($teiRoot)//tei:origPlace"/>
            <xsl:variable name="direction">
                <xsl:choose>
                    <xsl:when test="document($teiRoot)//tei:textLang[@mainLang='heb']">r-l</xsl:when>
                    <xsl:otherwise>l-r</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:result-document href="{concat('new-models/',$fileName,'.xml')}">
                <xsl:processing-instruction name="xml-model">href="../data/schemas/viscoll-datamodel2.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
                <viscoll>
                    <manuscript>
                        <url><xsl:value-of select="$url"/></url>
                        <title><xsl:value-of select="$title"/></title>
                        <shelfmark><xsl:value-of select="$shelfmark"/></shelfmark>
                        <xsl:if test="$date != ''"><date><xsl:value-of select="$date"/></date></xsl:if>
                        <xsl:if test="$origPlace != ''"><origPlace><xsl:value-of select="$origPlace"/></origPlace></xsl:if>
                        <direction val="{$direction}"/>
                    
                    <quires>
                        <xsl:for-each select="//quire">
                            <xsl:variable name="qNo" select="@n"/>
                            <xsl:variable name="qID" select="concat('id-',$fileName,'-q-',$qNo)"/>
                            <quire xml:id="{$qID}" n="{$qNo}"><xsl:value-of select="$qNo"/></quire></xsl:for-each>
                    </quires>
                    
                    <xsl:for-each select="//leaf">
                        <xsl:choose>
                            <xsl:when test="@n = ''"/>
                            <xsl:otherwise>
                                <xsl:variable name="leafNo" select="@n"/>
                                <xsl:variable name="positionNo">
                                    <xsl:value-of select="count(preceding-sibling::leaf[@mode != 'false']) +1"/>
                                </xsl:variable>
                                <xsl:variable name="mode" select="@mode"/>
                                <xsl:variable name="single" select="@single"/>
                                <xsl:variable name="folio_number" select="@folio_number"/>
                                <xsl:variable name="opposite" select="@opposite"/>
                                <xsl:variable name="conjoin" select="@conjoin"/>
                                <xsl:variable name="quire" select="parent::quire/@n"/>
                                <xsl:variable name="leafID" select="concat('id-',$fileName,'-',$quire,'-',$positionNo)"/>
                                <xsl:choose><xsl:when test="$leafNo = ''"></xsl:when><xsl:otherwise><leaf xml:id="{$leafID}">
                                    <xsl:choose>
                                        <xsl:when test="$mode = 'missing'"><mode certainty="1" val="missing"/></xsl:when>
                                        <xsl:otherwise><folioNumber certainty="1" val="{$folio_number}"><xsl:value-of select="$folio_number"/></folioNumber>
                                            <mode certainty="1" val="{$mode}"/></xsl:otherwise>
                                    </xsl:choose>
                                    
                                    <xsl:element name="q">
                                        <xsl:attribute name="target" select="concat('#id-',$fileName,'-q-',$quire)"/>
                                        <xsl:attribute name="leafno" select="$leafNo"/>
                                        <xsl:attribute name="position" select="$positionNo"/>
                                        <xsl:attribute name="n" select="$quire"/>
                                        <xsl:choose>
                                            <xsl:when test="@single='true'"/>
                                            <xsl:otherwise><conjoin certainty="1" target="{concat('#id-',$fileName,'-',$quire,'-',$conjoin)}"/></xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                    
                                    <xsl:choose>
                                        <xsl:when test="matches($single,'false')"/>
                                        <xsl:when test="matches($single,'true')"><single val="yes"/></xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                    
                                    
                                    
                                </leaf></xsl:otherwise></xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:for-each>
                    </manuscript>
                    
                    
                    
                    
                </viscoll>
            </xsl:result-document><!--</xsl:if>-->
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
