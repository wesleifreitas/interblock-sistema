<cfcomponent rest="true" restPath="/boleto">  
	<cfinclude template="security.cfm">
	<cfinclude template="util.cfm">
	<cfinclude template="boleto_module/funcoesBoleto.cfm">

	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cffunction name="boleto" access="remote" returntype="String" httpmethod="GET" restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>

		<cfset response = structNew()>
		<cfset response["params"] = url>
		
		<cftry>
            <cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "/../_files/temp/boleto">
            <cfif not directoryExists(destination)>
                <cfdirectory action="create" directory="#destination#" />		
            </cfif>

            <cfset guid = CreateUUID()>
			<cfset filename = destination & "/boleto_" & guid & ".pdf">

			
  			<!--- agencia, conta, nossonumero --->
			<cfset numeroChave = chave(100, 6001342, 123456)>	
			<!--- vencimento, valor, numeroChave --->
			<cfset codBar = codigoBarra("30/07/2005", 98.00, numeroChave)>
			<cfset linha = linhaDigitavel(numeroChave, codBar)>

			
            <cfdocument format = "PDF" 
		 	 			filename = "#filename#" 
		 	 			overwrite = "yes" 
						> 
                        
                       <cfmodule 
							template="boleto_module/layoutboleto.cfm" 
							dataProcessamento="#LSDateFormat(now(),'DD/MM/YYYY')#" 
							dataDocumento="#LSDateFormat(now(),'DD/MM/YYYY')#" 
							dataVencimento="08/05/1990"
							dataVencimentoCliente="#LSDateFormat(now(),'DD/MM/YYYY')#"  
							nDocumento="1234567" 
							agencia="100" 
							conta="6001342" 
							valor="98.00" 
							instrucao="COBRAR MULTA DE 2,00% SOBRE O VALOR DO TITULO APOS VENCIMENTO.<BR>NAO DISPENSAR JUROS DE MORA. JUROS DE 2,00 AO MES(%)<BR><BR>** OBS.: ESTE BLOQUETO PERDE A VALIDADE APOS 60 DIAS DO VENCTO **<BR>** BOLETO DO MES <FONT SIZE='2'>#LSDateFormat(now(),'DD/MM/YYYY')#</FONT>  REFERENTE A <FONT SIZE='2'><U>TAXA DE LIMPEZA E SEGURAN�A</U></FONT> **" 
							nomeSacado="Nome" 
							enderecoSacado="<b>Endereco</b>" 
							chave="#numeroChave#" 
							codigoBarra="#codBar#" 
							linhaDigitavel="#linha#">	
						<!--- <cfinclude template=""> --->
						 										 	
			</cfdocument>

            <cffile  
                action = "readBinary"  
                file = "#filename#" 
                variable = "binary">

            <cfset response["base64"] = toBase64(binary)>

			<cffile  
                action = "delete"  
                file = "#filename#">

			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>
</cfcomponent>