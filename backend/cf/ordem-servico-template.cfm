<style>
    h1 {
        font-size: 1em;
        padding: 10px 10px 0 10px;
    }
    h2 {
        font-size: .9em;
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
        font-size: 14px;
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
        margin-top: 30px;
    }
    .declaracao p{
        margin: 10px;
        text-align: justify;
        font-size: .9em;
    }
    div.assinatura-data{
        margin-top: 30px;
		width: 100%;
		text-align: center;
	}
	table.assinaturas{
        margin: 30px 0 30px 0;
		text-align: center;
		border-spacing: 10px;
		border-collapse: separate;
	}

    .nota td {
        padding-left: 10px;
        font-size: .9em;
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
        padding: 10px 10px 10px 0;
        height: 160px;
        width: auto;
    }
</style>

<cfoutput>	
	<cfset setLocale("Portuguese (Brazilian)")>	
	
	<cftry>
		<cfset BORDER = 0>
		<cfset LOGO_PATH = "../../../assets/logo/logo-interblock.gif">

		<cfquery name="query" datasource="#application.datasource#">
			SELECT
				os_id
                ,os_numero
                ,os_status
                ,os_data
                ,cli_id
                ,vei_id
                ,os_cep
                ,os_endereco
                ,os_numero_endereco
                ,os_complemento
                ,os_bairro
                ,os_cidade
                ,os_uf
                ,os_tel1
                ,os_tel2
                ,os_responsavel
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
			FROM
                vw_ordem_servico
            WHERE
                os_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
		</cfquery>

		<cfset query.cli_cep = NumberFormat(query.cli_cep, '00000000')>
		<cfset query.os_cep = NumberFormat(query.os_cep, '00000000')>

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
					<span class="value">#query.os_responsavel#</span>
				</td>
				<td class="header-item" nowrap>
					<b>Atendente</b><br>
					<span class="value"><span class="value">#query.usu_nome#</span></span>
				</td>		
			</tr>
		</table>

		<h2>Dados do cliente</h2>
		<table width="100%" class="block">
			<tr>	
				<td class="titulo">Nome:</td>
				<td class="valor"><span class="value">#query.cli_nome#</span></td>
				
				<td class="titulo">N° Arquivo:</td>
				<td class="valor">
					<span class="value">
						#query.cli_arquivo#
					</span>
				</td>
			</tr>
			
			<tr>	
				<td class="titulo">Endereço:</td>
				<td class="valor" nowrap>
					<span class="value">
						#query.cli_endereco#, #query.cli_numero#
					</span>
				</td>
				
				<td class="titulo">Complemento:</td>
				<td class="valor"><span class="value">#query.cli_complemento#</span></td>					
			</tr>

			<tr>	
				<td class="titulo">Bairro:</td>
				<td class="valor"><span class="value">#query.cli_bairro#</span></td>
				
				<td class="titulo">Cidade:</td>
				<td class="valor"><span class="value">#query.cli_cidade#</span> - <span><span class="value">SP</span></span></td>
			</tr>

			<tr>	
				<td class="titulo">CEP:</td>
				<td class="valor"><span class="value">#mid(query.cli_cep,1,5)#-#mid(query.cli_cep,6,3)#</span></td>
				
				<td class="titulo">Tel. Residêncial:</td>
				<td class="valor">
					<cfif len(query.cli_tel1) GTE 10>
						<span class="value">#mid(query.cli_tel1,1,2)#-#mid(query.cli_tel1,3,4)#-#mid(query.cli_tel1,7,4)#</span>
					</cfif>
				</td>					
			</tr>

			<tr>					
				<td class="titulo">Tel. Comercial:</td>
				<td class="valor">
					<cfif len(query.cli_tel2) GTE 10>
						<span class="value">#mid(query.cli_tel2,1,2)#-#mid(query.cli_tel2,3,4)#-#mid(query.cli_tel2,7,4)#</span>
					</cfif>
				</td>
				<td class="titulo">Celular:</td>
				<td class="valor">
					<cfif len(query.cli_tel3) GTE 10>
						<span class="value">
							#mid(query.cli_tel3,1,2)#-#mid(query.cli_tel3,3,5)#-#mid(query.cli_tel3,8,4)#
							<cfif len(query.cli_tel4) GTE 10>
								#mid(query.cli_tel4,1,2)#-#mid(query.cli_tel4,3,5)#-#mid(query.cli_tel4,8,4)#
							</cfif>
						</span>
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
					<td class="titulo">Inscri��o estadual:</td>
					<td class="valor">
						<span class="value">
							#query.cli_rgInscricaoEstadual#	
						</span>
					</td>
				</cfif>
			</tr>	

			<tr>					
				<td class="titulo">E-mail:</td>
				<td class="valor">
					<span class="value">
						#query.cli_email#
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

        <h2 class="instalador">Uso do instalador — Serviços executados — CHECKOUT</h2>	
        <div class="checkout">
            <hr>
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
                        <br/>Cliente
                    </td>
                    <td>
                        ____________________________________________
                        <br/>Técnico
                    </td>
                </tr>
            </table>
		</div>

        <table class="block nota" cellpadding="0" cellspacing="0" align="center">
            <tr>
                <td class="rotate" rowspan=11>
                    <!--- <div>NOTA PROMISSÓRIA</div> --->
                    <img src="http://sistema-beta.interblock.com.br/assets/img/ordem-servico/nota.gif" />
                </td>   
            </tr>
            <tr>
                <td>N° ________ VALOR R$ ________ VENCIMENTO ____/____/________</td>
            </tr>
            <tr>
                <td>AOS ________ DIAS DO MÊS E ANO DE ____/________ PAGAREI(EMOS) POR ESTÁ ÚNICA VIA</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>
            <tr>
                <td>[...]</td>
            </tr>

        </table>


		<cfdocumentitem type="footer"> 

		      
		</cfdocumentitem>
									
		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
	
	<cfscript>

		function getTipoPagamento( value ) {
			switch(value)
			{
				case 0:
				{ 
					return "Cheque";
					break;
				}

				case 1:
				{ 
					return "Dinheiro";
					break;
				}
				
				case 2:
				{ 
					return "Boleto";
					break;
				}
									
				default:
				{
								
					return "";
					break;
				}
			}
		}

		function getCheckX ( value ){			
			if(value EQ 1)
				return "[X]";
			else
				return "[<font color='##FFFFFF'>--</font>]";
		}
		
		function getStatus( value ){
			switch(value)
			{
				case 0:
				{ 
					return "PROPOSTA DE ADES�O";
					break;
				}

				case 1:
				{ 
					return "CONTRATO";
					break;
				}
				
				case 2:
				{ 
					return "DOCUMENTO CANCELADO";
					break;
				}
									
				default:
				{
								
					return "DOCUMENTO";
					break;
				}
			}
		}

		function getDeclaracao( os_status ){
			switch(os_status)
			{
				case 0:
				{ 
					return 
					"
					<p>O contratante declara que leu e recebeu todas as informa��es contidas nesta proposta de ades�o.</p>
					<p>O contratante declara que leu e est� ciente dos regulamentos dos contratos em que � participanete.</p>
					<p>O contratante declara que recebeu orienta��o e est� ciente do funcionamento e segredos do sistema.</p>
					";
					break;
				}

				case 1:
				{ 
					return "";
					break;
				}
				
				case 2:
				{ 
					return "";
					break;
				}
									
				default:
				{
								
					return "DOCUMENTO";
					break;
				}
			}
		}
		
	</cfscript>		

</cfoutput>