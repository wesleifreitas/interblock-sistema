<cfcomponent rest="true" restPath="ordem-servico">  
	<cfinclude template="security.cfm">
	<cfinclude template="util.cfm">

	<cffunction name="ordemServicoGet" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset checkAuthentication(state = ['ordem-servico'])>
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
					COUNT(*) AS COUNT
				FROM
					vw_ordem_servico
				WHERE
				1 = 1
				<cfif IsDefined("url.os_status") AND url.os_status NEQ "">
					AND os_status = <cfqueryparam value = "#url.os_status#" CFSQLType = "CF_SQL_TINYINT">
				</cfif>
				<cfif IsDefined("url.cli_nome") AND url.cli_nome NEQ "">
					AND cli_nome LIKE <cfqueryparam value = "%#url.cli_nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>    
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                    os_id
                    ,os_status
                    ,os_numero
					,os_valor
					,os_valor
					,os_data
                    ,cli_nome
                    ,cli_arquivo
                    ,vei_info
                FROM
                    vw_ordem_servico
				WHERE
					1 = 1
				<cfif IsDefined("url.os_status") AND url.os_status NEQ "">
					AND os_status = <cfqueryparam value = "#url.os_status#" CFSQLType = "CF_SQL_TINYINT">
				</cfif>
			   	<cfif IsDefined("url.cli_nome") AND url.cli_nome NEQ "">
					AND cli_nome LIKE <cfqueryparam value = "%#url.cli_nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>     

				ORDER BY
					os_status ASC
					,os_data ASC
                
                <!--- Paginação --->
                OFFSET #URL.page * URL.limit - URL.limit# ROWS
                FETCH NEXT #URL.limit# ROWS ONLY;
            </cfquery>
		
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="ordemServicoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['ordem-servico'])>


		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					os_id
					,os_numero
                    ,os_status
					,os_valor
					,os_data
					,cli_id
					,vei_id
					,os_cep
					,os_endereco
					,os_numero_endereco
					,os_complemento
					,os_bairro
					,os_cidade
					,os_uf
					,os_tel1
					,os_tel2
					,os_responsavel
					,os_id
					,grupo_id   
					,cli_nome
					,vei_info 
                FROM
                    vw_ordem_servico
                WHERE
                    os_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn SerializeJSON(response)>
    </cffunction>
	
	<cffunction name="ordemServicoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['ordem-servico'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>			
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.ordem_servico
				(                   
					os_status
					,os_valor
					,os_data
					,cli_id
					,vei_id
					,os_cep
					,os_endereco
					,os_numero_endereco
					,os_complemento
					,os_bairro
					,os_cidade
					,os_uf
					,os_tel1
					,os_tel2
					,os_responsavel
					,usu_id
					,grupo_id           
				) 
				VALUES (
					<cfqueryparam value = "#body.os_status#" CFSQLType = "CF_SQL_TINYINT">
					<cfqueryparam value = "#body.os_valor#" CFSQLType = "CF_SQL_FLOAT">
					,GETDATE()
					,<cfqueryparam value = "#body.cliente.cli_id#" CFSQLType = "CF_SQL_INTEGER">					
					,<cfqueryparam value = "#body.veiculo.vei_id#" CFSQLType = "CF_SQL_INTEGER">					
					,<cfqueryparam value = "#body.os_cep#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_endereco#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_numero_endereco#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_complemento#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_bairro#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_cidade#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_uf#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_tel1#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_tel2#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#body.os_responsavel#" CFSQLType = "CF_SQL_VARCHAR">					
					,<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_INTEGER">					
					,<cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_INTEGER">					
				);  
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ordem de serviço criado com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="ordemServicoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{id}">
		
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['ordem-servico'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.ordem_servico  
				SET 
					os_status = <cfqueryparam value = "#body.os_status#" CFSQLType = "CF_SQL_TINYINT">
					,os_valor = <cfqueryparam value = "#body.os_valor#" CFSQLType = "CF_SQL_FLOAT">
					,cli_id = <cfqueryparam value = "#body.cliente.cli_id#" CFSQLType = "CF_SQL_INTEGER">					
					,vei_id = <cfqueryparam value = "#body.veiculo.vei_id#" CFSQLType = "CF_SQL_INTEGER">					
					,os_cep = <cfqueryparam value = "#body.os_cep#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_endereco = <cfqueryparam value = "#body.os_endereco#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_numero_endereco = <cfqueryparam value = "#body.os_numero_endereco#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_complemento = <cfqueryparam value = "#body.os_complemento#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_bairro = <cfqueryparam value = "#body.os_bairro#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_cidade = <cfqueryparam value = "#body.os_cidade#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_uf = <cfqueryparam value = "#body.os_uf#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_tel1 = <cfqueryparam value = "#body.os_tel1#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_tel2 = <cfqueryparam value = "#body.os_tel2#" CFSQLType = "CF_SQL_VARCHAR">					
					,os_responsavel = <cfqueryparam value = "#body.os_responsavel#" CFSQLType = "CF_SQL_VARCHAR">					
					,usu_id = <cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_INTEGER">					
					,grupo_id = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_INTEGER">
				WHERE 
					os_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">  				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ordem de serviço atualizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="ordemServicoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['ordem-servico'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
                        dbo.ordem_servico 
                    WHERE 
                        os_id = <cfqueryparam value = "#i.os_id#" CFSQLType = "CF_SQL_BIGINT">					
				</cfquery>
			</cfloop>			

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="ordemServicoRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{id}"
		>
		
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfset checkAuthentication(state = ['ordem-servico'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
                    dbo.ordem_servico 
                WHERE 
                    os_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_BIGINT">    
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ordem de serviço removida com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="pdf" access="remote" returntype="String" httpmethod="GET" restpath="/pdf/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>

		<cfset response = structNew()>
		<cfset response["params"] = url>
		
		<cftry>
            <cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "/../_server/temp/ordem-servico">
            <cfif not directoryExists(destination)>
                <cfdirectory action="create" directory="#destination#" />		
            </cfif>

            <cfset guid = CreateUUID()>
			<cfset filename = destination & "/ordem_servico_" & guid & ".pdf">

			<cfset template = application.ROOT & "ordem-servico-template.cfm">
            <cfdocument format = "PDF" 
		 	 			filename = "#filename#" 
		 	 			overwrite = "yes" 
						> 
                
				<cfinclude template="ordem-servico-template.cfm">
						 										 	
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