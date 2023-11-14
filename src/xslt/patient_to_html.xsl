<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patient_to_html.xsl
    Created on : November 14, 2023, 4:27 PM
    Author     : jugurta
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
     <xsl:variable name="actes" select="document('../xml/actes.xml')/ngap/actes"/>  
    <xsl:template match="/">
        <html>
            <head>
                <title>Fiche_Patient</title>
                <link>
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="href">./patient.css</xsl:attribute>
                   
                </link>
            </head>
            <body>
               
                <div class="main">
                    <xsl:apply-templates select="patient"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="patient">
        <div class="left">
            <h3><xsl:value-of select="concat(nom/text(),' ')"/><xsl:value-of select="prenom/text()"/></h3>
            
            <ul>
               
                <li>Sexe : <xsl:value-of select="sexe/text()"/></li>
                <li>Date de naissance : <xsl:value-of select="naissance/text()"/></li>
                <li>N° de sécurité social: <xsl:value-of select="numeroSS/text()"/></li>
                <li><xsl:apply-templates select="adresse"/></li> <!-- -->
            </ul>
             <xsl:apply-templates select="visite"/>
            
        </div>
            
        <div class="right">
            <img src="patient.jpeg"/>
        </div>
        
        
    </xsl:template>
    <xsl:template match="visite">
        <h4>Vos visites : </h4>
            <table style="border:solid black;">
                <tr>
                <th>Intervenant</th>
                <th>Actes</th>
                <th>Date</th>
                </tr>
                <tr>
                    <td><xsl:value-of select="concat(intervenant/nom/text(),' ')"/><xsl:value-of select="intervenant/prenom/text()"/></td>
                    <td><ul><xsl:apply-templates select="acte"/></ul></td>
                    <td><xsl:value-of select="@date"/></td>
                </tr>
            </table>
    </xsl:template>
    <xsl:template match="acte">
        <li><xsl:value-of select="text()"/></li>
    </xsl:template>
    <xsl:template match="adresse">
        Adresse : <xsl:value-of select="concat(numéro,' ')"/> <xsl:value-of select="rue"/>, <xsl:value-of select="concat(codePostal,' ')"/> <xsl:value-of select="ville"/>  
    </xsl:template>
</xsl:stylesheet>
