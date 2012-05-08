<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

<!-- ********************************************************************** -->
<!-- ** Sect 1 ************************************************************ -->
<!-- ********************************************************************** -->
<xsl:template match="sect1">
<xsl:variable name="title-text" select="normalize-space(title)"/>
<xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
</xsl:if>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="title"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:call-template name="repeat">
    <xsl:with-param name="count" select="string-length($title-text)"/>
    <xsl:with-param name="char" select="'-'"/>
</xsl:call-template>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="*[not(self::title)]"/>
</xsl:template>

<!-- ********************************************************************** -->
<!-- ** Sect 2************************************************************* -->
<!-- ********************************************************************** -->
<xsl:template match="sect2">
<xsl:variable name="title-text" select="normalize-space(title)"/>
<xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
</xsl:if>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="title"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:call-template name="repeat">
    <xsl:with-param name="count" select="string-length($title-text)"/>
    <xsl:with-param name="char" select="'^'"/>
</xsl:call-template>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="*[not(self::title)]"/>
</xsl:template>

<!-- ********************************************************************** -->
<!-- ** Sect 3************************************************************* -->
<!-- ********************************************************************** -->
<xsl:template match="sect3">
<xsl:variable name="title-text" select="normalize-space(title)"/>
<xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
</xsl:if>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="title"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:call-template name="repeat">
    <xsl:with-param name="count" select="string-length($title-text)"/>
    <xsl:with-param name="char" select="'&quot;'"/>
</xsl:call-template>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="*[not(self::title)]"/>
</xsl:template>

<xsl:template match="section">
<xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
</xsl:if>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:sequence select="string-join (('&#10;&#10;', for $i in (1 to count (ancestor::section) + 3) return '='),'')"/>
<xsl:apply-templates select="title"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:apply-templates select="*[not(self::title)]"/>
</xsl:template>

</xsl:stylesheet>
