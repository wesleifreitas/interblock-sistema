<cfcomponent rest="true" restPath="/example">  
	<cfinclude template="util.cfm">
	
	<cffunction name="sayHello" access="remote" returntype="String" httpmethod="GET" restPath="/hello"> 
        <cfset rest = "Hello World"> 
        <cfreturn rest> 
    </cffunction>

	<cffunction name="postExample" access="remote" returnType="String" httpMethod="POST" restPath="/post">
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = body>
		<cfset response["message"] = 'Ação realizada com sucesso!'>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="example" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfset rows = URL.limit>
			<cfset myQuery = QueryNew("_id, nome, cpf, data, bateria, status", "bigint, varchar, varchar, date, integer, integer")> 
			<cfset newRow = QueryAddRow(MyQuery, rows)> 
			
			<cfloop from="1" to="#rows#" index="i">
				
				<cfset temp = QuerySetCell(myQuery, "_id", i, i)> 
				<cfset temp = QuerySetCell(myQuery, "nome", "Weslei Freitas | Page:" & URL.page, i)> 
				<cfset temp = QuerySetCell(myQuery, "cpf", '39145592845', i)>
				<cfset temp = QuerySetCell(myQuery, "data", now(), i)>
				<cfset temp = QuerySetCell(myQuery, "bateria", 1, i)>
				<cfset temp = QuerySetCell(myQuery, "status", 1, i)>

			</cfloop>

			<cfquery dbtype="query" name="query">  
				SELECT 
					_id
					,nome
					,cpf
					,data
					,bateria
					,status 
				FROM 
					myQuery
				WHERE
				1 = 1
				<cfif IsDefined("url.id") AND url.id NEQ "">
					AND	_id = <cfqueryparam value = "#url.id#" CFSQLType = "CF_SQL_INTEGER">
				</cfif>

				<cfif IsDefined("url.nome") AND url.nome NEQ "">
					AND	nome = <cfqueryparam value = "#url.nome#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>
			</cfquery>
			
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = 100>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset response["catch"] = cfcatch>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
        
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cfset rows = 100>
		<cfset myQuery = QueryNew("_id, nome, cpf, data, bateria, status", "bigint, varchar, varchar, date, integer, integer")> 
        <cfset newRow = QueryAddRow(MyQuery, rows)> 
		
		<cfloop from="1" to="#rows#" index="i">
			
			<cfset temp = QuerySetCell(myQuery, "_id", i, i)> 
			<cfset temp = QuerySetCell(myQuery, "nome", "Weslei Freitas", i)> 
			<cfset temp = QuerySetCell(myQuery, "cpf", '39145592845', i)>
			<cfset temp = QuerySetCell(myQuery, "data", now(), i)>
			<cfset temp = QuerySetCell(myQuery, "bateria", 1, i)>
			<cfset temp = QuerySetCell(myQuery, "status", 1, i)>

		</cfloop>

		<cfquery dbtype="query" name="query">  
            SELECT 
                _id
                ,nome
                ,cpf
				,data
				,bateria
				,status 
            FROM 
            	myQuery
			WHERE
				_id = <cfqueryPARAM value="#arguments.id#" CFSQLType='CF_SQL_INTEGER'>  
        </cfquery>
		
		<cfset response["query"] = queryToArray(query)>

		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="exampleCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="exampleUpdate" access="remote" returnType="String" httpMethod="PUT" restPath="/{id}">
		<cfargument name="id" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="exampleRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfset response["success"] = true>			

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="exampleRemoveById" access="remote" returnType="String" httpMethod="DELETE" restPath="/{id}">
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

</cfcomponent>
