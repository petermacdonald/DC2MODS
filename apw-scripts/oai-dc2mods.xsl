<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcq="http://purl.org/dc/terms/"
    xmlns:sru_dc="info:srw/schema/1/dc-schema"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.loc.gov/mods/v3"
    xmlns:dhi="http://dhinitiative.org/dhi/"
    xsi:schemaLocation="http://www.bepress.com/OAI/2.0/qualified-dublin-core/ 
    http://www.bepress.com/assets/xsd/oai_qualified_dc.xsd"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="sru_dc oai_dc dc"
    version="1.0">

    <!--
            Used to convert OAI-DC files exported from Hamilton Colleges' instance of CONTENTdm to MODS.
            
            Version 1.0 created 2006-11-01 by Clay Redding <cred@loc.gov>
            
            This stylesheet will transform simple Dublin Core (DC) expressed in either OAI DC [1] to MODS version 3.2.
            
            Reasonable attempts have been made to automatically detect and process the textual
            content of DC elements for the purposes of outputting to MODS.  Because MODS is 
            more granular and expressive than simple DC, transforming a given DC element to the 
            proper MODS element(s) is difficult and may result in imprecise or incorrect tagging.

            In order to make the process more precise this script not only checks for the DC element, 
            but after that looks to see if the value is found in an appropriate controlled vocabulary (CV), 
            and it also looks for a piped term (e.g., |Series) following the value of the element 
            and uses that as the mods displayLabel attribute.

            MODS also often encourages content adhering to various data value standards.
            The contents of some of the more widely used value standards, such as IANA MIME
            types, ISO 3166-1, ISO 639-2, etc., have been added as include files to 
            facilitate proper mapping of simple DC to the proper MODS elements.  A crude attempt
            at detecting the contents of DC identifiers and outputting them to the proper MODS
            elements has been made as well.  Common persistent identifier schemes, standard
            numbers, etc., have been included. To truly detect these efficiently, XSL/XPath 2.0
            or XQuery may be needed in order to utilize regular expressions.
            
            [1] http://www.openarchives.org/OAI/openarchivesprotocol.html#MetadataNamespaces
            [2] http://www.loc.gov/standards/sru/record-schemas.html
            
            Version 1.1 2011-09-08, an update of 1.0 by Peter MacDonald, Hamilton College <pmacdona@hamilton.edu>
            - This procedure is designed to provide a way to crosswalk all simple DC elements 
            in CONTENTdm to corresonding MODS elements.
            - This procedure acts on XML resulting from an OAI harvest of CONTENTdm records.
            - OAI harvests process only simple Dublin Core.
            - OAI harvests ignore CONTENTdm fields that are mapped to "none".
            - In order for this to work properly with CONTENTdm records, the CONTENTdm fields 
            need to be configured in the following ways.
            
            - GENERAL INSTRUCTIONS:
            1. Configure CONTENTdm to expose to OAI harvesting the collection(s) you want to
            convert to MODS.
            2. OAI harvesting only processes fields mapped to DC. So, any field you want
            migrated needs to be mapped to a Dublin Core field - either simple or qualified DC,
            but note that the OAI harvest turns all Qualified DC to Simple DC representations.
            I map these fields to dc:source because I never use that field for anything particular.
            3. Do an OAI export from CONTENTdm of all records in the collection you want to process.
            example: http://<DNS.domain>/cgi-bin/oai.exe?verb=ListRecords&metadataPrefix=oai_dc
            4. Save the output as an xml file.               
            Ensure that all fields values end with a semicolon.
            5. Put
            6. Transform the output xml file with this .xsl file.
            
            OPTIONAL CUSTOMIZATION:
            - CREATING CUSTOM CONTROLLED VOCABULARY FILES
            - You can add your own values to the CV files that are provided
            with this distribution package. But if you use unique controlled vocabularies in
            your CONTENTdm that are not included in this stylesheet, you can add them as new
            files in the inc folder.
            Example, if you have a personal names CV, you can create an XSL file for it in the
            inc folder and load it and reference its parameter at appropriate places in the main
            XSL file. This allows you to test for the presence of a field value in the list and 
            to add the attribute type="personal" to the <name> element.
            - If you do not use a CV for a field, but still want to keep
            the semantics of the fields as they appear in your CONTENTdm instance, you can
            append your local element name to the field's content value, preceded by a pipe character
            (e.g. |Series). You can do this by
            using the Project Client's Advanced Search and Replace with the regular expression $
            to place the name at the end of the content.
            (e.g., Original Item ID: "FS 43.333.x 1994|Original Item ID".
            Then test for the string using the contains() function. [See examples used throught
            this script.]
            - If you create custom CV files, they must be up-to-date so they
            will contain entries for all field values that should be found by the script. If a
            value is not found in the CV file, the script will map it to a default value.
            - TIP: Replace all illegal characters with valid entities (&amp;, etc.) to avoid XML processing errors.    
        -->

    <!-- MODS ENCODING PRACTICES:
- Every MODS field is given a displayLabel attribute, if it is allowed to have one. 
-->

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <!--    <xsl:include href="inc/dcmiType.xsl"/> -->
    <!--    <xsl:include href="inc/mimeType.xsl"/> -->
    <xsl:include href="inc/forms.xsl"/>
    <xsl:include href="inc/iso3166-1.xsl"/>
    <!--    <xsl:include href="inc/iso639-2.xsl"/> -->
    <xsl:include href="inc/marcCategory.xsl"/>

    <!-- Hamilton College custom controlled vocabulary files -->
    <!-- CVs are needed only when you need the stylesheet to do something special when a value is found 
in the CV such as add a code or to change the value name or to add a special subelement-->
    <xsl:include href="inc/hamCollection.xsl"/>
    <xsl:include href="inc/hamHolder.xsl"/>
    <!--    <xsl:include href="inc/hamPerson.xsl"/>
    <xsl:include href="inc/hamCorp.xsl"/> -->
    <xsl:include href="inc/hamRelator.xsl"/>
    <!-- Vocaularies used in Shahid project -->
    <!--    <xsl:include href="inc/dhiPoetryGenre.xsl"/> -->
    <xsl:include href="inc/dhimigfigGenre.xsl"/>
    <xsl:include href="inc/dhiLocalGenre.xsl"/>
    <!--    <xsl:include href="inc/dhiLCSH.xsl"/> -->
    <xsl:include href="inc/dhiSubmitter.xsl"/>

    <xsl:param name="delimiter" select="';'"/>

    <!-- Do you have a Handle server?  If so, specify the base URI below including the trailing slash a la: http://hdl.loc.gov/ -->
    <xsl:variable name="handleServer">
        <xsl:text>http://hdl.loc.gov/</xsl:text>
    </xsl:variable>
    <!-- strip empty DC elements that are output by tools like ContentDM -->
    <!--
    <xsl:template match="*[not(node())]"/>
-->
    <xsl:template match="/">
        <allMD>
            <xsl:if test="//oai_dc:dc">
                <xsl:call-template name="oadidc"/>
            </xsl:if>
        </allMD>
    </xsl:template>

    <xsl:template name="oadidc">
        <xsl:for-each select="descendant::oai_dc:dc">
            <!-- Select only those that have a dc:relation fields that starts with 'Civil War Letters and Diaries' 
                as these are the only ones to be processed by DGI at this time -->
            <!-- suppressed because I want all records processed, not just Civil War Letters
     <xsl:if test=" starts-with(child::dc:relation, 'Civil War Letters and Diaries')">
-->
            <root>
                <mods version="3.2" xmlns="http://www.loc.gov/mods/v3"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
                    <xsl:call-template name="dcMain"/>

                    <!-- Start of local HARDCODED MODS elements -->

                    <note displayLabel="Digital Publisher">Digital resource provided by the Digital
                        Humanities Initiative, http://dhinitiative.org.</note>

                    <!-- BEINECKE relatedItem
                        
                    <relatedItem displayLabel="Collection Name">
                        <titleInfo>
                            <title>Beinecke Lesser Antilles Collection</title>
                        </titleInfo>
                        <location displayLabel="Collection URL">
                            <url>http://beinecke.dhinitiative.org/</url>
                        </location>
                        <name displayLabel="Project Director" type="personal">
                            <namePart>Goodwillie, Christian</namePart>
                            <affiliation>Hamilton College Library, Clinton, New York</affiliation>
                            <description>Director of Special Collections and Archives</description>
                        </name>
                    </relatedItem>

                    <accessCondition displayLabel="Copyright Status">This material is in the public domain.</accessCondition>
                    <accessCondition displayLabel="Restriction on Access" type="restriction on access">There are no restrictions on access to these materials.</accessCondition>
                    <accessCondition displayLabel="Use and Reproduction" type="use and reproduction">This resource is made available free for educational purposes only. For more information on access,
                        use and reproduction of this resource contact the Special Collection Department of Hamilton College.</accessCondition>
                    
                    <recordInfo>
                        <recordContentSource>Hamilton College Library</recordContentSource>
                        <recordCreationDate encoding="w3cdtf">2013</recordCreationDate>
                    </recordInfo>
-->

                    <relatedItem displayLabel="Collection Name">
                        <titleInfo>
                            <title>American Prison Writers Archive</title>
                        </titleInfo>
                        <location displayLabel="Collection URL">
                            <url>http://apw.dhinitiative.org/</url>
                        </location>
                        <name displayLabel="Project Director" type="personal">
                            <namePart>Larson, Doran</namePart>
                            <affiliation>Hamilton College, Clinton, New York</affiliation>
                            <description>Professor, English and Creative Writing, Hamilton College,
                                Clinton, New York</description>
                        </name>
                    </relatedItem>

                    <relatedItem displayLabel="Sponsoring Agency">
                        <titleInfo>
                            <title>Digital Humanities Initiative</title>
                        </titleInfo>
                        <location displayLabel="Collection URL">
                            <url>http://dhinitiative.org/</url>
                        </location>
                    </relatedItem>

                    <!-- the following lines can be enabled if the data is not in the metadata source -->
                    <!--
                        <accessCondition displayLabel="Copyright Status">This material is in the public domain.</accessCondition>
                    <accessCondition displayLabel="Restriction on Access" type="restriction on access">There are no restrictions on access to these materials.</accessCondition> -->
                    <accessCondition displayLabel="Use and Reproduction" type="use and reproduction"
                        >This resource is made available free for educational purposes only. For
                        more information on access, use and reproduction of this resource contact
                        the Digital Humanities Initiative,
                        http://dhinitiative.org/.</accessCondition>

                    <recordInfo>
                        <recordContentSource>Hamilton College Library</recordContentSource>
                        <recordCreationDate encoding="w3cdtf">2013</recordCreationDate>
                    </recordInfo>

                    <!-- End of local HARDCODED MODS elements -->
                </mods>
            </root>
            <!--            </xsl:if> -->
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="dcMain">

        <xsl:for-each select="dc:title">
            <xsl:apply-templates select="."/>
        </xsl:for-each>

        <!-- processing dc:type looking for only Type of Resource terms -->
        <xsl:for-each select="dc:type">
            <xsl:call-template name="tokenize-typeOfResource"/>
        </xsl:for-each>
        <!-- processing dc:type looking for only local terms -->
        <!-- suppressed , may duplication tonkenize-type        <xsl:for-each select="dc:type">
            <xsl:call-template name="tokenize-type-local"/>
        </xsl:for-each>
-->
        <!-- dc:creator is not used. Instead use dc:contributor in all cases.
        <xsl:for-each select="dc:creator">
            <xsl:call-template name="tokenize-creator"/>
        </xsl:for-each>
-->
        <xsl:for-each select="dc:contributor">
            <xsl:call-template name="tokenize-contributor"/>
        </xsl:for-each>

        <xsl:for-each select="dc:language">
            <language>
                <xsl:attribute name="displayLabel">
                    <xsl:text>Language</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="tokenize-language"/>
            </language>
        </xsl:for-each>

        <xsl:if test="dc:format">
            <physicalDescription>
                <xsl:for-each select="dc:format">
                    <xsl:call-template name="tokenize-format"/>
                </xsl:for-each>
            </physicalDescription>
        </xsl:if>

        <originInfo>
            <xsl:attribute name="displayLabel">
                <xsl:text>Origin Information</xsl:text>
            </xsl:attribute>
            <xsl:for-each select="dc:publisher">
                <xsl:if test="contains(text(), '|Publisher') or contains(text(), '|publisher')">
                    <publisher>
                        <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                    </publisher>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="dc:date">
                <xsl:call-template name="tokenize-date"/>
            </xsl:for-each>

            <!-- added 2012-09-21 -->
            <!-- FIND A DC:SOURCE THAT HAS INFORMATION YOU WANT INSIDE mods:originInfo/place -->
            <xsl:for-each select="dc:source">
                <xsl:if
                    test="contains(text(), '|Performance_Location') or contains(text(), '|Performance_location') or contains(text(), '|Place_of_publication') or contains(text(), '|Place_of_Publication')">
                    <place>
                        <placeTerm type="text">
                            <!-- displayLabel disabled because this attribute is illegal in a MODS subelement.
                        <xsl:attribute name="displayLabel">
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </xsl:attribute>
-->
                            <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                        </placeTerm>
                    </place>
                </xsl:if>
            </xsl:for-each>
        </originInfo>

        <!-- processing dc:type not looking for typeOfResource -->
        <xsl:for-each select="dc:type">
            <xsl:if test="contains(text(), 'Collection') or contains(text(), 'collection')">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>collection</xsl:text>
                </genre>
            </xsl:if>
            <xsl:call-template name="tokenize-type"/>
        </xsl:for-each>

        <xsl:if test="dc:subject">
            <xsl:for-each select="dc:subject">
                <!-- look for all keywords/tags -->
                <xsl:if test="contains(text(), 'Tags') or contains(., 'tags')">
                    <xsl:call-template name="tokenize-subjects-keywords"/>
                </xsl:if>
                <!-- look for all lcsh Subject Headings -->
                <xsl:if test="contains(text(), 'ubject') or contains(., 'lcsh')">
                    <xsl:call-template name="tokenize-subjects-lcsh"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>

        <!-- look for all LC Subject Headings -->
        <!--
        <xsl:if test="dc:subject">
            <subject>
                <xsl:if test="contains(text(), '|')">
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:for-each select="dc:subject">
                </xsl:for-each>
            </subject>
        </xsl:if>
-->
        <!-- 
                    <subject>
                        <xsl:attribute name="displayLabel">
                            <xsl:text>Subject Headings:LCSH</xsl:text>
                        </xsl:attribute>
                        <xsl:for-each select="dc:subject">
                                <xsl:call-template name="tokenize-subjects-lcsh"/>                            
                        </xsl:for-each>
                    </subject>
            </xsl:choose>
        </xsl:if>
 -->
        <!--
                <xsl:when test="contains(text(), 'LCSH')">
                    <xsl:for-each select="dc:subject">
                        <subject>
                            <xsl:attribute name="displayLabel">
                                <xsl:value-of
                                    select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                                />
                            </xsl:attribute>
                            <xsl:call-template name="tokenize-subjects-lcsh"/>
                        </subject>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="dc:subject">
                        <subject>
                            <xsl:attribute name="displayLabel">
                                <xsl:text>Other</xsl:text>
                            </xsl:attribute>
                            <xsl:call-template name="tokenize-subjects-keywords"/>
                        </subject>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
-->
        <xsl:if test="dc:valid">
            <extension>
                <dhi:dhi xmlns:dhi="http://dhinitiative.org/dhi/">
                    <xsl:for-each select="dc:valid">
                        <xsl:call-template name="tokenize-extension"/>
                    </xsl:for-each>
                </dhi:dhi>
            </extension>
        </xsl:if>


        <xsl:if test="dc:coverage">
            <subject>
                <xsl:choose>
                    <xsl:when test="contains(text(), '|')">
                        <xsl:attribute name="displayLabel">
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="displayLabel">
                            <xsl:text>Geographic Term</xsl:text>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:for-each select="dc:coverage">
                    <xsl:call-template name="tokenize-geographic"/>
                </xsl:for-each>
            </subject>
        </xsl:if>

        <xsl:for-each select="dc:description">
            <xsl:apply-templates select="."/>
        </xsl:for-each>

        <!--         <xsl:for-each select="dc:valid">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
 -->
        <xsl:for-each select="dc:identifier">
            <xsl:apply-templates select="."/>
        </xsl:for-each>

        <xsl:for-each select="dc:relation">
            <xsl:call-template name="tokenize-relation"/>
        </xsl:for-each>

        <xsl:for-each select="dc:source">
            <xsl:apply-templates select="."/>
        </xsl:for-each>

        <!-- looking for the digital publisher to place into a note field -->
        <xsl:for-each select="dc:publisher">
            <xsl:if test="contains(text(), '|Digital_Publisher')">
                <note>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                </note>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="dc:rights">
            <xsl:apply-templates select="."/>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="dc:title">
        <!-- not split at semicolons -->
        <titleInfo>
            <!-- $$ -->
            <xsl:choose>
                <xsl:when test="contains(text(), '|')">
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Title</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <title>
                <xsl:value-of
                    select="normalize-space(translate(substring-before(text(), '|'),';', '')) "/>
            </title>
        </titleInfo>
    </xsl:template>

    <xsl:template match="dc:description">
        <!-- not split at semicolons -->
        <xsl:if test="string-length(.) > 2">
            <xsl:choose>
                <xsl:when test="contains(., '|Abstract')">
                    <abstract>
                        <xsl:attribute name="displayLabel">
                            <xsl:text>Abstract</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                    </abstract>
                </xsl:when>
                <xsl:when test="contains(., '|Table_of_Contents')">
                    <tableOfContents>
                        <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                    </tableOfContents>
                </xsl:when>
                <xsl:otherwise>
                    <note type="description">
                        <xsl:value-of select="normalize-space(text()) "/>
                    </note>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dc:identifier">
        <xsl:variable name="iso-3166Check">
            <xsl:value-of select="substring(text(), 1, 2)"/>
        </xsl:variable>
        <identifier>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="starts-with(text(), 'http')">
                        <xsl:text>Original URL</xsl:text>
                    </xsl:when>
                    <!-- handled by location/url -->
                    <xsl:when
                        test="starts-with(text(), 'http') and (not(contains(text(), $handleServer) or not(contains(substring-after(text(), 'http'), 'hdl'))))">
                        <xsl:text>uri</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(text(),'urn:hdl') or starts-with(text(),'hdl') or starts-with(text(),'http://hdl.')">
                        <xsl:text>hdl</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'doi')">
                        <xsl:text>doi</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'ark')">
                        <xsl:text>ark</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(text(), 'purl')">
                        <xsl:text>purl</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'tag')">
                        <xsl:text>tag</xsl:text>
                    </xsl:when>
                    <!-- will need to update for ISBN 13 as of January 1, 2007, see XSL tool at http://isbntools.com/ -->
                    <xsl:when
                        test="(starts-with(text(), 'ISBN') or starts-with(text(), 'isbn')) or ((string-length(text()) = 13) and contains(text(), '-') and (starts-with(text(), '0') or starts-with(text(), '1'))) or ((string-length(text()) = 10) and (starts-with(text(), '0') or starts-with(text(), '1')))">
                        <xsl:text>isbn</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(starts-with(text(), 'ISSN') or starts-with(text(), 'issn')) or ((string-length(text()) = 9) and contains(text(), '-') or string-length(text()) = 8)">
                        <xsl:text>issn</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'LCCN') or starts-with(text(), 'lccn')">
                        <!-- probably can't do this quickly or easily without regexes and XSL 2.0 -->
                        <xsl:text>lccn</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Local object ID</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when
                    test="starts-with(text(),'urn:hdl') or starts-with(text(),'hdl') or starts-with(text(),$handleServer)">
                    <xsl:value-of select="concat('hdl:',substring-after(text(),$handleServer))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(translate(text(),';', '')) "/>
                </xsl:otherwise>
            </xsl:choose>
        </identifier>
    </xsl:template>

    <xsl:template match="dc:source">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:choose>
            <!-- although this test routine for object holder works, but it probably can just be HARDCODED because the script is usually run on batches of similar objects from the same holder
            <xsl:when test="contains($hamHolder, text())">
                <location>
                    <physicalLocation>
                        <xsl:attribute name="displayLabel">
                            <xsl:text>Repository</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(text())"/>
                    </physicalLocation>
                    <url access="object in context" usage="primary display">
                        <xsl:attribute name="displayLabel">
                            <xsl:text>MODS metadata</xsl:text>
                        </xsl:attribute>
                    </url>
                </location>
            </xsl:when>
