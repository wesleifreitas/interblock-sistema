<cfparam name="attributes.dataProcessamento" default="#LSDateFormat(now(),'DD/MM/YYYY')#">
<cfparam name="attributes.dataDocumento" default="#LSDateFormat(now(),'DD/MM/YYYY')#">
<cfparam name="attributes.dataVencimento" default="#LSDateFormat(now(),'DD/MM/YYYY')#">
<cfparam name="attributes.dataVencimentoCliente" default="#LSDateFormat(now(),'DD/MM/YYYY')#">
<cfparam name="attributes.nDocumento" default="1002">
<cfparam name="attributes.agencia" default="011">
<cfparam name="attributes.conta" default="0112652">
<cfparam name="attributes.valor" default="">
<cfparam name="attributes.juros" default="">
<cfparam name="attributes.instrucao" default="N�o Receber ap�s o vencimento">
<cfparam name="attributes.nomeSacado" default="Abilio Luiz Bomfim Cipriano">
<cfparam name="attributes.enderecoSacado" default="Ch 5 Qd 5 Cj 4 Cs 21 Vereda da Cruz - Brasilia - DF - 70000-000">
<cfparam name="attributes.chave" default="">
<cfparam name="attributes.codigoBarra" default="">
<cfparam name="attributes.linhaDigitavel" default="">

