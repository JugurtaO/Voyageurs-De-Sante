<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ci="http://www.ujf-grenoble.fr/l3miage/medical"> 
               
    <xsl:output method="xml" indent="yes" />
    
    
    <xsl:variable name="actes" select="document('../xml/actes.xml')/ngap/actes"/> 
    <xsl:param name="destinedName" >Fréchie</xsl:param>   <!-- nom de l'infirmier associé au patient -->
    <xsl:param name="destinedNameP">Pien</xsl:param>   <!-- nom du patient en question -->
    
    <!-- La racine comportant l'anatomie de notre fichier xml en sortie -->
    <xsl:template match="/">
        
        <patient>
            
            <xsl:apply-templates select="//ci:patients/ci:patient[ci:nom/text()=$destinedNameP]"/>   <!-- récupérer le patient dont le nom passé en param au fichier xsl-->
            
        </patient> 
        
       
        
    </xsl:template>
    
    
    
    
    <xsl:template match="ci:patient">
            
        <nom> 
            <xsl:value-of select="ci:nom/text()" />
        </nom>
        <prenom>
            <xsl:value-of select="ci:prenom/text()" />
        </prenom>
        <sexe>
            <xsl:value-of select="ci:sexe/text()" />
        </sexe>
        
        <naissance>
            <xsl:value-of select="ci:naissance/text()" />
        </naissance>
        <numeroSS>
            <xsl:value-of select="ci:numero/text()" />
        </numeroSS>
        <adresse>
            <xsl:apply-templates select="ci:adresse"/>
        </adresse>
            

       
        <xsl:apply-templates select="ci:visite"/>
    
        
    </xsl:template>
    
    
    
    <xsl:template match="ci:adresse">
        <xsl:apply-templates select="ci:numero"/>
        <rue>
            <xsl:value-of select="ci:rue/text()" />
        </rue>
        <codePostal>
            <xsl:value-of select="ci:codePostal/text()" />
        </codePostal>
        <ville>
            <xsl:value-of select="ci:ville/text()" />
        </ville>
        
    </xsl:template>
<xsl:template match="ci:numero">
    <numero>
        <xsl:value-of select="text()"/> <!-- le numéro étant parfois absent il doit lui-même se conctruire pour n'afficher un élément numéro que s'il a un contenu -->
    </numero>
        
    </xsl:template>


    <xsl:template match="ci:visite">
        
        <xsl:variable name="idInf" select="@intervenant"/> 
        <visite>
            <xsl:attribute name="date"> 
                <xsl:value-of select="@date" />
            </xsl:attribute>
            
            <intervenant>
                
                <nom>
                    <xsl:value-of select="//ci:infirmier[@id=$idInf]/ci:nom/text()" />
                </nom>
                <prenom>
                    <xsl:value-of select="//ci:infirmier[@id=$idInf]/ci:prenom/text()" />
                </prenom>
            </intervenant>
            
            <xsl:apply-templates select="ci:acte"/>
                
          
        </visite>
    
    </xsl:template>
    
    <xsl:template match="ci:acte">
        <xsl:variable name="idC" select="@id" />  <!-- id de l'acte courant -->
        <acte>
            <xsl:value-of select="$actes/acte[@id=$idC]/text()"/>

        </acte>
    </xsl:template>
    
    
    
</xsl:stylesheet>