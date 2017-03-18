<cfcomponent rest="true" restPath="/">  

    <cfprocessingDirective pageencoding="utf-8">
    <cfset setEncoding("form","utf-8")> 
    
	<cfinclude template="util.cfm">

	<cffunction name="login" access="remote" returnType="String" httpMethod="POST" restPath="/login">
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(arguments.body)>

        <cfif not IsDefined("body.setSession")>
            <cfset body.setSession = true>
        </cfif>

        <cfset response = structNew()>
		<cfset response["body"] = body>
        <cfset response["params"] = url>

        <cfquery datasource="#application.datasource#" name="qLogin">  
            SELECT 
                usu_id
                ,usu_nome
                ,usu_senha 
            FROM 
                dbo.usuario 
            WHERE 
                usu_login = <cfqueryparam value="#body.username#" cfsqltype="cf_sql_varchar">
            AND usu_senha = <cfqueryparam value="#hash(body.password, 'SHA-512')#" cfsqltype="cf_sql_varchar">
        </cfquery> 

        <cfif qLogin.recordCount GT 0>
            <cfset response["success"] = true>
            <cfset response["message"] = "">
            <cfif body.setSession>
                <cflock timeout="20" throwontimeout="No" type="EXCLUSIVE" scope="session">
                    <cfset session.authenticated = true>					
                    <cfset session.userId = qLogin.usu_id>
                    <cfset session.userName = qLogin.usu_nome>                                
                </cflock>
                <cfset response["session"] = session>
            </cfif>
        <cfelse>
            <cfset response["success"] = false>
            <cfset response["message"] = "Usuário e/ou senha incorreto(s)">
        </cfif>

        <cfset response["query"] = queryToArray(qLogin)>

		<cfreturn SerializeJSON(response)>
	</cffunction>
    
    <cffunction name = "authenticated" access ="remote" returntype ="String" httpMethod="GET" restPath="/login">

        <cfset response = structNew()>

        <cfif StructKeyExists(session, "authenticated") AND session.authenticated>	
            <cfset response["authenticated"] = true>
        <cfelse>    
            <cfset response["authenticated"] = false>
        </cfif>

        <cfreturn SerializeJSON(response)>
    </cffunction>

    <cffunction name = "logout" access ="remote" returntype ="String" httpMethod="POST" restPath="/logout">
        
        <cfset StructClear(session)>
        <cfset response = structNew()>
        <cfset response["sessionClear"] = true>

        <cfreturn SerializeJSON(response)>
    </cffunction>
</cfcomponent>