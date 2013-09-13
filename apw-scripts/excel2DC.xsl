<?xml version="1.0" encoding="UTF-8"?>
<!-- instructions:
 If this script adds a namespace for this element in the output file, please remove it.

1. Import the spreadsheet into oXygen to create an XML file.
2. Run this script on the XML file.
3. The for-each routines look for labels used as header in the imported spreadsheet.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://elib.hamilton.edu/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcq="http://purl.org/dc/terms/"
    xmlns:sru_dc="info:srw/schema/1/dc-schema" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:param name="delimiter" select="';'"/>

    <xsl:template match="/">

        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fedoraAudit="http://fedora.comm.nsdlib.org/audit"
            xmlns:xlink="http://www.w3.org/TR/xlink" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/">
            <responseDate>2013-04-26T16:27:32Z</responseDate>
            <request verb="ListRecords" metadataPrefix="dcq">http://elib.hamilton.edu/cgi-bin/oai.exe</request>
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
                        <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ 
http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

                            <!-- Append field name to field value only when needed to specify something field to 
                            MODS such as a specific authority or displayLabel -->

                            <!-- Do NOT append field name to value -->
                            <xsl:for-each select="Title | Alternative_Title | Secondary_Title">
                                <xsl:variable name="len">
                                    <xsl:value-of select="string-length(.)"/>
                                </xsl:variable>
                                <xsl:if test="$len >= 1">
                                    <dc:title>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/>
                                    </dc:title>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value -->
                            <xsl:for-each select="creator | Creator | Author | author | Writer | writer">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:contributor</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Recipient | Depicted | Narrator | Speaker | Translator | Contributor">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:contributor</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="DCMIType | Type_Of_Resource | Type_Of_Resource--AAT | Type_of_Resource | TypeAAT ">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:type</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. 
                            They will be looked up in controlled vocaularies. -->
                            <xsl:for-each select="Poetic_Form | Poetic_Form | genre--local | Genre--local | Genre--Local | genre | Genre | Type_of_Performance">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:type</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="format | MIMEType |  MIME_Type|  Media_Type | Format--MIME_Type | Format--MIME_type | Duration | File_Size--KB | Extent | Physical_Description">
                                <xsl:if test="string-length() != 0">
                                    <!-- tokenization turned off 2013-05-24 
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:format</xsl:with-param>
                                    </xsl:call-template>
-->
                                    <dc:format>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/>
                                    </dc:format>
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

                            <xsl:for-each select="abstract | Abstract | Table_of_Contents | Table_Of_Contents">
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
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/></dc:description>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Date_Created__full_ | Date_created__full_">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                        <xsl:text>|Date_Created_Full</xsl:text>
                                    </dc:date>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="Date_Created__ISO_ | Date_created__ISO_">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                        <xsl:text>|Date_Created_ISO</xsl:text>
                                    </dc:date>
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

                            <xsl:for-each select="Date_Captured | Date_captured">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                        <xsl:text>|Issued</xsl:text>
                                    </dc:date>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Date_Created | Date_created | Year_Created">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>
                                        <xsl:text>|Created</xsl:text>
                                    </dc:date>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Date | Date_Note">
                                <xsl:if test="string-length() != 0">
                                    <dc:date>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/>
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
                                        <xsl:with-param name="dcElementName">dc:coverage</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. Values will be looked up in controlled vocabularies. -->
                            <xsl:for-each
                                select="Subject_Heading--LCSH | Subject_heading--LCSH | Subject_Headings--LCSH | Subject_headings--LCSH | tags | Tags | Photo_Subject | Personal_Names | Corporate_Names">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:subject</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Region">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:coverage</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- do not tokenize dc:source fields, this prevents creating multiple instances. If you need to tokenize any at semicolons, then create a new routine lik this:
                            <xsl:for-each
                                select="Source | Inscriptions | Holder_of_Original | Original_Collection | Original_Item_ID | Internal_Notes | Contact |
 Processing_History | Physical_Location | note | SDonation_information | Publication_History |
 Publication_history | Poem_Publication_History | Donation_Information | Performance_Location | Performance_location | Submitter | Place_Of_Origin |
 Signed | First_Line | Hough_Notes | Edition | Shelf_Location | Internal_Notes">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:source</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
-->
                            <xsl:for-each
                                select="Source | Inscriptions | Holder_of_Original | Original_Collection | Original_Item_ID | Internal_Notes | Contact |
                                Processing_History | Physical_Location | Evidence_Level--h | Cataloging_Level--h | note | Submitter--h | Donation_information | Publication_History |
                                Publication_history | Poem_Publication_History | Donation_Information | Performance_Location | Performance_location | Submitter | Place_Of_Origin |
                                Signed | First_Line | Hough_Notes | Edition | Shelf_Location | Internal_Notes">
                                <xsl:if test="string-length() != 0">
                                    <dc:source>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/>
                                    </dc:source>
                                </xsl:if>
                            </xsl:for-each>

                                <!-- grab all mods:extension candidates -->
                            <!--
                            <xsl:for-each select="node()">
                                <xsl:if test="contains(name(),'extension')">
                                    <dc:source>
                                        <xsl:value-of select="concat('|extension_',substring-after(name(),'_'))"/>
                                    </dc:source>
                                </xsl:if>
                            </xsl:for-each>
-->
                            <!-- Shahid project extension elements -->
                            <xsl:for-each select="Hometown-Residence_of_Performer | Gender | Race-Ethnicity | Perspective-POV | Location_of_Performance | Event_Where_Performed | Performer_Experience">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:valid</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- prison writer's project extension elements -->
                            <xsl:for-each
                                select="extension_prison_name | extension_prison_location | extension_ethnicity | extension_gender | extension_gender_identity | extension_birthdate | extension_religion | extension_veteran | extension_has_children | extension_num_children | extension_prison_status | extension_crime | extension_prison_security | extension_prison_work | extension_incarceration_num | extension_age_conviction | extension_relatives_incarcerated | extension_biography">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:valid</xsl:with-param>
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
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/></dc:publisher>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Do NOT append field name to value. There will be only one use of identifier -->
                            <xsl:for-each select="identifier | Identifier | File_Name">
                                <xsl:if test="string-length() != 0">
                                    <dc:identifier>
                                        <xsl:value-of select="."/>
                                    </dc:identifier>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each select="Digital_Collection | Digital_Collection_Link | Digital_Repository--h">
                                <xsl:if test="string-length() != 0">
                                    <dc:relation>
                                        <xsl:value-of select="."/>|<xsl:value-of select="name()"/>)</dc:relation>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:for-each
                                select="Relationships | relationships | Relationship | relationship">
                                <xsl:if test="string-length() != 0">
                                    <xsl:call-template name="tokenizer">
                                        <xsl:with-param name="dcElementName">dc:relation</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- this routine really should add |Copyright or |Use after the appropriate elements instead of just looking for the word 'copyright' in the value -->
                            <!-- Do NOT append field name to value. "copyright" is targeted and the others are "use and restrictions by default. " -->
                            <xsl:for-each select="rights | Copyright_Status | Copyright_Status--h | Restrictions_on_Access | Use_and_Reproductions">
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
            <!-- <xsl:if test="not(contains($string, '|'))"> -->
            <xsl:text>|</xsl:text>
            <xsl:value-of select="name()"/>
            <!-- </xsl:if> -->
        </xsl:element>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenizer"> #<xsl:with-param name="string" select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
                <xsl:with-param name="dcElementName" select="$dcElementName"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
