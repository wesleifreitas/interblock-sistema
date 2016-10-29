<!--- 
SQL 2012+
--->
<cfabort>
<cfparam name="URL.tickBegin" default="#GetTickCount()#">

<cfoutput>
	<!--- paginação no navegador --->
	<cfparam name="URL.pag" default="1">
	<cfset DSN = "px_interblock_sql_local">
	
	<cfparam name="URL.offSet" default="0">
	<cfset ROWS = 10>
	
	<cfquery name="qTotal" datasource="#variables.DSN#">
		SELECT 
			COUNT(1) AS count
		FROM 
		  dbo.proposta
	</cfquery>
	
	<!--- Recupera dados --->
	<cfquery name="qProposta" datasource="#variables.DSN#">
			SELECT
			prop_id 
			,cli_id
			,prop_primeira_parcela
			,prop_cheque_entrada_primeiro_vencimento
		FROM 
			dbo.proposta
		ORDER BY
			prop_id
		OFFSET #URL.offSet# ROWS
		FETCH NEXT #ROWS# ROWS ONLY;
	</cfquery>

	<!--- <cfdump var="#qProposta.recordCount#">
	<cfabort> --->


	<cfscript>
		total = qTotal.count;
		qntPorPagina = ROWS;
		
		//calculo de paginas
		tempC = total/qntPorPagina;
		paginas = listgetat(tempC,1,'.');
		if (tempC CONTAINS ".") {
			paginas = paginas+1;
		}
								
		//percentagem
		perc = NumberFormat((URL.pag*100)/paginas,'.99');
	</cfscript>
	
	Total de Registros: <strong>#total#</strong><br />
	Quantidade por Pagina: <strong>#qntPorPagina#</strong><br />
	Quantidade de Paginas: <strong>#paginas# (#perc#%)</strong><br />
	Pagina atual: <strong>#URL.pag#</strong><br />
	
	
	<strong>(#LsNumberFormat(perc,'999')#%)</strong><br />
	<table width="#LsNumberFormat(100,'999')*3#" height="20" border="1" style="border:1px solid ##ffffff">
		<tr>
			<td>
			<table  height="20" width="#LsNumberFormat(perc,'999')*3#" border="0" bgcolor="##123456">
				<tr>
					<td bgcolor="##A5DCff"></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	
	<cfset pasta=GetDirectoryFromPath(ExpandPath('index.cfm'))>
	<cfset txt="#pasta#log.txt">
	<!--- <cfdump var="#txt#">
	<cfabort> --->
		
	<cftry>
		<cfset boletos = arrayNew(1)>

		<cfloop query="qProposta">

			<cfquery datasource="#DSN#">
				DELETE FROM
					dbo.pagamento
				WHERE
					con_id = #qProposta.prop_id#
			</cfquery>

			<cfquery datasource="#DSN#" name="qParcela">
				SELECT
					prop_id
					,par_inicio
					,par_fim
					,par_valor
				FROM
					proposta_parcela
				WHERE
					prop_id = #qProposta.prop_id#
			</cfquery>

			<!--- <br /><cfdump var="#qParcela#" label="qParcela"> --->

			<cfquery datasource="#DSN#" name="qParcelaEntrada">
				SELECT
					prop_id
					,par_inicio
					,par_fim
					,par_valor
				FROM
					proposta_parcela_entrada
				WHERE
					prop_id = #qProposta.prop_id#
			</cfquery>

			<!--- <br /><cfdump var="#qParcelaEntrada#" label="qParcelaEntrada"> --->

			<cfset boleto = structNew()>
			
			<cfloop query="qParcela">		
				<cfloop from="#qParcela.par_inicio#" to="#qParcela.par_fim#" index="i">
					<cfscript>
						if (qProposta.prop_primeira_parcela EQ "") {
							continue;
						}

						data = dateAdd("m", i - 1, qProposta.prop_primeira_parcela);
						id = "vencimento_" & LSDateFormat(data, "YYYMMDD");
						boleto[id] = structNew();
						boleto[id]["contrato"] = qProposta.prop_id;				
						boleto[id]["valor"] = qParcela.par_valor;
						boleto[id]["data"] = data;	
						boleto[id]["parcela"] = i;
						boleto[id]["parcela_entrada"] = -1;						
					</cfscript>
				</cfloop>
			</cfloop>

			<cfloop query="qParcelaEntrada">		
				<cfloop from="#qParcelaEntrada.par_inicio#" to="#qParcelaEntrada.par_fim#" index="i">
					<cfscript>
						if (qProposta.prop_cheque_entrada_primeiro_vencimento EQ "") {
							continue;
						}

						data = dateAdd("m", i - 1, qProposta.prop_cheque_entrada_primeiro_vencimento);
						id = "vencimento_" & LSDateFormat(data, "YYYMMDD");
						if(structKeyExists(boleto, id)) {
							boleto[id]["valor"] = boleto[id]["valor"] + qParcelaEntrada.par_valor;
						} else {
							boleto[id] = structNew();
							boleto[id]["contrato"] = qProposta.prop_id;
							boleto[id]["valor"] = qParcelaEntrada.par_valor;
							boleto[id]["data"] = data;	
						}
						boleto[id]["parcela"] = -1;
						boleto[id]["parcela_entrada"] = i;
							
					</cfscript>
				</cfloop>
			</cfloop>

			<cfset arrayAppend(boletos,  boleto)>

		</cfloop>

		<!--- <br /><cfdump var="#boletos#" label="boletos"> --->

		<cfloop array="#boletos#" index="boleto">

			<!--- <cfdump var="#boleto#" label="boleto -> pagamento"> --->

			<cfloop collection="#boleto#" item="item">

				<!--- <br /><cfdump var="#boleto[item]#" label="boleto (collection item)"> --->	

				<cfquery datasource="#arguments.DSN#">
					DELETE FROM
						dbo.pagamento
					WHERE
						con_id = #qProposta.prop_id#
					AND pag_data_vencimento = <cfqueryparam cfsqltype="cf_sql_date" value="#boleto[item].data#">
					AND pag_status = 0;

					INSERT INTO 
						dbo.pagamento
					(				
						con_id,
						pag_status,
						pag_data,
						pag_data_vencimento,
						pag_valor,
						pag_valor_pago,
						par_id,
						par_id_entrada
					) 
					VALUES (
						#boleto[item].contrato#,
						0,
						GETDATE(),
						<cfqueryparam cfsqltype="cf_sql_date" value="#boleto[item].data#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#boleto[item].valor#">,
						0,
						#boleto[item].parcela#,
						#boleto[item].parcela_entrada#
					);
				</cfquery>

			</cfloop>
			
		</cfloop>
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>	
		
	</cftry>
	<!--- <cfabort> --->
		
	<!--- <cfdump var="#qProposta#">
	<cfabort> --->

	<!--- envia para próxima pagina --->
	 <cfif URL.pag LT paginas AND (not isDefined("URL.stop") OR not URL.stop)>
		 <h1>Processando...</h1>	
			<script language="javascript">
				location.href="?pag=#URL.pag+1#&tickBegin=#URL.tickBegin#&offSet=#URL.offSet+ROWS#";
			</script>
		<cfabort>
	<cfelse>
		<cfset tickEnd = GetTickCount()>
		<h1>Processo Executado com Sucesso! </h1>
		<br /><br />
		<font color="AAAAAA">#tickEnd-URL.tickBegin# ms</font>
	</cfif>

</cfoutput>

