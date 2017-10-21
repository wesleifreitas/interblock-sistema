<cffunction 
    name       ="moneyBrExt" 
    access     ="private" 
    returntype ="string" 
    output     ="false">

    <cfargument name="value" type="numeric" required="true">

    <cfset singular=ListToArray("centavo,real,mil,milhão,bilhão,trilhão,quatrilhão")>
    <cfset plural=ListToArray("centavos,reais,mil,milhões,bilhões,trilhões,quatrilhões")>

    <cfset c=ListToArray("!,cem,duzentos,trezentos,quatrocentos,quinhentos,seiscentos,setecentos,oitocentos,novecentos")>
    <cfset c[1]="">
    <cfset d=ListToArray("!,dez,vinte,trinta,quarenta,cinquenta,sessenta,setenta,oitenta,noventa")>
    <cfset d[1]="">
    <cfset d10=ListToArray("dez,onze,doze,treze,quatorze,quinze,dezesseis,dezessete,dezoito,dezenove")>
    <cfset u=ListToArray("!,um,dois,três,quatro,cinco,seis,sete,oito,nove")>
    <cfset u[1]="">

    <cfset z=0>
    <cfset valstr=NumberFormat(arguments.value, ",0.00")>
    <cfset valstr=Replace(valstr, ",", ".", "ALL")>
    <cfset valarr=ListToArray(valstr, ".")>

    <cfset rt="">

    <cfset fim=ArrayLen(valarr) - IIF(valarr[ArrayLen(valarr)] GT 0, DE("0"), DE("1"))>
    <cfloop index="ct" from="1" to="#ArrayLen(valarr)#">
        <cfset valor=NumberFormat(valarr[ct], "000")>
        <cfset digitos=ArrayNew(1)>
        <cfset digitos[1]=Left(valor, 1)>
        <cfset digitos[2]=Mid(valor, 2, 1)>
        <cfset digitos[3]=Right(valor, 1)>

        <cfset rc=IIF(valor GT 100 AND valor LT 200, DE("cento"), "c[digitos[1]+1]")>
        <cfset rd=IIF(digitos[2] LT 2, DE(""), "d[digitos[2]+1]")>
        <cfif valor GT 0>
            <cfset ru=IIF(digitos[2] EQ 1, "d10[digitos[3]+1]", "u[digitos[3]+1]")>
        <cfelse>
            <cfset ru="">
        </cfif>

        <cfset r=rc>
        <cfif rc NEQ "" AND (rd NEQ "" OR ru NEQ "")>
            <cfset r=r & " e ">
        </cfif>
        <cfset r=r & rd>
        <cfif rd NEQ "" and ru NEQ "">
            <cfset r=r & " e ">
        </cfif>
        <cfset r=r & ru>
        
        <cfset t=ArrayLen(valarr)-ct>
        
        <cfif r NEQ "">
            <cfset r=r & " ">
            <cfif valor GT 1>
                <cfset r=r & plural[t+1]>
            <cfelse>
                <cfset r=r & singular[t+1]>
            </cfif>
        </cfif>

        <cfif valor EQ 0>
            <cfset z=z+1>
        <cfelseif z GT 0>
            <cfset z=z-1>
        </cfif>	
        
        <cfif t EQ 1 and z GT 0 and valarr[1] GT 0>
            <cfif z GT 1>
                <cfset r=r & " de ">
            </cfif>
            <cfset r=r & plural[t+1]>
        </cfif>
        
        <cfif r NEQ "">
            <cfif ct GT 1 AND ct LTE fim and valarr[1] GT 0 and z LT 1>
                <cfif ct LT fim>
                    <cfset rt=rt & ", ">
                <cfelse>
                    <cfset rt=rt & " e ">
                </cfif>
            <cfelse>
                <cfset rt=rt & " ">
            </cfif>
            <cfset rt=rt & r>
        </cfif>
    </cfloop>

    <cfreturn rt>
</cffunction>