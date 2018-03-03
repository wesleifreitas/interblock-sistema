<style>
    h1 {
        font-size: 1em;
        padding: 10px 10px 0 10px;
    }
    h2 {
        font-size: .9em;
		margin-bottom: 0;
    }
	h3 {
        font-size: .7em;
		margin-bottom: 0;
    }
    hr {
	    border: 0;
	    height: 0;
	    border-top: 1px solid rgba(0, 0, 0, 0.1);    
        width: 100%;
	}

    /*http://stackoverflow.com/questions/10618917/need-thin-table-borders-in-pdf-generated-by-cfdocument*/
    .tbl {
        background-color:#000;
    }

    .tbl td,th,tr,caption{
        background-color:#fff
    }
    
    table { 
        width: 100%;
        font-size: 12px;
        table-layout: fixed;
        margin-left: auto;
        margin-right: auto;	  
    }

    table.header {
        border: 1px solid black;
    }
    
    table td.titulo {
        font-weight: bold;
        white-space: nowrap;
        width: 1%;
        text-align:right;
        vertical-align: top;
        padding-top: 1px;
        font-size: .9em;
    }

    table td.valor {
        /*white-space: nowrap;*/
        padding-top: 3px;
        vertical-align: top;
        font-size: .9em;
    }

    td.left{
        text-align: left;
    }

    td.right: {
        text-align: right;
    }

    td.center: {
        text-align: center;
    }

	.info {
		margin: 0 20px 0 20px;
	}

    table.block {    
        width: 100%;
        text-align: left;
        border: 1px solid black;
    }

    table.header-item {    
        width: 100%;
        text-align: center;
    }

    td.header-item {
        border: 1px solid black;
    }

    span.value {
        text-align: center;
        color: #222283;
    }

    .instalador {
        text-align: center;
    }
    .checkout hr {
        margin-top: 20px;
    }
    .declaracao p{
        margin: 0 10px 0 10px;
        text-align: justify;
        font-size: .9em;
    }
    div.assinatura-data{
        margin-top: 10px;
		width: 100%;
		text-align: center;
		font-size: 13px;
	}
	table.assinaturas{
        margin: 30px 0 30px 0;
		text-align: center;
		border-spacing: 10px;
		border-collapse: separate;
	}

    .nota td {
        padding-left: 10px;
        font-size: 13px;
    }
	.nota td.line-gap {
		vertical-align: bottom;
	}
	.nota td.assinatura-gap {
		text-align: center;
		vertical-align: top;
	}
    .rotate {
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        width: 1.5em;
        border-right: 1px solid black; 
    }
    .rotate div {
        background-color:red;
        -moz-transform: rotate(-90.0deg);  /* FF3.5+ */
        -o-transform: rotate(-90.0deg);  /* Opera 10.5 */
        -webkit-transform: rotate(-90.0deg);  /* Saf3.1+, Chrome */
        filter:  progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083);  /* IE6,IE7 */
        -ms-filter: "progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083)"; /* IE8 */
        margin-left: -10em;
        margin-right: -10em;
    }
    .rotate img {
        padding: 20px 10px 20px 0;
        height: 270px;
        width: auto;
    }
	.recibo {
		border: 1px solid black;
		border-top: 1px dashed black;
	}
</style>

