<cfcomponent rest="true" restPath="cliente">  
	<cfinclude template="security.cfm">
	<cfinclude template="util.cfm">

	<cfprocessingDirective pageencoding="utf-8">

	<cffunction name="clienteGet" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset checkAuthentication(state = ['cliente'])>
		 
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	cliente
                WHERE
					1 = 1
				<cfif IsDefined("url.cli_nome") AND url.cli_nome NEQ "">
					AND	cli_nome LIKE <cfqueryparam value = "%#url.cli_nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					cli_id
					,cli_nome
					,cli_cep
					,cli_endereco
					,cli_numero
					,cli_complemento
					,cli_bairro
					,cli_cidade
					,cli_uf
					,cli_tel1
					,cli_tel2
					,cli_tel3
					,cli_tel4
				FROM
					cliente
				WHERE
					1 = 1
				<cfif IsDefined("url.cli_nome") AND url.cli_nome NEQ "">
					AND	cli_nome LIKE <cfqueryparam value = "%#url.cli_nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				ORDER BY
					cli_nome ASC
                
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

</cfcomponent>