<cfcomponent
    output="false"
    hint="I define the application and root-level event handlers.">

    <!--- Define application settings. --->
    <cfset THIS.Name = "interblock-sistema" />    
    <cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 8, 0, 0 ) />
    <cfset THIS.SessionManagement = true />
    <!--- <cfset THIS.SessionTimeout = CreateTimeSpan( 0, 0, 40, 0 ) /> --->
    <cfset THIS.SessionTimeout = CreateTimeSpan( 0, 8, 0, 0 ) />
    <cfset THIS.SetClientCookies = true />
    <cfset THIS.RootDir = getDirectoryFromPath(getCurrentTemplatePath()) />

    <cfparam name="session.loggedIn" default="false" />

    <!--- Define the request settings. --->
    <cfsetting
        showdebugoutput="false"
        requesttimeout="10"
        />

   <cffunction
        name="OnApplicationStart"
        access="public"
        returntype="boolean"
        output="false"
        hint="I run when the application boots up. If I return false, the application initialization will hault.">

        <cfset application.datasource = "px_interblock_sql_local">

        <cfreturn true />
    </cffunction>


    <cffunction
        name="OnSessionStart"
        access="public"
        returntype="void"
        output="false"
        hint="I run when a session boots up.">
       
        <!--- Return out. --->
        <cfreturn />
    </cffunction>         

    <cffunction
        name="OnRequestStart"
        access="public"
        returntype="boolean"
        output="false"
        hint="I perform pre page processing. If I return false, I hault the rest of the page from processing.">

        <cfargument type="String" name="targetPage" required="true"/>

        <!--- fake --->
        <cfif (IsDefined("SESSION.authenticated") AND SESSION.authenticated) 
            OR targetPage EQ "/interblock-sistema/backend/cf/restInit.cfm" 
            OR targetPage EQ "/backend/restInit.cfm">
            
            <cfreturn true />
        <cfelse>

            <cfset var authHeader = GetPageContext().getRequest().getHeader("Authorization") />
            <cfset var authString = "" />
            <cfsetting showDebugOutput="false" />

            <cfif IsDefined("authHeader")>
                <cfset authString = ToString(BinaryDecode(ListLast(authHeader, " "),"Base64")) />

                <cfquery datasource="#application.datasource#" name="query">
                    SELECT 
                        TOP 1
                        usu_id
                    FROM 
                        dbo.usuario
                    WHERE
                        usu_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetToken(authString, 1, ":")#">                        
                    AND usu_senha = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(GetToken(authString, 2, ":"), "SHA-512")#">
                    AND usu_ativo = 1
                </cfquery>

                <!-- fake -->
                <cfif GetToken(authString, 1, ":") EQ "admin" AND GetToken(authString, 2, ":") EQ "admin">
                    <cfreturn true />
                </cfif>
            </cfif>

            <cfheader statuscode="401"> 
            <cfheader name="WWW-Authenticate" value="Basic realm=""Test"""> 
             
             <!--- UNAUTHORIZED --->            
            <cfthrow message="UNAUTHORIZED #hash(GetToken(authString, 2, ":"), "SHA-512")#">

            <cfreturn false />
        </cfif>     

        <!--- Check for initialization. 
        <cfif StructKeyExists( URL, "reset" )>

            <!--- Reset application and session. --->
            <cfset THIS.OnApplicationStart() />
            <cfset THIS.OnSessionStart() />

        </cfif>
       
        
        <!--- Return out. --->
        <cfreturn true />
         --->
    </cffunction>

    <cffunction
        name="OnRequest"
        access="public"
        returntype="void"
        output="true"
        hint="I execute the primary template.">

        <!--- Define arguments. --->
        <cfargument
            name="Page"
            type="string"
            required="true"
            hint="The page template requested by the user."
            />


        <cfif SESSION.loggedIn>

            <!--- User logged in. Allow page request. --->
            <cfinclude template="#ARGUMENTS.Page#" />

        <cfelse>

            <cfinclude template="#ARGUMENTS.Page#" />

        </cfif>

        <!--- Return out. --->
        <cfreturn />
    </cffunction>

</cfcomponent>