<cfoutput>	
	<cfset setLocale("Portuguese (Brazilian)")>	
	<cfinclude template="number-util.cfm">
	
	<cftry>
		<cfset BORDER = 0>
		<cfset LOGO_PATH = "../../../assets/logo/logo-interblock.gif">

		<cfquery name="query" datasource="#application.datasource#">
			SELECT
				os_id
                ,os_numero
                ,os_status
				,os_valor
                ,os_data
                ,vw_ordem_servico.cli_id
                ,vw_ordem_servico.vei_id
                ,os_cep
                ,os_endereco
                ,os_numero_endereco
                ,os_complemento
                ,os_bairro
                ,os_cidade
                ,os_uf
                ,os_tel1
                ,os_tel2
                ,os_tel3
                ,os_tel4
                ,os_responsavel
				,os_objetivo
                ,os_id
				
				,cli_arquivo
				,cli_nome
				,cli_pessoa
				,cli_nascimento
				,cli_endereco
				,cli_numero
				,cli_complemento
				,cli_bairro
				,cli_cidade
				,cli_uf
				,cli_cep
				,cli_tel1
				,cli_tel2
				,cli_tel3
				,cli_tel4
				,cli_email
				,cli_cpfcnpj
				,cli_rginscricaoestadual
				
				,vei_modelo
				,vei_cor
				,vei_ano
				,vei_placa
				
				,usu_nome

				,prop_numero
    			,prop_arquivo_digito

				,tecnico_nome
				,tecnico_cpf
			FROM
                vw_ordem_servico
				
			LEFT OUTER JOIN proposta
			ON vw_ordem_servico.cli_id = proposta.cli_id
			AND vw_ordem_servico.vei_id = proposta.vei_id

            WHERE
                os_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
		</cfquery>
		

		<cfset query.cli_cep = NumberFormat(query.cli_cep, '00000000')>
		<cfset query.os_cep = NumberFormat(query.os_cep, '00000000')>

		<div class="info">

			<table class="header-item">
				<tr>
					<td class="header-item" width="50%">
						<center>			
							<h1>INTERBLOCK COMERCIAL LTDA ME
							<br />Sistema de Proteção para Veículos</h1>
						</center>
					</td>

					<td class="header-item center" nowrap>					
						<h1>ORDEM DE SERVIÇO:
						<br />N° #query.os_numero#</h1>
					</td>		
				</tr>
			</table>

			<table class="header-item">
				<tr>
					<td class="header-item" width="50%" nowrap>
						<b>Téc. Inst.</b><br>
						<span class="value"><span class="value">#ucase(query.tecnico_nome)#</span></span>
					</td>
					<td class="header-item" nowrap>
						<b>Atendente</b><br>
						<span class="value"><span class="value">#ucase(query.usu_nome)#</span></span>
					</td>		
				</tr>
			</table>

			<h2>Dados do cliente</h2>
			<table width="100%" class="block">
				<tr>	
					<td class="titulo">Nome:</td>
					<td class="valor"><span class="value">#ucase(query.cli_nome)#</span></td>
					
					
					<td class="titulo">Contrato:</td>
					<td class="valor">
						<span class="value">
							#query.prop_numero#
						</span>
						<b>Arquivo: </b>
						<span class="value">
							#query.cli_arquivo#
							<cfif isNumeric(query.prop_arquivo_digito)>
								- #query.prop_arquivo_digito#
							</cfif>
						</span>
					</td>		
				</tr>
				
				<tr>	
					<td class="titulo">Endereço:</td>
					<td class="valor" nowrap>
						<span class="value">
							#ucase(query.os_endereco)#, #query.os_numero_endereco#
						</span>
					</td>
					
					<td class="titulo">Complemento:</td>
					<td class="valor"><span class="value">#ucase(query.os_complemento)#</span></td>					
				</tr>

				<tr>	
					<td class="titulo">Bairro:</td>
					<td class="valor"><span class="value">#ucase(query.os_bairro)#</span></td>
					
					<td class="titulo">Cidade:</td>
					<td class="valor"><span class="value">#ucase(query.os_cidade)#</span> - <span><span class="value">#ucase(query.os_uf)#</span></span></td>
				</tr>

				<tr>	
					<td class="titulo">CEP:</td>
					<td class="valor"><span class="value">#mid(query.os_cep,1,5)#-#mid(query.os_cep,6,3)#</span></td>
					
					<td class="titulo">E-mail:</td>
					<td class="valor">
						<span class="value">
							#ucase(query.cli_email)#
						</span>
					</td>	
				</tr>

				<tr>	
					<td class="titulo">Telefone:</td>
					<td class="valor">
						<cfif len(query.os_tel1) GTE 10>
							<span class="value">#mid(query.os_tel1,1,2)#-#mid(query.os_tel1,3,4)#-#mid(query.os_tel1,7,4)#</span>
						</cfif>
						<cfif len(query.os_tel1) GTE 10 AND len(query.os_tel2) GTE 10>
						/
						</cfif>
						<cfif len(query.os_tel2) GTE 10>
							<span class="value">#mid(query.os_tel2,1,2)#-#mid(query.os_tel2,3,4)#-#mid(query.os_tel2,7,4)#</span>
						</cfif>
					</td>					
							
					<td class="titulo">Celular:</td>
					<td class="valor">
						<cfif len(query.os_tel3) GTE 10>
							<span class="value">#mid(query.os_tel3,1,2)#-#mid(query.os_tel3,3,4)#-#mid(query.os_tel3,7,4)#</span>
						</cfif>
						<cfif len(query.os_tel3) GTE 10 AND len(query.os_tel4) GTE 10>
						/
						</cfif>
						<cfif len(query.os_tel4) GTE 10>
							<span class="value">#mid(query.os_tel4,1,2)#-#mid(query.os_tel4,3,4)#-#mid(query.os_tel4,7,4)#</span>
						</cfif>
					</td>
				</tr>
				<tr>
					<cfif query.cli_pessoa EQ "F">					
						<td class="titulo">CPF:</td>
							<td class="valor">
							<span class="value">						
								#mid(query.cli_cpfCnpj,1,3)#.#mid(query.cli_cpfCnpj,4,3)#.#mid(query.cli_cpfCnpj,7,3)#-#mid(query.cli_cpfCnpj,10,2)#
							</span>
						</td>
					<cfelse>
						<td class="titulo">CNPJ:</td>
							<td class="valor">
							<span class="value">											
								#mid(query.cli_cpfCnpj,1,2)#.#mid(query.cli_cpfCnpj,3,3)#.#mid(query.cli_cpfCnpj,6,3)#/#mid(query.cli_cpfCnpj,9,4)#-#mid(query.cli_cpfCnpj,13,2)#
							</span>
						</td>
					</cfif>
					<cfif query.cli_pessoa EQ "F">
						<td class="titulo">RG:</td>
						<td class="valor">
							<span class="value">
								#mid(query.cli_rgInscricaoEstadual,1,2)#.#mid(query.cli_rgInscricaoEstadual,3,3)#.#mid(query.cli_rgInscricaoEstadual,6,3)#-#mid(query.cli_rgInscricaoEstadual,9,2)#
							</span>
						</td>
					<cfelse>
						<td class="titulo">Inscrição estadual:</td>
						<td class="valor">
							<span class="value">
								#query.cli_rgInscricaoEstadual#	
							</span>
						</td>
					</cfif>
				</tr>	
				<tr>
					<td class="titulo">Objetivo:</td>
					<td class="valor" colspan="3">
						<span class="value">
							#ucase(query.os_objetivo)#
						</span>
					</td>	
				</tr>			
			</table>

			<h2>Dados do veículo</h2>	
			<table width="100%" class="block">
				<tr>					
					<td class="titulo" nowrap>Marca/Modelo:</td>
					<td class="valor" nowrap><span class="value">#query.vei_modelo#</span></td>

					<td class="titulo" nowrap>Cor:</td>
					<td class="valor" nowrap><span class="value">#query.vei_cor#</span></td>

					<td class="titulo" nowrap>Ano:</td>
					<td class="valor" nowrap><span class="value">#query.vei_ano#</span></td>

					<td class="titulo" nowrap>Placa:</td>
					<td class="valor" nowrap><span class="value">#query.vei_placa#</span></td>
				</tr>
			</table>

			<h3 class="instalador">USO DO INSTALADOR — SERVIÇOS EXECUTADOS — CHECKOUT — DATA  ____/____/________ HORA ____:____</h3>	
			<div class="checkout">
				<hr>
				<hr>
			</div>
			<div class="declaracao">
				<p>
					Neste ato, declaro que recebi o funcionário da empresa em questão 
					e que este prestou os Serviços necessários para que o sistema instalador
					em meu veículo funcione perfeitamente e que após o serviço executado,
					testou o sistema e tudo está em perfeito funcionamento.

				</p>
			</div>

			<div class="assinatura-data">
				De Acordo: ____/____/________

				<table class="assinaturas">
					<tr>
						<td>
							____________________________________________
							<br/>#uCase(query.cli_nome)#
						</td>
						<td>
							____________________________________________
							<br/>#uCase(query.tecnico_nome)#
						</td>
					</tr>
				</table>
			</div>
		</div>

		<cfset vencimento = DateAdd("d", 30, query.os_data)>
		<cfset vencimentoDia = LSDateFormat(vencimento, "D")>
        <table class="block nota" cellpadding="0" cellspacing="0" align="center" border="0">
            <tr>
                <td class="rotate" rowspan=11>
                    <!--- <div>NOTA PROMISSÓRIA</div> --->
                    <img src="http://sistema-beta.interblock.com.br/assets/img/ordem-servico/nota.gif" />
                </td>   
            </tr>
            <tr>
                <td colspan="1" class="line-gap">N° <b>01/01</b> VALOR <b>#LSCurrencyFormat(query.os_valor)#</b></td>
                <td colspan="1" class="line-gap">VENCIMENTO <b>#LSDateFormat(vencimento ,"DD-mmmm-YYYY")#</b></td>
            </tr>
            <tr>
				<cfif vencimentoDia GT 1>
                	<td colspan="2" class="line-gap">AOS <b style="letter-spacing:0px">#vencimentoDia#</b> DIAS DO MÊS E ANO DE <b>#ucase(LSDateFormat(DateAdd("d", 30, query.os_data) ,"mmmm-YYYY"))#</b> PAGAREI(EMOS) POR ESTÁ ÚNICA VIA</td>
				<cfelse>
					<td colspan="2" class="line-gap">No <b style="letter-spacing:0px">PRIMEIRO</b> DIA DO MÊS E ANO DE <b>#ucase(LSDateFormat(DateAdd("d", 30, query.os_data) ,"mmmm-YYYY"))#</b> PAGAREI(EMOS) POR ESTÁ ÚNICA VIA</td>
				</cfif>
            </tr>
            <tr>
                <td colspan="2">DE NOTA PROMISSÓRIA À <b>INTERBLOCK COMERCIAL LTDA ME — CNPJ: 02.632.466/0001-35</b></td>
            </tr>
            <tr>
                <td colspan="2">OU A SUA ORDEM DE QUANTIA <b>#ucase(moneyBrExt(query.os_valor))# XXX</b> EM MOEDA CORRENTE DESTE PAÍS
				PAGÁVEL NA PRAÇA DE <b>SANTO ANDRÉ — SP</b></td>
            </tr>
            <tr>
                <td colspan="2" class="line-gap"><b>DADOS DO EMITENTE</b></td>
            </tr>
            <tr>
                <td colspan="1"><b>NOME:</b> #query.cli_nome#</td>
                <td rowspan="4" class="assinatura-gap">
					<br />
					<br />
					<center><span class="line-gap"><u>SANTO ANDRÉ - SP   #LSDateFormat(query.os_data ,"DD-mmmm-YYYY")#<span></u></center>
					<center>Local e Data de Emissão</center>
					<br />
					<br />
					<br />
					_____________________________________
					<br />#query.cli_nome#
				</td>
            </tr>
            <tr>
                <td colspan="1"><b>ENDEREÇO:</b> #query.cli_endereco#, #query.cli_numero#</td>	
            </tr>
            <tr>
                <td colspan="1"><b>BAIRRO:</b> #query.cli_bairro#</td>
			</tr>
			<tr>
				<td colspan="1"><b>CIDADE:</b> #query.cli_cidade# — #query.cli_uf#</td>
            </tr>
            <tr>
                <td>
					<b>CEP:</b> #query.cli_cep#
					<cfif query.cli_pessoa EQ "F">
						<b>CPF:</b> #mid(query.cli_cpfCnpj,1,3)#.#mid(query.cli_cpfCnpj,4,3)#.#mid(query.cli_cpfCnpj,7,3)#-#mid(query.cli_cpfCnpj,10,2)#	
					<cfelse>
						<b>CNPJ:</b> #mid(query.cli_cpfCnpj,1,2)#.#mid(query.cli_cpfCnpj,3,3)#.#mid(query.cli_cpfCnpj,6,3)#/#mid(query.cli_cpfCnpj,9,4)#-#mid(query.cli_cpfCnpj,13,2)#
					</cfif>
				</td>
            </tr>
        </table>
		<br />
		<div class="recibo">
			<table class="">
				<tr>
					<td>Recebi de #uCase(query.cli_nome)#, CPF: <b>#mid(query.cli_cpfCnpj,1,3)#.#mid(query.cli_cpfCnpj,4,3)#.#mid(query.cli_cpfCnpj,7,3)#-#mid(query.cli_cpfCnpj,10,2)#</b> </td>
				<tr>
				<tr>
					<td>a quantia de <b>#LSCurrencyFormat(query.os_valor)#</b> referente a quitação da O.S.: <b>#query.os_numero#</b></td>
				<tr>
				<tr>
					<td width="100%" align="right">
						____________________________________________
						<br/>#uCase(query.tecnico_nome)# <b>CPF:</b> #mid(query.tecnico_cpf,1,3)#.#mid(query.tecnico_cpf,4,3)#.#mid(query.tecnico_cpf,7,3)#-#mid(query.tecnico_cpf,10,2)#
					</table>
					</td>
				<tr>
			</table>
		</div>


		<cfdocumentitem type="footer"> 

		      
		</cfdocumentitem>
									
		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
	
	<cfscript>
		function getStatus( value ){
			switch(value)
			{
				case 0:
				{ 
					return "";
					break;
				}
				
				default:
				{
								
					return "";
					break;
				}
			}
		}
		
	</cfscript>		

</cfoutput>