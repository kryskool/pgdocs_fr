<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">



<xsl:template match="//comment()">
.. note::
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:copy/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>

<xsl:template match="book/title" mode="#all">
<xsl:variable name="title-text" select="normalize-space(.)"/>
<xsl:value-of select="$title-text"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:call-template name="repeat">
    <xsl:with-param name="count" select="string-length($title-text)"/>
    <xsl:with-param name="char" select="'='"/>
</xsl:call-template>
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>




<xsl:template match="bookinfo/title">
<!-- Process bookinfo/title if it exists, and there is no book/title, which gets primacy -->
<xsl:if test="not(/book/title)">
<xsl:variable name="title-text" select="normalize-space(.)"/>
<xsl:value-of select="$title-text"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:call-template name="repeat">
    <xsl:with-param name="count" select="string-length($title-text)"/>
    <xsl:with-param name="char" select="'='"/>
</xsl:call-template>
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="indexterm" />

<xsl:template match="para/text()">
    <xsl:sequence select="replace(replace(., '\n\s+', ' ', 'm'), 'C\+\+', '\$\$C++\$\$', 'm')"/>
</xsl:template>

<xsl:template match="phrase/text()"><xsl:text/><xsl:sequence select="replace(., '\n\s+', ' ', 'm')"/><xsl:text/></xsl:template>

<xsl:template match="ulink/text()">
    <xsl:sequence select="replace(., '\n\s+', ' ', 'm')"/>
</xsl:template>

<xsl:template match="title/text()">
    <xsl:sequence select="replace(., '\n\s+', ' ', 'm')"/>
</xsl:template>

<!-- Strip leading whitespace from first text node in <term>, if it does not have preceding element siblings --> 
<xsl:template match="term[count(element()) != 0]/text()[1][not(preceding-sibling::element())]">
    <xsl:call-template name="strip-whitespace">
        <xsl:with-param name="text-to-strip" select="."/>
        <xsl:with-param name="leading-whitespace" select="'strip'"/>
    </xsl:call-template>
</xsl:template>

<!-- Strip trailing whitespace from last text node in <term>, if it does not have following element siblings --> 
<xsl:template match="term[count(element()) != 0]/text()[not(position() = 1)][last()][not(following-sibling::element())]">
    <xsl:call-template name="strip-whitespace">
        <xsl:with-param name="text-to-strip" select="."/>
        <xsl:with-param name="trailing-whitespace" select="'strip'"/>
    </xsl:call-template>
</xsl:template>

<!-- If term has just one text node (no element children), just normalize space in it -->
<xsl:template match="term[count(element()) = 0]/text()">
    <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- Text nodes in <term> that are between elements that contain only whitespace should be normalized to one space -->
<xsl:template match="term/text()[not(position() = 1)][not(position() = last())][matches(., '^[\s\n]+$', 'm')]">
    <xsl:value-of select="replace(., '^[\s\n]+$', ' ', 'm')"/>
</xsl:template>

<xsl:template match="member/text()">
    <xsl:sequence select="replace(., '^\s+', '', 'm')"/>
</xsl:template>

<!-- Output bookinfo children into book-docinfo.xml -->
<xsl:template match="bookinfo" mode="#all">
    <xsl:result-document href="{$bookinfo-doc-name}">
        <xsl:apply-templates mode="bookinfo-children"/>
    </xsl:result-document>
</xsl:template>

<xsl:template match="bookinfo/*" mode="bookinfo-children">
<xsl:copy-of select="."/>
</xsl:template>



<xsl:template match="para|simpara">
<xsl:if test="@id">
.. _<xsl:value-of select="@id"/>:
</xsl:if>
<xsl:apply-templates select="node()"/>
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>

<xsl:template match="formalpara">
    <xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
<xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:if>

    <!-- Put formalpara <title> in bold (drop any inline formatting) -->
    <xsl:text>**</xsl:text>
    <xsl:value-of select="title"/>
    <xsl:text>** </xsl:text>
    <xsl:apply-templates select="node()[not(self::title)]"/>
    <xsl:text xml:space="preserve">&#10;</xsl:text>
    <xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>

<!-- Same handling for blockquote and epigraph; convert to AsciiDoc quote block -->
<xsl:template match="blockquote|epigraph">
    <xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
<xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="title">.<xsl:apply-templates select="title"/></xsl:if>
    <xsl:text>[quote</xsl:text>
    <xsl:if test="attribution">
        <xsl:text>, </xsl:text>
        <!-- Simple processing of attribution elements, placing a space between each
        and skipping <citetitle>, which is handled separately below -->
            <xsl:for-each select="attribution/text()|attribution//*[not(*)][not(self::citetitle)]">
                <!--Output text as is, except escape commas as &#44; entities for 
                proper AsciiDoc attribute processing -->
                <xsl:value-of select="normalize-space(replace(., ',', '&amp;#44;'))" disable-output-escaping="yes"/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:if>
<xsl:if test="attribution/citetitle">
    <xsl:text>, </xsl:text>
    <xsl:value-of select="attribution/citetitle"/>
</xsl:if>
<xsl:text>]</xsl:text>
____
<xsl:apply-templates select="node()[not(self::title or self::attribution)]"/>
____
<xsl:text xml:space="preserve">&#10;</xsl:text>
<xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:template>

<xsl:template match="entry/para|entry/simpara">
<xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:if>
<xsl:apply-templates select="node()"/>
<xsl:choose>
    <xsl:when test="following-sibling::para|following-sibling::simpara">
        <!-- Two carriage returns if para has following para siblings in the same entry -->
        <xsl:text xml:space="preserve">&#10;</xsl:text>
        <xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="parent::entry[not(following-sibling::entry)]">
        <!-- One carriage return if last para in last entry in row -->
        <xsl:text xml:space="preserve">&#10;</xsl:text>
    </xsl:when>
</xsl:choose>
</xsl:template>


<xsl:template match="footnote/para">
    <!--Special handling for footnote paras to contract whitespace-->
    <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="tip|warning|note|caution|important">
    <xsl:if test="@id">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. _<xsl:value-of select="@id"/>:
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:if>
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. <xsl:value-of select="lower-case(name())"/>::
<xsl:text xml:space="preserve">&#10;</xsl:text>
    <xsl:if test="title">.<xsl:apply-templates select="title"/></xsl:if>
    <xsl:text xml:space="preserve">&#32;&#32;&#32;&#32;</xsl:text>
    <xsl:apply-templates select="node()[not(self::title)]"/>
    <xsl:text xml:space="preserve">&#10;</xsl:text>
    <xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>

                        <xsl:template match="term"><xsl:apply-templates select="node()"/>:: </xsl:template>

                        <xsl:template match="listitem">
                            <xsl:apply-templates select="node()"/>
                        </xsl:template>

                        <xsl:template match="phrase"><xsl:apply-templates /></xsl:template>

                        <xsl:template match="emphasis [@role='bold']">*<xsl:value-of select="." />*</xsl:template>

                        <xsl:template match="filename">_<xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if><xsl:value-of select="normalize-space(replace(., '([\+])', '\\$1', 'm'))" /><xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if>_<xsl:if test="not(following-sibling::node()[1][self::userinput]) and matches(following-sibling::node()[1], '^[a-zA-Z]')"><xsl:text> </xsl:text></xsl:if></xsl:template>

                        <xsl:template match="emphasis">_<xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if><xsl:value-of select="normalize-space(.)" /><xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if>_<xsl:if test="not(following-sibling::node()[1][self::userinput]) and matches(following-sibling::node()[1], '^[a-zA-Z]')"><xsl:text> </xsl:text></xsl:if></xsl:template>

                        <xsl:template match="literal"><xsl:if test="preceding-sibling::node()[1][self::replaceable] or following-sibling::node()[1][self::replaceable] or following-sibling::node()[1][self::emphasis] or substring(following-sibling::node()[1],1,1) = 's' or substring(following-sibling::node()[1],1,1) = '’'">+</xsl:if>+<xsl:if test="contains(., '+')">$$</xsl:if><xsl:value-of select="replace(., '([\[\]\*\^~])', '\\$1', 'm')" /><xsl:if test="contains(., '+')">$$</xsl:if>+<xsl:if test="preceding-sibling::node()[1][self::replaceable] or following-sibling::node()[1][self::replaceable] or following-sibling::node()[1][self::emphasis] or substring(following-sibling::node()[1],1,1) = 's' or substring(following-sibling::node()[1],1,1) = '’'">+</xsl:if></xsl:template>

                        <xsl:template match="userinput">**`<xsl:value-of select="normalize-space(.)" />`**</xsl:template>

                        <xsl:template match="replaceable">_++<xsl:value-of select="normalize-space(.)" />++_</xsl:template>

