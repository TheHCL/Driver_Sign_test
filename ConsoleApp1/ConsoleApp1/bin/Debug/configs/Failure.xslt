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
                 <xsl:with-param name="ReportName">Failure Report</xsl:with-param>
                </xsl:call-template>

                <!--===== Statistics info table =====-->
                <xsl:call-template name="BuildStatisticsInfoSection" />

                <!--===== RunTime info table =====-->
                <xsl:call-template name="BuildRuntimeInfoSection" />

                <!--===== Report Details table =====-->                                
                <xsl:call-template name="BuildReportDetailsHeader">
                 <xsl:with-param name="ReportDescription">Test Cases</xsl:with-param>
                </xsl:call-template>
			
		<!--===== Render results =====-->
                <table border="0" width="100%">
                 <tbody>
                  <tr>
                   <th class="MsgHeader" colspan="2">Title</th>
                   <th class="MsgHeader" WIDTH="10%">Result</th>
                  </tr>
                  <xsl:apply-templates select="StartTest" mode="filter" />
                 </tbody>
                </table>

	    </body>
            <xsl:call-template name="BuildClientScripts" />
	</xsl:template>
	
	<!--===== Templates=====-->
        <xsl:template match="StartTest" mode="filter">
         <xsl:variable name="ID" select="generate-id(.)" />
         <xsl:variable name="ctx" select="ctx/@id" />
         <xsl:variable name="Title" select="@Title" />
         <xsl:variable name="TUID">
          <xsl:choose>
           <xsl:when test="@TUID &gt; 0"><xsl:value-of select="concat('TUID: ',@TUID,' - ')" /></xsl:when>
           <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
         </xsl:variable>
         <xsl:variable name="Result">
          <xsl:choose>
           <xsl:when test="string-length($TUID) &gt; 0"><xsl:value-of select="following-sibling::EndTest[ctx/@id=$ctx and @TUID=$TUID]/@Result" /></xsl:when>
           <xsl:otherwise><xsl:value-of select="following-sibling::EndTest[ctx/@id=$ctx and @Title=$Title]/@Result" /></xsl:otherwise>
          </xsl:choose>
         </xsl:variable>
         <xsl:variable name="ResultClass" select="concat('EndTestData',substring($Result,1,4))" />
	 <xsl:variable name="Position" select="position()" />
         <xsl:if test="contains($Result,'Fail')">
          <tr>
           <td class="MsgData" width="80%" colspan="2">
              <INPUT>
               <xsl:attribute name="value"  > + <xsl:value-of select="concat($TUID,@Title)" /></xsl:attribute>
               <xsl:attribute name="title"  >Click to expand and show details</xsl:attribute>
               <xsl:attribute name="onclick">ToggleVisibility(this)</xsl:attribute>
               <xsl:attribute name="type"   >button</xsl:attribute>
               <xsl:attribute name="name"   ><xsl:value-of select="concat('button',$Position)"/></xsl:attribute>
              </INPUT>
           </td>
           <xsl:choose>
            <xsl:when test="contains($Result,'Pass')"><td class="{$ResultClass}">Passed</td></xsl:when>
            <xsl:when test="contains($Result,'Fail')"><td class="{$ResultClass}">Failed</td></xsl:when>
            <xsl:when test="contains($Result,'Warn')"><td class="{$ResultClass}">Warning</td></xsl:when>
            <xsl:when test="contains($Result,'Bloc')"><td class="{$ResultClass}">Blocked</td></xsl:when>
            <xsl:when test="contains($Result,'Skip')"><td class="{$ResultClass}">Skipped</td></xsl:when>
            <xsl:otherwise><td class="MsgData">Unknown</td></xsl:otherwise>
           </xsl:choose>
          </tr>
          <tr>
           <td width="5%"></td>
           <td width="95%" colspan="2">
            <xsl:element name="DIV">
             <xsl:attribute name="ID"   ><xsl:value-of select="concat('div',$Position)"/></xsl:attribute>
             <xsl:attribute name="style">DISPLAY: NONE</xsl:attribute>
             <!--
                  Apply templates for self (StartTest), and then all subsequent elements which are NOT StartTest or EndTest, 
                  as long as their preceding StartTest sibling is the same StartTest we are displaying results for. 
             -->
             <xsl:apply-templates select="self::*" />
             <xsl:apply-templates select="following-sibling::*[local-name() != 'StartTest' and local-name() != 'EndTest'][ctx/@id=$ctx][generate-id(preceding-sibling::StartTest[1])=$ID]" />
             <xsl:apply-templates select="following-sibling::EndTest[ctx/@id=$ctx][@Title=$Title][1]" />
            </xsl:element>
           </td>
          </tr>
         </xsl:if>
        </xsl:template>

</xsl:stylesheet>