-->
            <xsl:when test="contains(text(), '|Edition')">
                <originInfo>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <edition>
                        <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                    </edition>
                </originInfo>
            </xsl:when>

            <xsl:when
                test="contains(text(), '|Original_Collection') or contains(text(), '|Physical_Location') or contains(text(), '|Original_Item_ID') or contains(text(), '|Shelf_')">
                <location>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <physicalLocation>
                        <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                    </physicalLocation>
                </location>
            </xsl:when>

            <xsl:when test="contains(text(), '|Note') or contains(text(), '|note')">
                <note>
                    <xsl:attribute name="type">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                </note>
            </xsl:when>

            <!-- ####### START OF MODS:EXTENSION ######## -->
            <!--
                <xsl:when test="contains(text(), '|custom') or contains(., '|Custom') or contains(., '|Extension_') or contains(., '|extension_')">
                <extension>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Custom Fields</xsl:text>
                    </xsl:attribute>
                    <xsl:call-template name="tokenize-extension"/>
                </extension>
            </xsl:when>
            -->
            <!-- ####### END OF MODS:EXTENSION ######## -->

            <xsl:otherwise>
                <note type="other">
                    <xsl:if test="contains(text(), '|')">
                        <xsl:attribute name="displayLabel">
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of
                        select="normalize-space(translate(substring-before(text(), '|'),';', '')) "
                    />
                </note>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dc:coverage">
        <!-- if values in dc:coverage are dates, then the field is temporal -->
        <xsl:if
            test="string-length(text()) >= 3 and (starts-with(text(), '1') or starts-with(text(), '2') or starts-with(text(), '3') or starts-with(text(), '4') or starts-with(text(), '5') or starts-with(text(), '6') or starts-with(text(), '7') or starts-with(text(), '8') or starts-with(text(), '9') or starts-with(text(), '-') or contains(text(), 'AD') or contains(text(), 'BC')) and not(contains(text(), ':'))">
            <!-- using XSL 2.0 for date parsing is A Better And Saner Idea -->
            <xsl:choose>
                <xsl:when test="contains(., ';')">
                    <xsl:call-template name="tokenize-temporal"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <!-- to be changed : this routine should really look for '|Copyright' or '|Use' once convert2DC file adds it -->
    <!-- for batches it might be easier to put this in the HARDCODED area below -->
    <xsl:template match="dc:rights">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:choose>
            <xsl:when test="contains($string,'Copyright')">
                <accessCondition>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(text())"/>
                </accessCondition>
            </xsl:when>
            <xsl:otherwise>
                <accessCondition displayLabel="Rights">
                    <xsl:value-of select="normalize-space(text())"/>
                </accessCondition>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ####### START OF TOKENIZING ######## -->

    <xsl:template name="tokenize-language">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>


        <xsl:choose>
            <xsl:when test="contains($string,'English')">
                <languageTerm type="text">
                    <xsl:text>English</xsl:text>
                </languageTerm>
                <languageTerm>
                    <xsl:attribute name="type">
                        <xsl:text>code</xsl:text>
                    </xsl:attribute>

                    <xsl:attribute name="authority">
                        <xsl:text>iso639-2b</xsl:text>
                    </xsl:attribute>

                    <xsl:text>eng</xsl:text>
                </languageTerm>
            </xsl:when>
            <xsl:when test="contains($string,'Japanese')">
                <languageTerm type="text">
                    <xsl:text>Japanese</xsl:text>
                </languageTerm>
                <languageTerm>
                    <xsl:attribute name="type">
                        <xsl:text>code</xsl:text>
                    </xsl:attribute>

                    <xsl:attribute name="authority">
                        <xsl:text>iso639-2b</xsl:text>
                    </xsl:attribute>

                    <xsl:text>jpn</xsl:text>
                </languageTerm>
            </xsl:when>
            <xsl:when test="contains($string,'Latin')">
                <languageTerm type="text">
                    <xsl:text>Latin</xsl:text>
                </languageTerm>
                <languageTerm>
                    <xsl:attribute name="type">
                        <xsl:text>code</xsl:text>
                    </xsl:attribute>

                    <xsl:attribute name="authority">
                        <xsl:text>iso639-2b</xsl:text>
                    </xsl:attribute>

                    <xsl:text>ltn</xsl:text>
                </languageTerm>
            </xsl:when>
            <xsl:when
                test="contains($string,'Dutch') or contains($string,'dutch') or contains($string,'dut')">
                <languageTerm type="text">
                    <xsl:text>Dutch</xsl:text>
                </languageTerm>
                <languageTerm>
                    <xsl:attribute name="type">
                        <xsl:text>code</xsl:text>
                    </xsl:attribute>

                    <xsl:attribute name="authority">
                        <xsl:text>iso639-2b</xsl:text>
                    </xsl:attribute>

                    <xsl:text>dut</xsl:text>
                </languageTerm>
            </xsl:when>
            <xsl:otherwise>
                <languageTerm type="text">
                    <xsl:attribute name="type">
                        <xsl:text>text</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of
                        select="normalize-space(translate(substring-before($string, $delimiter),';', '')) "
                    />
                </languageTerm>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-language">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- ###################### -->
    <!-- Looking for only Type of Resource terms to put in a MODS typeOfResource element -->
    <xsl:template name="tokenize-typeOfResource">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:choose>
            <xsl:when
                test="contains($string, 'still image') or contains($string, 'Still Image') or contains($string, 'Still image')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>still image</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'moving image')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>moving image</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'three dimensional object')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>three dimensional object</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'software, multimedia')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>software, multimedia</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'cartographic')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>cartographic</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'cartographic')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>cartographic</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'still image')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>still image</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:when test="contains($string, 'text') or contains($string, 'Text')">
                <typeOfResource>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Type of Resource</xsl:text>
                    </xsl:attribute>
                    <xsl:if
                        test="../dc:type[string(text()) = 'collection' or substring-before($string, $delimiter) = 'Collection']">
                        <xsl:attribute name="collection">
                            <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>text</xsl:text>
                </typeOfResource>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tokenize-type-local"/>
                <!-- suppressed 2013-05-24                    
                    <note>
                        <xsl:attribute name="displayLabel">
                            <xsl:text>Type of ResourceLocal Term</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-before(text(), '|'))"/>
                    </note>
