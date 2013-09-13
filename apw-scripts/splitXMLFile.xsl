<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:default="http://www.loc.gov/mods/v3"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">

    <!--   
    This stylesheet splits MODS XML files created by oai-dc2mods.xsl into separate MODS files 
    and names them by targeting the identifier element in the record being exported.
    Requires tha SAXON Extensions be loaded: 
         http://users.breathe.com/mhkay/saxon/saxon5-5-1/extensions.html
    -->
    <!-- INSTRUCTIONS FOR HARVESTING FROM CONTENTdm
        1. Do an OAI harvest of records from CONTENTdm using this OAI call:
        http://elib.hamilton.edu/cgi-bin/oai.exe?verb=ListRecords&metadataPrefix=oai_dc
        2. Save the output file (as displayed in your browser) as "oai.exe.xml" in the same
        folder as the oaidc2mods.xsl transform.
        3. Run oai-dc2mods.xsl on the oai.exe.xml file and type into the "Output" box 
           in oXygen the filename "mods.xml" located in same folder.
        4. Load splitXMLFile.xsl into oXygen and select Saxon6.5.5 at the processor.
        5. Run splitXMLFile.xsl on the mods.xml file (be sure to delete the name "mods.xml" from oXygen's Output: box).
        -->

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <!-- Remove all CRs, line feeds, etc. -->
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:for-each select="/*/*/*[not(. > 3)]">
            <saxon:output href="y:\islandora\cw\xslt\working-area\mods-output-files\{./default:identifier}.xml">
                <xsl:copy-of select="."/>
            </saxon:output>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