<cfscript>
function barCode(number)
{
fino =1;
largo = 3;
altura = 40;
f1 = 9;
f2 = 9;
f=0;
BarCodes = ArrayNew(1);
num = number;

BarCodes[1] = "00110";
BarCodes[2] = "10001";
BarCodes[3] = "01001";
BarCodes[4] = "11000";
BarCodes[5] = "00101";
BarCodes[6] = "10100";
BarCodes[7] = "01100";
BarCodes[8] = "00011";
BarCodes[9] = "10010";
BarCodes[10] = "01010";

while (f1 gt -1)
{
	while (f2 gt -1)
	{
	   f = f1 * 10 + f2;
	   texto = "";
    	   for(i=1;i lte 5;i=i+1)
		   {
		    texto = texto & mid(BarCodes[f1 + 1], i, 1) & mid(BarCodes[f2 + 1], i, 1);
		   }
		    BarCodes[f + 1] = texto;
	   f2=f2-1;
	}
	 f2 = 9;
	 f1=f1-1;
}

WriteOutput("<img src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/pr.gif' width='"&fino&"' height='"&altura&"'>");
WriteOutput("<img src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/br.gif' width='"&fino&"' height='"&altura&"'>");
WriteOutput("<img src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/pr.gif' width='"&fino&"' height='"&altura&"'>");
WriteOutput("<img src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/br.gif' width='"&fino&"' height='"&altura&"'>");
WriteOutput("<img");
texto = num;
if (len(texto) mod 2 NEQ 0)
   texto = "0" & texto;
   
	while(len(texto) gt 0)
	{
	  i = int(left(texto, 2));
	 if(len(texto) GT 2)
       texto = right(texto, len(texto) - 2);
     else
       texto = "";
      f = BarCodes[i + 1];
	  	for(i=1;i lte 10; i=i+2)
		{
		  if(mid(f, i, 1) EQ "0")
		    f1 = fino;
		  else
		    f1 = largo;
		 WriteOutput(" src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/pr.gif' width='"&f1&"' height='"&altura&"'><img");
		   if(mid(f, i, 1) EQ "0")
            f2 = fino;
           else
            f2 = largo;
         WriteOutput(" src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/br.gif' width='"&f2&"' height='"&altura&"'><img");
		}
	}

WriteOutput(" src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/pr.gif' width='"&largo&"' height='"&altura&"'>");
WriteOutput("<img src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/br.gif' width='"&#fino#&"' height='"&altura&"'>");
WriteOutput("<img src='http://localhost:8500/interblock-sistema/backend/cf/boleto_module/pr.gif' width='1' height='"&altura&"'>");

}
</cfscript>


<table border="0" cellpadding="0" cellspacing="0" width="640">
<tbody><tr>
<td width="225" align="center"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><img src=http://localhost:8500/interblock-sistema/backend/cf/boleto_module/logo-bradesco.jpg><font face="Verdana, Arial, Helvetica, sans-serif" size="4">&nbsp;</font></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="4"><strong>070-1</strong></font></td>
  </tr>
</table></td>
<td align="right" width="415"><font face="Arial, Helvetica" size="-1">&nbsp;  </font><font face="Arial, Helvetica" size="-1"><br>
  </font>
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="36%" align="center">
	   <FONT face="Arial, Helvetica" SIZE='2'>Boleto do m�s<br><cfoutput>#LSDateFormat(attributes.dataVencimentoCliente,'MM/YYYY')#</cfoutput></FONT>
	  </td>
      <td width="64%"><font face="Arial, Helvetica" size="-1">EC - Empresa Qualquer<br>
        Rua  1 Quadra 5 Lote 4 N 2</font></td>
    </tr>
  </table>
  </td>
</tr>
</tbody></table>

<table border="1" cellpadding="1" cellspacing="0" width="640">
<tbody><tr valign="top">
<td><font face="Arial, Helvetica" size="1">Cedente</font><br>
  <font face="Arial, Helvetica" size="-1">Nome da Empresa XXXXXXXXX XXXXXX</font></td>
<td><font face="Arial, Helvetica" size="1">Ag�ncia / C�digo Cedente</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#mid(attributes.chave,1,3)#-#mid(attributes.chave,4,3)#-#mid(attributes.chave,7,7)#</cfoutput></font></td>
<td><font face="Arial, Helvetica" size="1">Data Emiss�o</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#attributes.dataProcessamento#</cfoutput></font></td>
<td align="right"><font face="Arial, Helvetica" size="1">Vencimento</font><br>
  <font face="Arial, Helvetica"><b><cfoutput>#attributes.dataVencimento#</cfoutput></b></font></td>
</tr>
<tr valign="top">
<td><font face="Arial, Helvetica" size="1">Sacado</font><br>
<font face="Arial, Helvetica" size="-1"><cfoutput>#attributes.nomeSacado#</cfoutput></font></td>
<td><font face="Arial, Helvetica" size="1">Nosso Numero</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#mid(attributes.chave,14,13)#</cfoutput></font></td>
<td><font face="Arial, Helvetica" size="1">Numero da Guia</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#attributes.nDocumento#</cfoutput></font></td>
<td align="right"><font face="Arial, Helvetica" size="1">Valor do Documento</font><br>
  <font face="Arial, Helvetica"><b><cfoutput>#NumberFormat(attributes.valor,'_____.__')#</cfoutput></b></font></td>
</tr>
</tbody></table>

<table width="640" height="37" border="0" cellpadding="0" cellspacing="0">
<tbody><tr>
<td height="29" valign="top">
<p align="right"><font face="Arial, Helvetica" size="-2"><b>Autentica��o Mec�nica</b></font></p></td>
</tr>
</tbody></table>

<table border="0" cellpadding="0" cellspacing="0">
<tbody><tr>
<td width="640">
<hr size="1">
</td>
<td>
<p align="right"><font size="-2">&nbsp;dobre</font></p>
</td>
</tr>
</tbody></table>

<table border="0" cellpadding="0" cellspacing="0" width="640">
<tbody><tr>
<td valign="middle" width="225"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><img src=http://localhost:8500/interblock-sistema/backend/cf/boleto_module/logo-bradesco.jpg><font face="Verdana, Arial, Helvetica, sans-serif" size="4">&nbsp;</font></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="4"><strong>070-1</strong></font></td>
  </tr>
</table></td>
<td align="right" valign="bottom"><font face="Arial, Helvetica" size="2"><strong><cfoutput>#mid(attributes.linhaDigitavel,1,5)#.#mid(attributes.linhaDigitavel,6,5)# #mid(attributes.linhaDigitavel,11,5)#.#mid(attributes.linhaDigitavel,16,6)# #mid(attributes.linhaDigitavel,22,5)#.#mid(attributes.linhaDigitavel,27,6)# #mid(attributes.linhaDigitavel,33,1)# #mid(attributes.linhaDigitavel,34,14)#</cfoutput></strong></font></td>
</tr>
</tbody></table>

<table border="1" cellpadding="1" cellspacing="0" width="640">
<tbody><tr>
<td colspan="5" width="500"><font face="Arial, Helvetica" size="1">Local de Pagamento</font><br>
  <font face="Arial, Helvetica" size="-1">Pag&aacute;vel em qualquer banco at&eacute; o vencimento, ap&oacute;s  somente no BRB </font></td>
<td align="right" width="170"><font face="Arial, Helvetica" size="1">Vencimento</font><br><font face="Arial, Helvetica"><b><cfoutput>#attributes.dataVencimento#</cfoutput></b></font></td>
</tr>
<tr>
<td colspan="5" width="500"><font face="Arial, Helvetica" size="1">Cedente</font><br>
  <font face="Arial, Helvetica" size="-1">Nome da Empresa XXXXXXXXX XXXXXX</font></td>
<td align="right" width="170"><font face="Arial, Helvetica" size="1">Ag�ncia / C�digo Cedente</font><br><font face="Arial, Helvetica" size="-1"><cfoutput>#mid(attributes.chave,1,3)#-#mid(attributes.chave,4,3)#-#mid(attributes.chave,7,7)#</cfoutput></font></td>
</tr>
<tr>
<td valign="top"><font face="Arial, Helvetica" size="1">Data Documento</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#attributes.dataDocumento#</cfoutput></font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Numero Documento</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#attributes.nDocumento#</cfoutput></font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Especie Documento</font><br>
  <font face="Arial, Helvetica" size="-1">DM</font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Aceite</font><br>
  <font face="Arial, Helvetica" size="-1">N</font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Data Processamento</font><br>
  <font face="Arial, Helvetica" size="-1"><cfoutput>#attributes.dataProcessamento#</cfoutput></font></td>
<td align="right" width="170"><font face="Arial, Helvetica" size="1">Nosso Numero</font><br><font face="Arial, Helvetica" size="-1"><cfoutput>#mid(attributes.chave,14,13)#</cfoutput></font></td>
</tr>
<tr>
<td valign="top"><font face="Arial, Helvetica" size="1">Uso Banco</font><br>
</td>
<td valign="top"><font face="Arial, Helvetica" size="1">Carteira</font><br>
  <font face="Arial, Helvetica" size="-1">COB</font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Especie</font><br>
  <font face="Arial, Helvetica" size="-1">R$</font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Quantidade</font><br>
  <font face="Arial, Helvetica" size="-1">&nbsp;</font></td>
<td valign="top"><font face="Arial, Helvetica" size="1">Valor</font><br>
  <font face="Arial, Helvetica" size="-1">&nbsp;</font></td>
<td align="right" width="170"><font face="Arial, Helvetica" size="1">Valor do Documento</font><br><font face="Arial, Helvetica"><b><cfoutput>#NumberFormat(attributes.valor,'_____.__')#</cfoutput></b></font></td>
</tr>
<tr>
<th colspan="5" rowspan="4" valign="top" align="left"><font face="Arial, Helvetica" size="1">Instru��es</font><br>
  <font face="Arial, Helvetica" size="1"><cfoutput>#attributes.instrucao#</cfoutput></font>
  <cfif attributes.juros gt 0>
 <br><font face="Arial, Helvetica" size="2"><b><cfoutput>Multa/Juros: R$ #NumberFormat(attributes.juros,'_____.__')#</cfoutput></b></font>
</cfif>
  </th>
<td width="170"><font face="Arial, Helvetica" size="1">(+) Outros Acr�cimos</font></td>
</tr>
<tr>
<td width="170"><font face="Arial, Helvetica" size="1">(-) Descontos/Abatimento</font></td>
</tr>
<tr>
<td width="170"><font face="Arial, Helvetica" size="1">(+) Mora/Multa</font>

</td>
</tr>
<tr>
<td width="170"><font face="Arial, Helvetica" size="1">(=) Valor Cobrado</font><br>&nbsp;</td>
</tr>
<tr>
<td colspan="6"><font face="Arial, Helvetica" size="1">Sacado</font><font face="Arial, Helvetica" size="-1"><br><cfoutput>#attributes.nomeSacado#</cfoutput> <cfoutput>#attributes.enderecoSacado#</cfoutput></font></td>
</tr>
</tbody></table>

<table border="0" cellpadding="0" cellspacing="0" width="640">
<tbody><tr>
<td height="49" colspan="6"><p align="right"><font face="Arial, Helvetica" size="-2"><b>Autentica��o Mec�nica / FICHA DE COMPENSA��O</b></font></p>
<p align="left"><cfoutput>#barCode(attributes.codigoBarra)#</cfoutput></p></td>
</tr>
</tbody></table>
<table border="0" cellpadding="0" cellspacing="0">
<tbody><tr>
<td width="640">
<hr size="1">
</td>
<td>
<p align="right"><font size="-2">&nbsp;corte</font></p>
</td>
</tr>
<tr>
<td width="640">
</td>
</tr>
</tbody></table>

