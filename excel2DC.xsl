<?xml version="1.0" encoding="UTF-8"?>
<!-- instructions:
 if this script adds a namespace for this element in the output file, please remove it.
-->
<!-- DEVELOPMENT:
Change spreadsheet labels such as "contributor@author" to normal marcrelator terms such as Author, Narrator.
Until then, take "contributor" out of all xml files before you process them and capitalize Author, etc.
Submitter (h) becomes "Submitter" in spreasheet
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://elib.hamilton.edu/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:sru_dc="info:srw/schema/1/dc-schema"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="sru_dc oai_dc dc"
    version="1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:param name="delimiter" select="';'"/>

    <xsl:template match="/">

        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/
            http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
            <responseDate>2011-09-20T20:40:57Z</responseDate>
            <request verb="ListRecords" metadataPrefix="oai_dc"
                >http://elib.hamilton.edu/cgi-bin/oai.exe</request>
            <ListRecords>
                <xsl:for-each select="child::node()">
                    <xsl:call-template name="row"/>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>

    <xsl:template name="row">
        <xsl:for-each select="child::node()">
            <xsl:if test="child::node() != ''">
                <record>
                    <header>
                        <identifier>xxx</identifier>
                        <datestamp>2011-09-15</datestamp>
                    </header>
                    <metadata>
                        <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
                            xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

                            <!-- Append field name to field value only when needed to specify something field to 
                            MODS such as a specific authority or displayLabel -->

                            <!-- Do NOT append field name to value -->
                            <xsl:for-each select="Title">
                                <xsl:if test="string-length(normalize-space(text()) > 0)">
                                    <dc:title>
                                        <xsl:value-of select="."/>
                                    </dc:title>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value -->
                            <xsl:for-each select="creator | Creator">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:creator</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="Author | Recipient | Depicted | Narrator | Speaker | Translator">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:contributor</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="DCMIType | Type_Of_Resource | Type_Of_Resource--AAT | Type_of_Resource | TypeAAT ">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:type</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. 
                            They will be looked up in controlled vocaularies. -->
                            <xsl:for-each
                                select="Poetic_Form | Poetic_Form | genre--local | Genre--local | Genre--Local | genre | Genre">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:type</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="format | MIMEType | Format--MIME_Type | Format--MIME_Type | Duration | File_Size--KB | Extent">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:format</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. 
There should only be one value and it should be checked in the $forms CV. -->
                            <xsl:for-each select="Medium">
                                <xsl:if test="string-length() != 0">
                                    <dc:format>
                                        <xsl:value-of select="."/>
                                    </dc:format>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="abstract | Abstract | Table_of_Contents | Table_Of_Contents">
                                <xsl:if test="string-length() != 0">
                                    <dc:description>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/>
                                    </dc:description>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- to be tokenized -->
                            <xsl:for-each select="Techniques--AAT">
                                <xsl:if test="string-length() != 0">
                                    <dc:description>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"
                                        />)</dc:description>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Date_Issued | Date_issued">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                        <xsl:text>|Issued</xsl:text>
                                    </dc:date>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Date_Created | Date_created">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                        <xsl:text>|Created</xsl:text>
                                    </dc:date>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Date_Note">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                    </dc:date>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="language | Language">
                                <xsl:if test="string-length() != 0">
                                    <dc:language>
                                        <xsl:value-of select="."/>
                                    </dc:language>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Spatial_Coverage--LCSH | Geographic_Coverage">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:coverage</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. Values will be looked up in controlled vocabularies. -->
                            <xsl:for-each
                                select="Subject_Heading--LCSH | Subject_Headings--LCSH | tags | Tags | Photo_Subject">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:subject</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Region">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:coverage</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="Source | Inscriptions | Holder_of_Original | Original_Collection | Original_Item_ID | Internal_Notes | Contact | Processing_History | Physical_Location | Evidence_Level--h | Cataloging_Level--h | note | Submitter--h | Donation_information | Publication_History | Publication_history | Poem_Publication_History | Donation_Information | Performance_Location | Performance_location">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:source</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- suppressed until after further testing 2012-07-23, pjm
                            <xsl:for-each select="Submitter h">
                                <xsl:call-template name="tokenizer">
                                    <xsl:with-param name="dcElementName">dc:source</xsl:with-param>
                                </xsl:call-template>
                            </xsl:for-each>

                            <xsl:for-each select="Publication_History | Poem_Publication_History">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:source</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
-->
                            <xsl:for-each select="Publisher | Digital_Publisher">
                                <xsl:if test="string-length() != 0">
                                    <dc:publisher>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"
                                        /></dc:publisher>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. There will be only one use of identifier -->
                            <xsl:for-each select="identifier | File_Name">
                                <xsl:if test="string-length() != 0">
                                    <dc:identifier>
                                        <xsl:value-of select="."/>
                                    </dc:identifier>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="Digital_Collection | Digital_Collection_Link | Digital_Repository--h">
                                <xsl:if test="string-length() != 0">
                                    <dc:relation>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"
                                        />)</dc:relation>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select=" isAbstractOf | isArticleOf | isAudioOf | isClipOf | isDraftOf | isEssayOf | isLetterOf | isMemberOf | isOCRof | isPartOf | isPoemOf | isStillOf | isThesisOf | isTOCof | isTranscriptOf | isVideoOf">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName"
                                            >dc:relation</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- this routine really should add |Copyright or |Use after the appropriate elements instead of just looking for the word 'copyright' in the value -->
                            <!-- Do NOT append field name to value. "copyright" is targeted and the others are "use and restrictions by default. " -->
                            <xsl:for-each
                                select="rights | Copyright_Status | Copyright_Status--h | Restrictions_on_Access | Use_and_Reproductions">
                                <xsl:if test="string-length() != 0">
                                    <dc:rights>
                                        <xsl:value-of select="."/>
                                    </dc:rights>
                                </xsl:if>
                            </xsl:for-each>

                        </oai_dc:dc>

                    </metadata>
                </record>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <!-- tokenizer splits values into parts at a semicolon and outputs separately wrapped elements for each part. -->
    <xsl:template name="tokenizer">

        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:param name="dcElementName"/>
        <!-- Element name for wrapper of the value. -->

        <xsl:element name="{$dcElementName}">
            <xsl:value-of select="normalize-space(substring-before($string, $delimiter))"/>
            <!-- would like to find a way to use concat() to combine the next three lines -->
            <!--            <xsl:if test="not(contains($string, '|'))"> -->
            <xsl:text>|</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text/>
            <!--            </xsl:if> -->
        </xsl:element>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenizer">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
                <xsl:with-param name="dcElementName" select="$dcElementName"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
