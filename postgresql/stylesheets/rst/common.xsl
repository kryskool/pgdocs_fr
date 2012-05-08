<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <!-- old function keep here -->
    <xsl:template name="title-markup">
        <!-- Recursive loop to generate = markup under title -->
        <xsl:param name="title-length"/>
        <xsl:text>=</xsl:text>
        <xsl:variable name="length-minus-one" select="$title-length - 1"/>
        <xsl:if test="$length-minus-one &gt; 0">
            <xsl:call-template name="title-markup">
                <xsl:with-param name="title-length" select="$length-minus-one"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ****************************************************************** -->
    <!-- ** Formatage des titre au foramt RST ***************************** -->
    <!-- ****************************************************************** -->
    <xsl:template name="repeat">
        <xsl:param name="count"/>
        <xsl:param name="char"/>
        <xsl:if test="$count > 0">
            <xsl:value-of select="$char"/>
            <xsl:call-template name="repeat">
                <xsl:with-param name="count" select="$count - 1"/>
                <xsl:with-param name="char" select="$char"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ****************************************************************** -->
    <!-- ** Fonction pour supprimer les espaces inutiles ****************** -->
    <!-- ****************************************************************** -->
    <xsl:template name="strip-whitespace">
        <!-- Assumption is that $text-to-strip will be a text() node --> 
        <xsl:param name="text-to-strip" select="."/>
        <!-- By default, don't strip any whitespace -->
        <xsl:param name="leading-whitespace"/>
        <xsl:param name="trailing-whitespace"/>
        <xsl:choose>
            <xsl:when test="($leading-whitespace = 'strip') and ($trailing-whitespace = 'strip')">
                <xsl:value-of select="replace(replace(., '^\s+', '', 'm'), '\s+$', '', 'm')"/>
            </xsl:when>
            <xsl:when test="$leading-whitespace = 'strip'">
                <xsl:value-of select="replace(., '^\s+', '', 'm')"/>
            </xsl:when>
            <xsl:when test="$trailing-whitespace = 'strip'">
                <xsl:value-of select="replace(., '\s+$', '', 'm')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- ****************************************************************** -->
    <!-- ** Footnote ****************************************************** -->
    <!-- ****************************************************************** -->
    <xsl:template match="footnote">
        <xsl:text>.. [#]</xsl:text>
        <xsl:apply-templates/>
        <xsl:text></xsl:text>
    </xsl:template>

</xsl:stylesheet>
