<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : pageInfirmiere.xsl
    Created on : 7 novembre 2023, 15:38
    Author     : ourzikj
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    
                
                xmlns:ci="http://www.ujf-grenoble.fr/l3miage/medical">
               
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:param name="destinedId" select="002"/> 
    <xsl:variable name="actes" select="document('../xml/actes.xml')/ngap/actes"/>    
    
    <!-- La racine comportant l'anatomie de notre page html en sortie -->
    <xsl:template match="/">
       
        <html>
            <head>
                <title>pageInfirmiere</title>
                <script src="https://kit.fontawesome.com/1a6c3274b4.js" crossorigin="anonymous"></script>

                
                <link>
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="href">../css/pageInfirmiere.css</xsl:attribute>
                   
                </link>
                <!-- Script pour effectuer le scroll vers les patients depuis la barre de navigation à travers un click sur 'Consultations'-->
                <script>
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <![CDATA[function scrollToConsultations() { 
                    event.preventDefault();
                    const accueil = document.querySelector(".listePatients");
                    accueil.scrollIntoView();
                   
                     }]]>
                </script>
             
                <!--Script inclus qui sera exécuté sur notre document html une fois chargé par le naivgateur et affichera lorsque l'évenement de click  sur le bouton facture soit effectué -->
                <script>
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <![CDATA[function openFacture(prenom, nom, actes) {
                        console.log(actes);
                    
                        var width  = 500;
                        var height = 300;
   if(window.innerWidth) {
       var left = (window.innerWidth-width)/2;
       var top = (window.innerHeight-height)/2;
   }
   else {
       var left = (document.body.clientWidth-width)/2;
       var top = (document.body.clientHeight-height)/2;
   }
   var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
   factureText = "Facture pour : " + prenom + " " + nom +" ------ " + actes 
   factureWindow.document.write(factureText);
   
   
   
   
   
   factureWindow.document.body.style.backgroundColor = "wheat"; 
   
   

}]]>
   
                </script>
            </head>
            
            <body>
                
                <!-- barre de navigation -->
                <nav class="navbar">
                    <ul>
                        <li >
                            <a href="#" class="logo">MON CABINET</a>
                        </li>
                        
                        <ul class="secondNavList">
                            <li >
                                <xsl:attribute name="onclick"> scrollToConsultations() </xsl:attribute>
                                <a href="" >CONSULTATIONS</a>
                            </li>
                            
                            <li > 
                                <a href="#">SERVICES</a> 
                            </li>
                            <li > 
                                <a href="#">CONTACTS</a> 
                            </li>
                        </ul>
                      

                    </ul>
                </nav>

                <!-- Message d'accueil -->
                <div class="accueil">
                    <h3> Les infirmières sont l'hospitalité de l'hôpital</h3>
                    <p>Intégrité, Humanité, Respect, Collaboration <br/> </p>
                </div>
        
                <!-- -->
                <xsl:apply-templates select="ci:cabinet"/>
            </body>
        </html>
    </xsl:template>
    
    <!-- template pour matcher le cabinet étant l'accueil de la page-->
    <xsl:template match="ci:cabinet">
        <div >
            <xsl:attribute name="class">listePatients</xsl:attribute>
            <div class="logo-text">
                <h5>Bonjour <xsl:value-of select="//ci:infirmier[@id=$destinedId]/ci:prenom/text()"/>,</h5> 
                <p>Aujourd'hui, vous avez <xsl:value-of select="count(//ci:patient/ci:visite[@intervenant=$destinedId])"/> patient(s)</p>
                <h5 class="consultations">Consultations du jour : </h5>

            </div>
            
            <xsl:apply-templates select="ci:patients"/>
        </div> 
        
        
    </xsl:template>
    
    <xsl:template match="ci:patients"> 
        
        <div>
            <xsl:attribute name="class">patients</xsl:attribute>
            <xsl:apply-templates select="ci:patient[ci:visite/@intervenant=$destinedId]"/>
        </div>
    </xsl:template>
    
    <!-- Template qui match l'élément Patient et contient les coordonées du patient -->
    <xsl:template match="ci:patient">
        <div class="main">
            <div class="left">
       
                <h3>
                    <xsl:value-of select="concat(ci:nom,' ' )"/> 
                    <xsl:value-of select="ci:prenom"/>
                </h3>
            
                <ul>
                    <li>
                        <xsl:apply-templates select="ci:adresse"/>
                    </li> 
                </ul>
                <xsl:apply-templates select="ci:visite"/>
            
            </div>
            
            <div class="right">
                <img src="../images/patient.jpeg"/>
            </div>
        
        </div>
        
        
      
       
    </xsl:template>
    
    <!-- Affichage de l'adresse du patient sous format standard: N°(de la rue) Rue, codePostal Ville | exemple: 11 rue Maurice Gignoux, 38031 Grenoble -->
    <xsl:template match="ci:adresse">
        <p>Adresse : <xsl:value-of select="ci:numero/text()"/> 
            <xsl:value-of select="concat(' ',ci:rue/text() )"/>, <xsl:value-of select="ci:codePostal/text()"/> 
            <xsl:value-of select="concat(' ',ci:ville/text())"/> 
            <br/>
            <xsl:apply-templates select="ci:etage" />
        </p>
    </xsl:template>
    
    <!-- Création d'une template pour l'élément étage car il n'est pas forcément une donnée obligatoirement renseignée pour tous les patients et cette template l'affiche s'il est présent  -->
    <xsl:template match="ci:etage">
        étage : <xsl:value-of select="text()"/> 
        
    </xsl:template>
    
    
   

    <!-- Content:template -->



    <!-- Ici création de la liste qui contiendra tous les actes du patient-->
    <xsl:template match="ci:visite">
        
        <h4>Actes du patients : </h4>
        <!-- afin d'éviter de remonter dans l'arboresence dans nos chemins XPath, on crée à ce niveau la liste des actes du patient courant sous forme d'un node-set stocké dans la variable actesDuPatient-->

        <xsl:variable name="actesDuPatient" select="ci:acte/@id"/> 
        <xsl:variable name="maChaine" >""</xsl:variable> 
        
        
        <!-- Extraire les id des actes en les concatenants avec la structure foreach -->
       <!-- <xsl:for-each select="ci:acte">
            
            <xsl:variable name="current" select="@id" />
            <xsl:variable name="maChaine" select="concat($maChaine,$current)" />
            
            
        </xsl:for-each>    -->
        
       
          
        <h1> <xsl:copy-of select="$actesDuPatient"/></h1>
        <ul>
            <xsl:apply-templates select="ci:acte"/>
            
            
        </ul>
              
        
        <input> 
            <xsl:variable name="idC" select="ci:acte/@id" />

            <xsl:attribute name="type">button</xsl:attribute>
            <xsl:attribute name="value">Facture</xsl:attribute>
            <xsl:attribute name="onclick"> 
                openFacture(
                '<xsl:value-of select="../ci:prenom"/>',
                '<xsl:value-of select="../ci:nom"/>',
                '<xsl:value-of select="concat($idC,$actes/acte[@id=$idC]/text())"/>') 
            </xsl:attribute>
        </input>
        
        
      
        
    </xsl:template> 
    <!-- Lister les actes correspondants à chaque patient concerné-->
 
   
   
   
   
   
   
   
   
   
   
   


    <xsl:template match="ci:acte">
        <xsl:variable name="idC" select="@id" />
        
        <li>
            <xsl:value-of select="$idC"/> - <xsl:value-of select="$actes/acte[@id=$idC]/text()"/>
            <!-- Ici j'ai supprimé carrément le vocabulaire de actes; en fait il est directement visible via la variable actes tout en haut en lui rajoutant le chemin relatif au fichier actes.xml-->
        </li>
       
   
           
           
       
    </xsl:template>
    
    
    

</xsl:stylesheet>