-->
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-typeOfResource">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ###################### -->
    <!-- DONE running tokenize-type-local : looking for only local terms to put in a MODS genre element -->
    <xsl:template name="tokenize-type-local">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>

        <!--        <xsl:if test="string-length($string > 2) and not(string($types) = text())"> -->
        <!-- Routine to check CV for valid local genre terms -->
        <xsl:if test="contains($string, 'Genre') or contains($string, 'genre')">
            <!--                 <xsl:variable name="lowercaseType"
                    select="translate(substring-before($string, $delimiter), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
 -->
            <genre>
                <xsl:attribute name="authority">
                    <xsl:text>local</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="substring-before($string, '|')"/>
            </genre>
            <!--            </xsl:if> -->
        </xsl:if>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-type-local">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ############################ -->
    <!-- running tokenize-type a second time, but tossing out local genre terms 
Also not created Type of Resource MODS fields (already created above) but creating only related
genre fields here instead. -->
    <xsl:template name="tokenize-type">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>

        <xsl:choose>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Dataset' or substring-before($string, $delimiter) = 'dataset'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>dataset</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Image' or substring-before($string, $delimiter) = 'image'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>image</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'InteractiveResource' or substring-before($string, $delimiter) = 'interactiveresource' or substring-before($string, $delimiter) = 'Interactive Resource' or substring-before($string, $delimiter) = 'interactive resource' or substring-before($string, $delimiter) = 'interactiveResource'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>interactive resource</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="string(translate(text(), ';', '')) = 'MovingImage' or substring-before($string, $delimiter) = 'movingimage' or substring-before($string, $delimiter) = 'Moving Image' or substring-before($string, $delimiter) = 'moving image' or substring-before($string, $delimiter) = 'movingImage'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>moving image</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'PhysicalObject' or substring-before($string, $delimiter) = 'physicalobject' or string(text()) = 'Physical Object' or string(text()) = 'physical object' or string(text()) = 'physicalObject'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>physical object</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Service' or substring-before($string, $delimiter) = 'service'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>service</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Software' or substring-before($string, $delimiter) = 'software'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>software</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Sound' or substring-before($string, $delimiter) = 'sound'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>sound</xsl:text>
                </genre>
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'StillImage' or substring-before($string, $delimiter) = 'stillimage' or substring-before($string, $delimiter) = 'stillImage' or substring-before($string, $delimiter) = 'Still Image' or substring-before($string, $delimiter) = 'still image'">
                <!--                <xsl:if test="not(string($types) = text())"> -->
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>still image</xsl:text>
                </genre>
                <!--                </xsl:if> -->
            </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Text' or substring-before($string, $delimiter) = 'text'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:text>text</xsl:text>
                </genre>
            </xsl:when>

            <!-- Routine to check CV for valid poetry genre terms -->
            <xsl:when test="contains($string, '|Poetic_Form')">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>lcsh-poetry</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Poetic Form</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before($string, '|')"/>
                </genre>
            </xsl:when>

            <xsl:when test="contains($dhimigfigGenre, normalize-space(text()))">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>migfig</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Movie Genre</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(text())"/>
                </genre>
            </xsl:when>
            <!-- DONE do nothing if it is a local genre term -->
            <xsl:when test="contains($dhiLocalGenre, normalize-space(text()))"> </xsl:when>
            <xsl:when
                test="substring-before($string, $delimiter) = 'Event' or substring-before($string, $delimiter) = 'event'">
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>dct</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Event</xsl:text>
                    </xsl:attribute>
                    <xsl:text>event</xsl:text>
                </genre>
            </xsl:when>
            <!-- do nothing if type_of_resource -->
            <xsl:when test="contains(text(), 'Type_Of_Resource')"/>
            <xsl:otherwise>
                <!--                <xsl:if test="string-length($string > 2) and not(string($types) = text())"> -->
                <xsl:variable name="lowercaseType"
                    select="translate(substring-before($string, $delimiter), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <genre>
                    <xsl:attribute name="authority">
                        <xsl:text>none</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Local Genre</xsl:text>
                    </xsl:attribute>
                    <!--                        <xsl:value-of select=""/> -->
                    <xsl:value-of select="substring-before($lowercaseType, '|')"/>
                </genre>
                <!--                </xsl:if> -->
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-type">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ############################ -->

    <xsl:template name="tokenize-format">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>

        <xsl:choose>
            <!-- DONE add when routine trapping "min." | "sec." | "hour", add displayLabel="Duration" -->
            <xsl:when test="contains(text(), '|Duration')">
                <extent>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                </extent>
            </xsl:when>
            <xsl:when test="contains(text(), '|File_Size')">
                <extent>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    <xsl:text>&#160;kilobytes</xsl:text>
                </extent>
            </xsl:when>
            <xsl:when test="contains(text(), 'MIME_Type') or contains(text(), 'Media_Type')">
                <xsl:variable name="mime" select="substring-before($string, ';')"/>
                <internetMediaType>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                </internetMediaType>
            </xsl:when>
            <xsl:when test="contains($string,'|Text Encoding Schema')">
                <form type="text encoding">
                    <!-- NOMATIVE CODING FOR OUTPUT OF LAST ITEM WHEN RETAINING IN CONTEXT LABEL IS NOT WANTED-->
                    <xsl:value-of
                        select="normalize-space(substring-before(translate($string, ';', ''), '|'))"
                    />
                </form>
            </xsl:when>
            <xsl:when
                test="contains($marccategories, translate(substring-before(normalize-space($string),$delimiter),';',''))">
                <form>
                    <xsl:attribute name="authority">
                        <xsl:text>marccategory</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>MARC Genre Term</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before(normalize-space($string),$delimiter)"/>
                </form>
            </xsl:when>
            <xsl:when
                test="starts-with(substring-before($string,';'), '1') or starts-with(substring-before($string,';'), '2') or starts-with(substring-before($string,';'), '3') or starts-with(substring-before($string,';'), '4') or starts-with(substring-before($string,';'), '5') or starts-with(substring-before($string,';'), '6') or starts-with(substring-before($string,';'), '7') or starts-with(substring-before($string,';'), '8') or starts-with(substring-before($string,';'), '9') or starts-with(substring-before($string,';'), '[')">
                <!-- unfortunately, the variable string2 was added here to get rid of the final semicolon 
