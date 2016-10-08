<cfset DSN = "px_interblock_sql_local">

<cfquery datasource="#DSN#" name="qProposta">
	SELECT
		prop_id 
		,cli_id
		,prop_primeira_parcela
		,prop_cheque_entrada_primeiro_vencimento
	FROM 
		dbo.proposta
	ORDER BY
		prop_id
</cfquery>

<cfdump var="#qProposta#">


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

	<br /><cfdump var="#qParcela#" label="qParcela">

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

	<br /><cfdump var="#qParcelaEntrada#" label="qParcelaEntrada">

	<cfset boleto = structNew()>
	
	<cfloop query="qParcela">		
		<cfloop from="#qParcela.par_inicio#" to="#qParcela.par_fim#" index="i">
			<cfscript>
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
		<cfloop from="#qParcela.par_inicio#" to="#qParcela.par_fim#" index="i">
			<cfscript>
				data = dateAdd("m", i - 1, qProposta.prop_cheque_entrada_primeiro_vencimento);
				id = "vencimento_" & LSDateFormat(data, "YYYMMDD");
				if(structKeyExists(boleto, id)) {
					boleto[id]["valor"] = boleto[id]["valor"] + qParcela.par_valor;
				} else {
					boleto[id] = structNew();
					boleto[id]["contrato"] = qProposta.prop_id;
					boleto[id]["valor"] = qParcela.par_valor;
					boleto[id]["data"] = data;	
				}
				boleto[id]["parcela"] = -1;
				boleto[id]["parcela_entrada"] = i;
					
			</cfscript>
		</cfloop>
	</cfloop>

	<cfset arrayAppend(boletos,  boleto)>

</cfloop>

<br /><cfdump var="#boletos#" label="boletos">

<cfloop array="#boletos#" index="boleto">

	<!--- <cfdump var="#boleto#" label="boleto -> pagamento"> --->

	<cfloop collection="#boleto#" item="item">
		<br /><cfdump var="#boleto[item]#" label="boleto (collection item)">	

		
		<cfquery datasource="#DSN#">
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

<br />:)