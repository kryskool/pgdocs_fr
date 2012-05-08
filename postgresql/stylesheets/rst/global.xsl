<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <!-- definition des paramètres généraux -->
    <xsl:output method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="chunk-output">false</xsl:param>
    <xsl:param name="bookinfo-doc-name">book-docinfo.xml</xsl:param>

    <xsl:preserve-space elements="*"/>
    <xsl:strip-space elements="table row entry tgroup thead"/>

    <!-- parcours de la doc en XML -->
    <xsl:template match="/">
        <xsl:if test="not(/book/title)">
            <xsl:apply-templates select="//bookinfo/title"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$chunk-output != 'false'">
                <xsl:apply-templates select="*" mode="chunk"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="chapter|appendix|preface|colophon|dedication|glossary|bibliography" mode="chunk">
        <xsl:variable name="doc-name">
            <xsl:choose>
                <xsl:when test="self::chapter">
                    <xsl:text>ch</xsl:text>
                    <xsl:number count="chapter" level="any" format="01"/>
                </xsl:when>
                <xsl:when test="self::appendix">
                    <xsl:text>app</xsl:text>
                    <xsl:number count="appendix" level="any" format="a"/>
                </xsl:when>
                <xsl:when test="self::preface">
                    <xsl:text>pr</xsl:text>
                    <xsl:number count="preface" level="any" format="01"/>
                </xsl:when>
                <xsl:when test="self::colophon">
                    <xsl:text>colo</xsl:text>
                    <xsl:if test="count(//colophon) &gt; 1">
                        <xsl:number count="colo" level="any" format="01"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="self::dedication">
                    <xsl:text>dedication</xsl:text>
                    <xsl:if test="count(//dedication) &gt; 1">
                        <xsl:number count="dedication" level="any" format="01"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="self::glossary">
                    <xsl:text>glossary</xsl:text>
                    <xsl:if test="count(//glossary) &gt; 1">
                        <xsl:number count="glossary" level="any" format="01"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="self::bibliography">
                    <xsl:text>bibliography</xsl:text>
                    <xsl:if test="count(//bibliography) &gt; 1">
                        <xsl:number count="bibliography" level="any" format="01"/>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            <xsl:text>.rst</xsl:text>
        </xsl:variable>
        <xsl:text xml:space="preserve">&#10;</xsl:text>
        <xsl:text xml:space="preserve">&#10;</xsl:text>
        <xsl:text>    </xsl:text>
        <xsl:value-of select="$doc-name"/>
        <xsl:text>[]</xsl:text>
        <!-- Creation de chaque fichier utile -->
        <xsl:result-document href="{$doc-name}">
            <xsl:apply-templates select="." mode="#default"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:include href="common.xsl"/>
    <xsl:include href="chapter.xml"/>
    <xsl:include href="section.xsl"/>
    <xsl:include href="table.xsl"/>

</xsl:stylesheet>
