<cftry>
	<cfset path = getDirectoryFromPath(getCurrentTemplatePath())>
	<cfset restInitApplication(path, "interblock-sistema")>
	<cfoutput>restInitApplication success</cfoutput>	
	<cfcatch type="any">
	    <!--- <cfdump var="#cfcatch#"> --->
		<cfoutput>restInitApplication fault | #cfcatch.message# | #cfcatch.detail#</cfoutput>
	    <cfabort>
	</cfcatch>
</cftry>

<!---
<cfhttp 
	url="http://localhost:8500/rest/interblock-sistema/example/hello" 
	method="GET" 
	port="8500" 
	result="response">
       <cfhttpparam type="body" value="#SerializeJSON('postExample')#">
</cfhttp>

<cfdump var="#response#">
--->