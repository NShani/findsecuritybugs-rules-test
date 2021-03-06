<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
        <head>
            <style>
                #front-page h1, #front-page h2, #front-page h3, #front-page #info div, #front-page #logo{
                    text-align: center;
                }
                #front-page #info .title{
                    font-weight: 900;
                    padding-right: 5px;
                }
                .item-title {
                    padding-bottom: 20px;
                }
                table {
                    border-collapse: collapse;
                    width: 100%;
                    margin-bottom: 20px;
                }
                table, th, td {
                    border: 1px solid black;
                }
                td {
                    height: 35px;
                    vertical-align: middle;
                    padding: 6px; 
                    white-space: -moz-pre-wrap !important;  /* Mozilla, since 1999 */
                    white-space: -webkit-pre-wrap; /*Chrome  Safari */ 
                    white-space: -pre-wrap;      /* Opera 4-6 */
                    white-space: -o-pre-wrap;    /* Opera 7 */
                    white-space: pre-wrap;       /* css-3 */
                    word-wrap: break-word;       /* Internet Explorer 5.5+ */
                    word-break: break-all;
                    white-space: normal;
                }
                td:first-child {  
                    background-color:#dedede;
                    width: 200px;
                    -webkit-print-color-adjust: exact;
                }
                .item-details {
                    background-color: #E0E0E0;
                    padding: 5px 10px 5px 10px;
                    margin-top: 30px;
                    margin-left: 30px;
                    margin-right: 30px;
                    border-style: dashed;
                    border-width: 2px;
                    font-size: 0.8em;
                    -webkit-print-color-adjust: exact;
                }
                @media print {
                    .break-page { 
                        page-break-after: always;
                        page-break-inside: avoid;
                        -webkit-region-break-inside: avoid;
                    }
                    #front-page #logo {
                        margin-top: 100px;
                    }
                    #front-page #head {
                        margin-top: 100px;
                    }
                    #front-page #info {
                        margin-top: 300px;
                    }
                }
            </style>
        </head>
        <body>
            <div id="front-page">
                <div id="logo">
                    <img src="https://raw.githubusercontent.com/wso2/security-tools/style-sheets/resources/images/wso2-logo.jpg" width="400px" alt="WSO2"/>
                </div>
                <div id="head">
                    <h2>FindSecurityBugs Static Scan Report for <xsl:value-of select="/BugCollection/Project/@projectName"/> </h2>
                    <h2 style="margin-top:50px;">WSO2 Security Assessment</h2>
                </div>
                <div id="info">
                    <div><span class="title">Report Date:</span><span id="report-date"><xsl:value-of select="/BugCollection/@timestamp"/></span></div>
                    <div><span class="title">Email:</span><span>security@wso2.com</span></div>
                </div>
            </div>
            <span class="break-page"></span>
            
            <xsl:for-each select="/BugCollection/BugInstance">
            <div>
                <div class="item-title {@type}">
                    <h3><xsl:value-of select="ShortMessage"/></h3>
                    <div><xsl:value-of select="LongMessage"/></div>
                    <div class="item-details"><xsl:value-of select="/BugCollection/BugPattern[@type=@type]/Details" disable-output-escaping="yes"/></div>
                </div>
                <table>
                    <tr>    
                        <td>Class</td>
                        <td><xsl:value-of select="Class/@classname"/></td>
                    </tr>
                    <tr>    
                        <td>Method</td>
                        <td><xsl:value-of select="Method/@name"/></td>
                    </tr>
                    <tr>    
                        <td>Method Signature</td>
                        <td><xsl:value-of select="Method/@signature"/></td>
                    </tr>
                    <tr>    
                        <td>Code Line</td>
                        <td><xsl:value-of select="SourceLine/@start"/> ...<xsl:value-of select="SourceLine/@end"/></td>
                    </tr>
                    <tr>    
                        <td>Observation</td>
                        <td></td>
                    </tr>
                    <tr>    
                        <td>Comments</td>
                        <td></td>
                    </tr>
                </table>
            </div>
<xsl:if select="/BugCollection/BugInstance">
	<div>

	<h4>Suppressed Vulnerabilities</h4>

	<table>
					    <tr bgcolor="#4682b4">    
					    <td style="width: 115px;"> CVE </td>
						<td style="width: 115px;"> CVE Score </td>
						<td style="width: 115px;"> Severity </td>
						<td>Description </td>
					    </tr>
    					<xsl:for-each select="dc:vulnerabilities/dc:suppressedVulnerability">
    					<xsl:sort select="cvssScore" order="descending"/>
    					<xsl:variable name="mappingNodeSupVul" select="concat('https://cve.mitre.org/cgi-bin/cvename.cgi?name=',name)"/>	

     						<tr>    
    					    <td><a href="{$mappingNodeSupVul}"><xsl:value-of select="name"/></a></td>
    						<td><xsl:value-of select="cvssScore"/></td>
    						<td><xsl:value-of select="severity"/></td>
    					    <td>
    						<xsl:value-of select="description"/>
       						<xsl:variable name="cpe" select="vulnerableSoftware/software"/> 						 
    						    <div class="cpe">
    								<span onclick="openDetailed(this)" class="sum"><xsl:value-of select="$cpe"/></span>
    								<span class="detailed hidden">
    								<xsl:for-each select="vulnerableSoftware/software">
    									<xsl:value-of select="."/> <xsl:text> , </xsl:text>
    								</xsl:for-each>
    								 </span>
    						    </div>
    						</td>
					    </tr>	
					</xsl:for-each>
	</table>
	</div>
</xsl:if>

            </xsl:for-each>

            <script>
                var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                var reportDate = new Date(<xsl:value-of select="/BugCollection/@timestamp"/>);
                var reportDateElement = document.getElementById('report-date');
                reportDateElement.innerHTML = reportDate.getDate() + ' ' + months[reportDate.getMonth()] + ' ' + reportDate.getFullYear() + ' ' + reportDate.getHours() + ':' + reportDate.getMinutes() + ':' + reportDate.getSeconds() ;

                var titles = document.getElementsByClassName('item-title');
                for(var x = 0; x &lt; titles.length; x++) {
                    var colClass = titles[x].className;
                    console.log(colClass.split(' ')[1]);
                    var classedTitles = document.getElementsByClassName(colClass.split(' ')[1]);
                    for(var y = 1; y &lt; classedTitles.length; y++) {
                        classedTitles[y].style.display = 'none'
                    }
                }
            </script>
        </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