<!-- unlink est de la forme -->
<!-- `mon lien <http://>`_ -->
<xsl:template match="ulink">
    <xsl:value-of select="'`'" disable-output-escaping="yes"/>
    <xsl:apply-templates/>
    <xsl:text xml:space="preserve">&#32;</xsl:text>
    <xsl:value-of select="'&lt;'" disable-output-escaping="yes"/>
    <xsl:value-of select="@url" /><xsl:value-of select="'&gt;`_'" disable-output-escaping="yes"/>
</xsl:template>

                        <xsl:template match="email"><xsl:value-of select="normalize-space(.)" /></xsl:template>

<!-- référence vers d'autres pages -->
<xsl:template match="xref"><xsl:value-of select="':ref:`'" disable-output-escaping="yes"/><xsl:value-of select="@linkend" /><xsl:value-of select="'`'" disable-output-escaping="yes"/></xsl:template>

                        <xsl:template match="link"><xsl:value-of select="'&lt;&lt;'" disable-output-escaping="yes"/><xsl:value-of select="@linkend" />,<xsl:value-of select="."/><xsl:value-of select="'&gt;&gt;'" disable-output-escaping="yes"/></xsl:template>

                        <xsl:template match="variablelist">
                            <xsl:if test="@id">
                                [[<xsl:value-of select="@id"/>]]
                            </xsl:if>
                            <xsl:for-each select="varlistentry">
                                <xsl:apply-templates select="term,listitem"/>
                            </xsl:for-each>
                        </xsl:template>

                        <xsl:template match="itemizedlist">
                            <xsl:if test="@id">
                                [[<xsl:value-of select="@id"/>]]
                            </xsl:if>
                            <xsl:if test="@spacing">
                                [options="<xsl:value-of select="@spacing"/>"]
                            </xsl:if>
                            <xsl:for-each select="listitem">
                                * <xsl:apply-templates/>
                            </xsl:for-each>
                        </xsl:template>

                        <xsl:template match="orderedlist">
                            <xsl:if test="@id">
                                [[<xsl:value-of select="@id"/>]]
                            </xsl:if>
                            <xsl:if test="@spacing">
                                [options="<xsl:value-of select="@spacing"/>"]
                            </xsl:if>
                            <xsl:for-each select="listitem">
                                . <xsl:apply-templates/>
                            </xsl:for-each>
                        </xsl:template>

                        <xsl:template match="simplelist">
                            <xsl:text xml:space="preserve">&#10;</xsl:text>
                            <xsl:if test="@id">
                                [[<xsl:value-of select="@id"/>]]
                            </xsl:if>
                            <xsl:for-each select="member">
                                <xsl:apply-templates/><xsl:if test="position() &lt; last()"> +
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:text xml:space="preserve">&#10;</xsl:text>
                            <xsl:text xml:space="preserve">&#10;</xsl:text>
                        </xsl:template>

                        <xsl:template match="figure">
                            <xsl:if test="@id">[[<xsl:value-of select="@id"/>]]</xsl:if>
                            .<xsl:apply-templates select="title"/>
                            image::<xsl:value-of select="mediaobject/imageobject[@role='web']/imagedata/@fileref"/>[]
                            <xsl:text xml:space="preserve">&#10;</xsl:text>
                        </xsl:template>

                        <xsl:template match="informalfigure">
                            <xsl:text xml:space="preserve">&#10;</xsl:text>
                            <xsl:if test="@id">[[<xsl:value-of select="@id"/>]]</xsl:if>
                            image::<xsl:value-of select="mediaobject/imageobject[@role='web']/imagedata/@fileref"/>[]
                            <xsl:text xml:space="preserve">&#10;</xsl:text>
                        </xsl:template>

                        <xsl:template match="inlinemediaobject">image:<xsl:value-of select="imageobject[@role='web']/imagedata/@fileref"/>[]</xsl:template>

                        <xsl:template match="example">
                            <xsl:if test="@id">[[<xsl:value-of select="@id"/>]]</xsl:if>
                            <xsl:if test="title">
                                .<xsl:apply-templates select="title"/>
                            </xsl:if>
                            ====<xsl:apply-templates select="programlisting|screen"/>====
                        </xsl:template>

                        <!-- Asciidoc-formatted programlisting|screen (don't contain child elements) -->
<xsl:template match="programlisting|screen">
<xsl:text xml:space="preserve">&#10;</xsl:text>
.. code-block::
<xsl:text xml:space="preserve">&#10;</xsl:text>
    <xsl:apply-templates/>

<xsl:text xml:space="preserve">&#10;</xsl:text>

<xsl:if test="following-sibling::*[1][self::calloutlist]">
    <xsl:call-template name="calloutlist_ad"/>
</xsl:if>
<xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>

                        <!-- This template is called for an asciidoc-formatted calloutlist (not docbook passthrough) -->
                        <xsl:template name="calloutlist_ad">
                            <xsl:if test="@id">
                                [[<xsl:value-of select="@id"/>]]
                            </xsl:if>
                            <xsl:for-each select="callout">
                                &lt;<xsl:value-of select="position()"/>&gt; <xsl:apply-templates/>
                            </xsl:for-each>
                            <xsl:if test="calloutlist">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:template>

                        <!-- Passthrough for code listings that have child elements (inlines) -->
                        <xsl:template match="programlisting[*]|screen[*]">
                            ++++++++++++++++++++++++++++++++++++++
                            <xsl:copy-of select="."/>

                            <!-- Passthrough for related calloutlist -->
                            <xsl:if test="following-sibling::*[1][self::calloutlist]">
                                <xsl:copy-of select="following-sibling::*[1][self::calloutlist]"/>
                            </xsl:if>
                            ++++++++++++++++++++++++++++++++++++++
                        </xsl:template>

                        <!-- Repress callout text from appearing as duplicate text outside of the programlisting passthrough -->
                        <xsl:template match="calloutlist/callout"/>

<!-- Also use passthrough for examples that have code listings with child elements (inlines) -->
<xsl:template match="example[descendant::programlisting[*]]|example[descendant::screen[*]]">
    <xsl:text xml:space="preserve">&#10;</xsl:text>
    <xsl:text>.. code-block::</xsl:text>
    <xsl:text xml:space="preserve">&#10;</xsl:text>
    <xsl:copy-of select="."/>
    <xsl:text xml:space="preserve">&#10;</xsl:text>
</xsl:template>

                        <xsl:template match="co"><xsl:variable name="curr" select="@id"/>&lt;<xsl:value-of select="count(//calloutlist/callout[@arearefs=$curr]/preceding-sibling::callout)+1"/>&gt;</xsl:template>






                    </xsl:stylesheet>

