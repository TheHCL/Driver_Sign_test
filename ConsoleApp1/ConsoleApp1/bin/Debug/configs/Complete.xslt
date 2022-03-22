<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:user="http://mycompany.com/mynamespace"
		version="1.0">
    <xsl:output method="html" indent="yes"/>

    <xsl:include href="WTTXSLTCSS.xslt" />
    <xsl:include href="SharedTraceLogging.dat" />

	<xsl:template match="WTT-Logger">
	    <body>
                <!--===== Header table =====-->
                <xsl:call-template name="BuildReportHeader">
                 <xsl:with-param name="ReportName">Complete Report</xsl:with-param>
                </xsl:call-template>

                <!--===== Statistics info table =====-->
                <xsl:call-template name="BuildStatisticsInfoSection" />

                <!--===== RunTime info table =====-->
                <xsl:call-template name="BuildRuntimeInfoSection" />

                <!--===== Report Details table =====-->                                
                <xsl:call-template name="BuildReportDetailsHeader">
                 <xsl:with-param name="ReportDescription">Complete Test Log</xsl:with-param>
                </xsl:call-template>

		<!--===== Render results =====-->
		<xsl:apply-templates />

	    </body>
            <xsl:call-template name="BuildClientScripts" />
	</xsl:template>
	
</xsl:stylesheet>
