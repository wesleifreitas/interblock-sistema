<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="teste.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfif not IsDefined("form.submit")>
<p>Gerar Boleto</p>
<form name="form1" method="post" action="">
  <table width="768" border="1">
    <tr>
      <td>Agencia</td>
      <td><input name="agencia" type="text" id="agencia" value="0$4" size="3" maxlength="3"></td>
    </tr>
    <tr>
      <td>Conta</td>
      <td><input name="conta" type="text" id="conta" value="6001342" size="7" maxlength="7"></td>
    </tr>	
    <tr>
      <td>Valor</td>
      <td><input name="valor" type="text" id="valor" value="123.75" maxlength="10">
      at&eacute; 10 numeros -563,23 </td>
    </tr>
    <tr>
      <td>Vencimento</td>
      <td><input name="vencimento" type="text" id="vencimento" value="30/07/2005" maxlength="10"> 
      dd/mm/yyyy </td>
    </tr>
    <tr>
      <td>Nosso Numero </td>
      <td><input name="nossonumero" type="text" id="nossonumero" value="041735" maxlength="6">
      6 numeros </td>
    </tr>
    <tr>
      <td>Nome Sacado:</td>
      <td><input name="nomeSacado" type="text" id="nomeSacado" value="Abilio Cipriano" size="40"></td>
    </tr>
    <tr>
      <td>Endereco Sacado: </td>
      <td><input name="enderecoSacado" type="text" id="enderecoSacado" value="SMPW QD 05 Conj. XXX Casa XXX - Bras�lia - DF" size="60"></td>
    </tr>
				
    <tr>
      <td colspan="2"><div align="center">
        <input type="submit" name="Submit" value="Gerar Boleto">
      </div></td>
    </tr>
  </table>
</form>
<cfelse>

  <cfinclude template="funcoesBoleto.cfm">
  <cfset numeroChave = chave(agencia,conta,form.nossonumero)>
  <cfset codBar = codigoBarra(form.vencimento,form.valor,numeroChave)>
  <cfset linha = linhaDigitavel(numeroChave,codBar)>
	<cfmodule 
		template="layoutboletobrb.cfm" 
		dataProcessamento="#LSDateFormat(now(),'DD/MM/YYYY')#" 
		dataDocumento="#LSDateFormat(now(),'DD/MM/YYYY')#" 
		dataVencimento="#form.vencimento#"
		dataVencimentoCliente="#LSDateFormat(now(),'DD/MM/YYYY')#"  
		nDocumento="#form.nossonumero#" 
		agencia="#form.agencia#" 
		conta="#form.conta#" 
		valor="#form.valor#" 
		instrucao="COBRAR MULTA DE 2,00% SOBRE O VALOR DO TITULO APOS VENCIMENTO.<BR>NAO DISPENSAR JUROS DE MORA. JUROS DE 2,00 AO MES(%)<BR><BR>** OBS.: ESTE BLOQUETO PERDE A VALIDADE APOS 60 DIAS DO VENCTO **<BR>** BOLETO DO MES <FONT SIZE='2'>#LSDateFormat(now(),'DD/MM/YYYY')#</FONT>  REFERENTE A <FONT SIZE='2'><U>TAXA DE LIMPEZA E SEGURAN�A</U></FONT> **" 
		nomeSacado="#form.nomeSacado#" 
		enderecoSacado="<b>#form.enderecoSacado#</b>" 
		chave="#numeroChave#" 
		codigoBarra="#codBar#" 
		linhaDigitavel="#linha#">	
	 
ok

</cfif>
</body>
</html>
