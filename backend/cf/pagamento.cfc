<cfcomponent rest="true" restPath="/pagamento">  
	<cfinclude template="security.cfm">
	<cfinclude template="util.cfm">

	<cffunction name="postPagamento" access="remote" returnType="String" httpMethod="POST" restPath="/post">
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = body>
		<cfset response["message"] = 'Ação realizada com sucesso!'>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="pagamento" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                    dbo.vw_pagamento
                WHERE
                    1 = 1
                <cfif IsDefined("url.cpf") AND url.cpf NEQ "">
                    AND	cli_cpfCnpj = <cfqueryparam value = "#url.cpf#" CFSQLType = "CF_SQL_VARCHAR">
                </cfif>
                <cfif IsDefined("url.cliente") AND url.cliente NEQ "">
                    AND	cli_nome COLLATE Latin1_general_CI_AI LIKE <cfqueryparam value = "%#url.cliente#%" CFSQLType = "CF_SQL_VARCHAR">
                </cfif>
                <cfif IsDefined("url.ano") AND IsNumeric(url.ano)>
                    AND	pag_data_vencimento_ano = <cfqueryparam value = "#url.ano#" CFSQLType = "CF_SQL_NUMERIC">
                </cfif>
                <cfif IsDefined("url.mes") AND IsNumeric(url.mes)>
                    AND	pag_data_vencimento_mes = <cfqueryparam value = "#url.mes#" CFSQLType = "CF_SQL_NUMERIC">
                </cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                    pag_id
                    ,pag_data_vencimento_mes
                    ,pag_data_vencimento_ano
                    ,pag_status
                    ,pag_data_vencimento
                    ,cli_nome
                    ,cli_cpfCnpj
                    ,prop_numero
                    ,cli_arquivo
                    ,pag_valor
                    ,pag_valor_pago
                FROM
                    dbo.vw_pagamento
                WHERE
                    1 = 1
                <cfif IsDefined("url.cpf") AND url.cpf NEQ "">
                    AND	cli_cpfCnpj = <cfqueryparam value = "#url.cpf#" CFSQLType = "CF_SQL_VARCHAR">
                </cfif>
                <cfif IsDefined("url.cliente") AND url.cliente NEQ "">
                    AND	cli_nome COLLATE Latin1_general_CI_AI LIKE <cfqueryparam value = "%#url.cliente#%" CFSQLType = "CF_SQL_VARCHAR">
                </cfif>
                <cfif IsDefined("url.ano") AND IsNumeric(url.ano)>
                    AND	pag_data_vencimento_ano = <cfqueryparam value = "#url.ano#" CFSQLType = "CF_SQL_NUMERIC">
                </cfif>
                <cfif IsDefined("url.mes") AND IsNumeric(url.mes)>
                    AND	pag_data_vencimento_mes = <cfqueryparam value = "#url.mes#" CFSQLType = "CF_SQL_NUMERIC">
                </cfif>

                ORDER BY
                    pag_data_vencimento ASC
                    ,cli_nome ASC
                
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

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    pag_id
                    ,pag_data_vencimento_mes
                    ,pag_data_vencimento_ano
                    ,pag_status
                    ,pag_data_vencimento
                    ,cli_nome
                    ,cli_cpfCnpj
                    ,prop_numero
                    ,cli_arquivo
					,pag_valor
					,pag_valor_juros
					,pag_valor_pago
					,pag_valor_pendente
					,pag_data_pago
                FROM
                    dbo.vw_pagamento
                WHERE
                    pag_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="pagamentoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="pagamentoUpdate" access="remote" returnType="String" httpMethod="PUT" restPath="/{id}">
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
					dbo.pagamento  
				SET 
					pag_status = <cfqueryparam value = "#arguments.body.pag_status#" CFSQLType = "CF_SQL_NUMERIC">,
					pag_valor_juros = <cfqueryparam value = "#arguments.body.pag_valor_juros#" CFSQLType = "CF_SQL_FLOAT">,
					pag_valor_pago = <cfqueryparam value = "#arguments.body.pag_valor_pago#" CFSQLType = "CF_SQL_FLOAT">,
					pag_valor_pendente = <cfqueryparam value = "#arguments.body.pag_valor_pendente#" CFSQLType = "CF_SQL_FLOAT">,
					pag_data_pago = <cfqueryparam value = "#ISOToDateTime(arguments.body.pag_data_pago)#" CFSQLType = "CF_SQL_DATE">
				WHERE 
					pag_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
  			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="pagamentoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="pagamentoRemoveById" access="remote" returnType="String" httpMethod="DELETE" restPath="/{id}">
		<cfargument name="id" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

</cfcomponent>