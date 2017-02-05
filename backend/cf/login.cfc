<cfcomponent rest="true" restPath="/login">  

    <cfprocessingDirective pageencoding="utf-8">
    <cfset setEncoding("form","utf-8")> 
    
	<cfinclude template="util.cfm">

	<cffunction name="login" access="remote" returnType="String" httpMethod="POST">
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>

        <cfset response = structNew()>
		<cfset response["body"] = body>
        <cfset response["params"] = url>

        <cfset myQuery = QueryNew("user_id, user_name, user_password", "VarChar, VarChar, VarChar")> 
        <cfset newRow = QueryAddRow(MyQuery, 2)> 

        <cfset temp = QuerySetCell(myQuery, "user_id", "1", 1)> 
        <cfset temp = QuerySetCell(myQuery, "user_name", "admin", 1)> 
        <cfset temp = QuerySetCell(myQuery, "user_password", hash("admin", "SHA-512"), 1)>

        <cfset temp = QuerySetCell(myQuery, "user_id", "21", 2)> 
        <cfset temp = QuerySetCell(myQuery, "user_name", "user", 2)> 
        <cfset temp = QuerySetCell(myQuery, "user_password", hash("123", "SHA-512"), 2)>

        <cfquery dbtype="query" name="qLogin">  
            SELECT 
                user_id
                ,user_name
                ,user_password 
            FROM 
                myQuery 
            WHERE 
                user_name = <cfqueryparam value="#body.username#" cfsqltype="cf_sql_varchar">
            AND user_password = <cfqueryparam value="#hash(body.password, 'SHA-512')#" cfsqltype="cf_sql_varchar">
        </cfquery> 

        <cfif qLogin.recordCount GT 0>
            <cfset response["success"] = true>
            <cfset response["message"] = "">
            <cflock timeout="20" throwontimeout="No" type="EXCLUSIVE" scope="session">
                <cfset session.authenticated = true>					
                <cfset session.userId = qLogin.user_id>
                <cfset session.userName = qLogin.user_name>                                
            </cflock>
            <cfset response["session"] = session>
        <cfelse>
            <cfset response["success"] = false>
            <cfset response["message"] = "Usuário e/ou senha incorreto(s)">
        </cfif>

        <cfset response["query"] = queryToArray(qLogin)>
		
     
		<cfreturn SerializeJSON(response)>
	</cffunction>
    
    <cffunction name = "authenticated" access ="remote" returntype ="String" httpMethod="GET">

        <cfset response = structNew()>

        <cfif StructKeyExists(session, "authenticated") AND session.authenticated>	
            <cfset response["authenticated"] = true>
        <cfelse>    
            <cfset response["authenticated"] = false>
        </cfif>

        <cfreturn SerializeJSON(response)>
    </cffunction>
</cfcomponent>