Need to find a way to not need this single kludge, pjm -->
                <xsl:variable name="string2" select="substring-before($string, ';')"/>
                <extent>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                </extent>
            </xsl:when>
            <xsl:when test="contains($forms, substring-before($string,';'))">
                <form>
                    <xsl:attribute name="type">
                        <xsl:text>Physical Format</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before($string,';')"/>
                </form>
            </xsl:when>
            <xsl:otherwise>
                <form>
                    <xsl:attribute name="type">
                        <xsl:text>Other</xsl:text>
                    </xsl:attribute>

                    <xsl:variable name="tempstring">
                        <xsl:value-of select="substring-before($string,';')"/>
                    </xsl:variable>
                    <xsl:value-of select="substring-before($tempstring, '|')"/>
                </form>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-format">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ############################ -->
    <!-- depricated 2012-07-11. We use dc:contributor only
    <xsl:template name="tokenize-creator">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        

        <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Creator</xsl:text>
                    </xsl:attribute>
                    <namePart>

            <namePart>
                <xsl:value-of select="substring-before(normalize-space($string),';')"/>
            </namePart>
            <role>
                <roleTerm type="text">Creator</roleTerm>
                <roleTerm/>
                    <xsl:attribute name="authority">
                        <xsl:text>marcrelator</xsl:text>
                    </xsl:attribute>
            </role>
        </name>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-creator">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
 -->

    <!-- ############################ -->
    <xsl:template name="tokenize-contributor">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>

        <!-- Checks whether a certain string is in the dc:contributor field.-->
        <xsl:choose>
            <xsl:when test="contains($string,'uthor')">
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </roleTerm>
                        <roleTerm>
                            <xsl:attribute name="type">
                                <xsl:text>code</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:text>aut</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:when test="contains($string,'ecipient')">
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </roleTerm>
                        <roleTerm>
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:text>rcp</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:when test="contains($string,'epicted')">
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </roleTerm>
                        <roleTerm>
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:text>dpc</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:when test="contains($string,'arrator')">
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </roleTerm>
                        <roleTerm>
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:text>nrt</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:when test="contains($string,'peaker')">
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </roleTerm>
                        <roleTerm>
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:text>spk</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:when test="contains($string,'|ranslator')">
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>dhi-naf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of
                            select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                        />
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                            />
                        </roleTerm>
                        <roleTerm>
                            <xsl:attribute name="authority">
                                <xsl:text>marcrelator</xsl:text>
                            </xsl:attribute>
                            <xsl:text>trn</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <name>
                    <xsl:attribute name="authority">
                        <xsl:text>none</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="displayLabel">
                        <xsl:text>Contributor</xsl:text>
                    </xsl:attribute>
                    <namePart>
                        <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">Contributor</roleTerm>
                    </role>
                </name>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-contributor">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ############################ -->

    <xsl:template name="tokenize-date">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:variable name="newElementName">
            <xsl:value-of select="normalize-space(substring-after(., '|'))"/>
        </xsl:variable>
        <!--        <xsl:choose>
            <xsl:when test="contains($string,'ISO')">
