<cfcomponent rest="true" restPath="veiculo">  
	<cfinclude template="security.cfm">
	<cfinclude template="util.cfm">

	<cfprocessingDirective pageencoding="utf-8">

	<cffunction name="veiculoGet" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset checkAuthentication(state = ['veiculo'])>
		 
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	vw_veiculo
                WHERE
					1 = 1
				<cfif IsDefined("url.cli_id") AND url.cli_id NEQ "">
					AND	cli_id = <cfqueryparam value = "#url.cli_id#" CFSQLType = "CF_SQL_INTEGER">
				</cfif>
				<cfif IsDefined("url.vei_info") AND url.vei_info NEQ "">
					AND	vei_info LIKE <cfqueryparam value = "%#url.vei_info#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					vei_id
					,vei_info
				FROM
					vw_veiculo
				WHERE
					1 = 1
				<cfif IsDefined("url.cli_id") AND url.cli_id NEQ "">
					AND	cli_id = <cfqueryparam value = "#url.cli_id#" CFSQLType = "CF_SQL_INTEGER">
				</cfif>
				<cfif IsDefined("url.vei_info") AND url.vei_info NEQ "">
					AND	vei_info LIKE <cfqueryparam value = "%#url.vei_info#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				ORDER BY
					vei_info ASC
                
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