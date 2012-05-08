<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:template match="table|informaltable">
        <xsl:if test="@id">
            <xsl:text xml:space="preserve">&#10;</xsl:text>
            <xsl:text>.. _</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:if test="title">
            .<xsl:apply-templates select="title"/>
        </xsl:if>
        <xsl:if test="descendant::thead">
            <xsl:text>.. csv-table::</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="descendant::row"/>
        |===============
        <xsl:text xml:space="preserve">&#10;</xsl:text>
        <xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="sidebar">
        <xsl:if test="@id">[[<xsl:value-of select="@id"/>]]</xsl:if>
        .<xsl:apply-templates select="title"/>
        ****
        <xsl:apply-templates select="*[not(title)]"/>
        ****
        <xsl:text xml:space="preserve">&#10;</xsl:text>
        <xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="row">
        <xsl:for-each select="entry">
            <xsl:text>|</xsl:text>
            <xsl:apply-templates/>
        </xsl:for-each>
        <xsl:if test="not (entry/para)">
            <xsl:text xml:space="preserve">&#10;</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