-->
        <xsl:choose>
            <xsl:when
                test="contains(., 'reated') or contains(., 'ssued') or contains(., 'aptured') or contains(., 'alid') or contains(., 'odified')">
                <xsl:element name="date{$newElementName}">
                    <xsl:attribute name="encoding">
                        <xsl:text>iso8601</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <dateOther>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                </dateOther>
            </xsl:otherwise>
        </xsl:choose>
        <!--            </xsl:when>
            <xsl:otherwise>
                <dateOther>
                    <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
                </dateOther>
            </xsl:otherwise>
        </xsl:choose>
            -->

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-date">
                <xsl:with-param name="string"
                    select="normalize-space(substring-after($string, $delimiter))"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- ###################### -->

    <!-- DONE add routine to check $dhiLCSH : Metadata Specialist will provide list of LC headings to add to the CV -->
    <!-- add a way to prevent "India" as a dc:subject from matching "Indiana" in the CV -->
    <xsl:template name="tokenize-subjects-lcsh">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <subject>
            <xsl:if test="contains(text(), '|')">
                <xsl:attribute name="displayLabel">
                    <xsl:value-of
                        select="translate(normalize-space(substring-after(text(), '|')), '_', ' ')"
                    />
                </xsl:attribute>
            </xsl:if>
            <topic>
                <xsl:attribute name="authority">
                    <xsl:text>lcsh</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
            </topic>
        </subject>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-subjects-lcsh">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- ################### -->

    <xsl:template name="tokenize-subjects-keywords">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <subject>
            <topic>
                <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
            </topic>
        </subject>
        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-subjects-keywords">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- ######## EXTENSION ########### -->
    <xsl:template name="tokenize-extension">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:variable name="newElementName">
            <xsl:value-of
                select="translate(normalize-space(substring-after($string, '_')), ';', '')"/>
        </xsl:variable>
        <xsl:element name="dhi:{$newElementName}">
            <xsl:attribute name="displayLabel">
                <xsl:value-of select="$newElementName"/>
            </xsl:attribute>
            <xsl:value-of select="substring-before(normalize-space($string),'|')"/>
        </xsl:element>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-extension">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- ################### -->

    <xsl:template name="tokenize-relation">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>
        <xsl:param name="relationType" select="substring-after(text(),'|')"/>
        <xsl:param name="relationTitle" select="substring-before(text(),'@')"/>
        <xsl:param name="relationUrl" select="substring-after(text(),'@')"/>

        <xsl:choose>
            <xsl:when test="starts-with(text(), 'http')">
                <identifier type="url" access="object in content" usage="primary display">
                    <xsl:attribute name="displayLabel">
                        <xsl:text>MODS metadata</xsl:text>
                    </xsl:attribute>
                    <url>
                        <xsl:value-of select="substring-before(text(),';')"/>
                    </url>
                </identifier>
                <identifer type="uri">
                    <xsl:value-of select="substring-before(text(),';')"/>
                </identifer>
            </xsl:when>
            <xsl:when
                test="contains($hamCollection, normalize-space(substring-before($string,';')))">
                <titleInfo>
                    <title>
                        <xsl:value-of select="normalize-space(substring-before($string,';'))"/>
                    </title>
                </titleInfo>
            </xsl:when>
            <!-- if dc:relation but not a formal Collection -->
            <xsl:otherwise>
                <relatedItem>
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of select="$relationType"/>
                    </xsl:attribute>
                    <titleInfo>
                        <title>
                            <xsl:value-of select="normalize-space($relationTitle)"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of
                                select="normalize-space(substring-before($relationUrl, '|'))"/>
                        </title>
                    </titleInfo>
                </relatedItem>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-relation">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- ############################ -->

    <xsl:template name="tokenize-temporal">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>


        <subject>
            <temporal>
                <xsl:value-of select="substring-before(normalize-space($string),';')"/>
            </temporal>
        </subject>

        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 2">
            <xsl:call-template name="tokenize-temporal">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ###################### -->

    <xsl:template name="tokenize-geographic">
        <xsl:param name="string" select="concat(normalize-space(.),';')"/>

        <!-- Validate string in geographic CV inc file, if not already prevalidated, -->
        <!-- add trap for "region" to "geographic authority="none" dislayLabel="Region"-->
        <geographic>
            <!-- <xsl:value-of select="substring-before(normalize-space($string), $delimiter)"/> -->
            <xsl:value-of select="normalize-space(substring-before($string, '|'))"/>
        </geographic>
        <xsl:if test="string-length(normalize-space(substring-after($string, $delimiter))) > 0">
            <xsl:call-template name="tokenize-geographic">
                <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ############################ -->

</xsl:stylesheet>
