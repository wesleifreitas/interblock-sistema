<cfcomponent rest="true" restPath="usuario">  
	<cfinclude template="security.cfm">
	<cfinclude template="util.cfm">

	<cffunction name="usuario" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset checkAuthentication()>
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
					COUNT(*) AS COUNT
				FROM
					vw_usuario
				WHERE
				1 = 1
				<cfif IsDefined("url.nome") AND url.nome NEQ "">
					AND usu_nome LIKE <cfqueryparam value = "%#url.nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>     
				<cfif IsDefined("url.login") AND url.login NEQ "">
					AND usu_login = <cfqueryparam value = "#url.login#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif IsDefined("url.cpf") AND url.cpf NEQ "">
					AND usu_cpf = <cfqueryparam value = "#url.cpf#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif not session.perfilDeveloper>
					AND per_developer <> 1
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					usu_id
					,usu_nome
					,usu_login
					,usu_cpf
					,per_nome
					,usu_ativo_label
					,usu_ultimoAcesso
				FROM
					vw_usuario
				WHERE
					1 = 1
			<cfif IsDefined("url.nome") AND url.nome NEQ "">
					AND usu_nome LIKE <cfqueryparam value = "%#url.nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>     
				<cfif IsDefined("url.login") AND url.login NEQ "">
					AND usu_login = <cfqueryparam value = "#url.login#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif IsDefined("url.cpf") AND url.cpf NEQ "">
					AND usu_cpf = <cfqueryparam value = "#url.cpf#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif not session.perfilDeveloper>
					AND per_developer <> 1
				</cfif>

				ORDER BY
					usu_nome ASC
                
                <!--- Paginação --->
                OFFSET #URL.page * URL.limit - URL.limit# ROWS
                FETCH NEXT #URL.limit# ROWS ONLY;
            </cfquery>
		
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>


		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    usu_id
                    ,usu_nome
                    ,usu_login
                    ,usu_cpf
                    ,usu_email
                    ,per_id
                    ,per_nome
                    ,usu_ativo
                    ,usu_ativo_label
                    ,usu_mudarSenha
                    ,usu_ultimoAcesso
                FROM
                    vw_usuario
                WHERE
                    usu_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn SerializeJSON(response)>
    </cffunction>
	
	<cffunction name="usuarioCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>			
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.usuario
				(                   
					usu_ativo
					,per_id
					,usu_login
					,usu_senha
					,usu_nome
					,usu_email
					,usu_cpf                
					,usu_senhaExpira
					,usu_mudarSenha
					,usu_tentativasLogin
					,usu_countTentativasLogin            
				) 
				VALUES (
					<cfqueryparam value = "#body.statusSelected#" CFSQLType = "CF_SQL_TINYINT">
					,<cfqueryparam value = "#body.perfil.id#" CFSQLType = "CF_SQL_BIGINT">
					,<cfqueryparam value = "#body.login#" CFSQLType = "CF_SQL_VARCHAR">
					,<cfqueryparam value = "#hash(body.senha, 'SHA-512')#" CFSQLType = "CF_SQL_VARCHAR">
					,<cfqueryparam value = "#body.nome#" CFSQLType = "CF_SQL_VARCHAR">
					,<cfqueryparam value = "#body.email#" CFSQLType = "CF_SQL_VARCHAR">
					,<cfqueryparam value = "#body.cpf#" CFSQLType = "CF_SQL_VARCHAR">
					,<cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">
					,<cfqueryparam value = "#body.senhaModificar#" CFSQLType = "CF_SQL_BIT">
					,<cfqueryparam value = "999" CFSQLType = "CF_SQL_INTEGER">
					,<cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">
				);  
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Usuário criado com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="usuarioUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{id}">
		
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfargument name="body" type="String">

		<cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.usuario  
				SET 
					usu_ativo = <cfqueryparam value = "#body.statusSelected#" CFSQLType = "CF_SQL_TINYINT">
					,per_id = <cfqueryparam value = "#body.perfil.id#" CFSQLType = "CF_SQL_BIGINT">
					,usu_login = <cfqueryparam value = "#body.login#" CFSQLType = "CF_SQL_VARCHAR">
					<cfif body.senhaChange>
						,usu_senha = <cfqueryparam value = "#hash(body.senha, 'SHA-512')#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif>
					,usu_nome = <cfqueryparam value = "#body.nome#" CFSQLType = "CF_SQL_VARCHAR">
					,usu_email = <cfqueryparam value = "#body.email#" CFSQLType = "CF_SQL_VARCHAR">
					,usu_cpf = <cfqueryparam value = "#body.cpf#" CFSQLType = "CF_SQL_VARCHAR">
					,usu_senhaExpira = <cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">
					,usu_mudarSenha = <cfqueryparam value = "#body.senhaModificar#" CFSQLType = "CF_SQL_BIT">
					,usu_tentativasLogin = <cfqueryparam value = "999" CFSQLType = "CF_SQL_INTEGER">
					,usu_countTentativasLogin = <cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">
				WHERE 
					usu_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">  				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Usuário atualizado com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="usuarioRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
                        dbo.usuario 
                    WHERE 
                        usu_id = <cfqueryparam value = "#i.usu_id#" CFSQLType = "CF_SQL_BIGINT">					
				</cfquery>
			</cfloop>			

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="usuarioRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{id}"
		>
		
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfset checkAuthentication()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
                    dbo.usuario 
                WHERE 
                    usu_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_BIGINT">    
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Usuário removido com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="jsTreeCedente" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{usuario}/{grupo}"> 

		<cfargument name="usuario" restargsource="Path" type="numeric"/>
		<cfargument name="grupo" restargsource="Path" type="numeric"/>		
        
		<cfset checkAuthentication()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="qCedente">
				SELECT
					grupo.grupo_id
					,grupo.grupo_nome
											
					,(SELECT 
							COUNT(1) 
						FROM 
							dbo.usuario_grupo AS usuario_check 
						WHERE 
							usuario_check.grupo_id = grupo.grupo_id
						AND usuario_check.per_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.usuario#">
						AND grupo_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.grupo#">
					) AS grupo_check    
				FROM
					dbo.grupo AS grupo

				<!--- Cedentes específicos --->
				<!---
					LEFT OUTER JOIN dbo.usuario_grupo AS  usuario_grupo
					ON grupo.grupo_id = usuario_grupo.grupo_id
					AND grupo.grupo_NR_INST = usuario_grupo.grupo_id

					WHERE grupo_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.usuario_grupo#" list="true">)					
					AND grupo_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.grupo#">
				--->
				<!--- Todos os grupos --->
					WHERE grupo_NR_INST = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.grupo#">
				
				ORDER BY
					grupo_nome
			</cfquery>
			
			<cfscript>			
				var jstree = structNew();
				var plugins = arrayNew(1);
				var data = arrayNew(1);
				var dataObj = structNew();

				arrayAppend(plugins, "wholerow");
				arrayAppend(plugins, "checkbox");

				for(item in qCedente) {
					dataObj = structNew();
					dataObj["id"] = item.grupo_id;
					dataObj["text"] = item.grupo_nome;
					dataObj["state"]["selected"] = item.CEDENTE_CHECK;
					arrayAppend(data, dataObj);
				}
				/*
				dataObj["text"] = "Teste";
				dataObj["children"] = [{"text": "Teste selected"},{"state":{"selected": true}}];

				arrayAppend(data, dataObj);			
				*/
			
				jstree["plugins"] = plugins;
				jstree["core"]["themes"] = {"name": "proton", "responsive": true};
				jstree["core"]["data"] = data;
			</cfscript>		
			
			<cfset response["qCedente"] = QueryToArray(qCedente)>
			<cfset response["jstree"] = jstree>
			<cfset response["success"] = true>
			
			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		
		</cftry>

		<cfreturn SerializeJSON(response)>
    </cffunction>

</cfcomponent>