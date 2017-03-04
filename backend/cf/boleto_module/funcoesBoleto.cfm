
<cfscript>
/**
*Criado por Abílio Cipriano ( abilio@gmail.com )
*Funções: chave,codigoBarra,linhaDigitavel
*
*Função barCode foi copiada de outra linguagem e reescrita em CF.
*/
function chave(agencia,conta,sequencial)
{
	while(len(sequencial) lt 6)
		sequencial = "0" &sequencial;
	nChave = "000"&agencia&conta&"1"&sequencial&"070";
	mult = 7;
	dig1=0;
	dig2=0;
	x="";
	soma=0;
	peso=0;
	tripa="";
	for(i=1;i lte 23;i=i+1)
	{
		x = Mid(nChave,i,1);
		if(i mod 2 eq 0)
			soma = soma + x;
		else
		{
			peso = x * 2;
			if(peso gt 9)
				peso = peso - 9;
			soma = soma + peso;
		}
	}
	dig1 = (soma mod 10);
	if(dig1 is 0) dig1 = 0;
	if(dig1 gt 0)
		dig1 = 10 - dig1;
	nChave2Dig="";
	nChave2Dig = nChave;
	nChave2Dig = nChave2Dig&dig1;
	soma=0;
	for(i=1;i lte 24;i=i+1)
	{
		x = Mid(nChave2Dig,i,1);
		soma = soma + (mult*x);
		mult = mult -1;
		if(mult eq 1) mult=7;
	}
	dig2 = (soma mod 11);
	if(dig2 is 1)
	{
		mult = 7;
		soma=0;
		dig1 = dig1 + 1;
		if(dig1 is 10) dig1 =0;
		nChave2Dig = nChave&dig1;
		for(i=1;i lte 24;i=i+1)
		{
			x = Mid(nChave2Dig,i,1);
			soma = soma + (mult*x);
			mult = mult -1;
			if(mult eq 1) mult=7;
		}
		dig2 = (soma mod 11);
	}
	if(dig2 is 0) dig2 =0;
	if(dig2 gt 1) dig2 = 11 - dig2;
	tripa = nChave2Dig&dig2;
	return tripa;
}

function codigoBarra(dataVencimento,valor,nChave)
{
	v = Replace(valor,".","","all");
	while(len(v) lt 10)
		v = "0" &v;
	database= "07/10/1997";
	dataVen = DateDiff("d",CreateDate(ListGetAt(LSDateFormat(database,'DD/MM/YYYY'),3,'/'),ListGetAt(LSDateFormat(database,'DD/MM/YYYY'),2,'/'),ListGetAt(LSDateFormat(database,'DD/MM/YYYY'),1,'/')),CreateDate(ListGetAt(LSDateFormat(dataVencimento,'DD/MM/YYYY'),3,'/'),ListGetAt(LSDateFormat(dataVencimento,'DD/MM/YYYY'),2,'/'),ListGetAt(LSDateFormat(dataVencimento,'DD/MM/YYYY'),1,'/')));

	nCodeBar="0709"&dataVen&v&nChave;
	mult = 4;
	dig=0;
	x="";
	soma=0;
	grupo1="";
	grupo2="";
	tripa="";
	for(i=1;i lte 43;i=i+1)
	{
		x = Mid(nCodeBar,i,1);
		soma = soma + (mult*x);
		mult = mult -1;
		if(mult eq 1) mult=9;
	}
	dig = (soma mod 11);
	if(dig is 0 or dig is 1 or dig is 10) 
		dig = 1;
	else
		dig = 11 - dig;
	grupo1 = Mid(nCodeBar,1,4);
	grupo2 = Mid(nCodeBar,5,43);
	tripa = grupo1&dig&grupo2;
	return tripa;
}

function linhaDigitavel(chave,codBarra)
{
	grupo1 ="0709"&mid(chave,1,5);
	somaGrupo1=0;
	digGrupo1=0;
	grupo2 =mid(chave,6,10);
	somaGrupo2=0;
	digGrupo2=0;
	grupo3 =mid(chave,16,10);
	somaGrupo3=0;
	digGrupo3=0;
	uniaoGrupo123 = grupo1&grupo2&grupo3;
	uniaoGrupoDigito = "";
	grupo4=mid(codBarra,5,1);
	grupo5=mid(codBarra,6,4);
	grupo6=mid(codBarra,10,10);

	x="";

	for(i=1;i lte 29;i=i+1)
	{
		x = Mid(uniaoGrupo123,i,1);
		if(i mod 2 eq 0)
		{
			if(i lte 9)
				somaGrupo1 = somaGrupo1 + x;
			if(i gt 9 and i lte 19)
				somaGrupo2 = somaGrupo2 + x;
			if(i gt 19)
				somaGrupo3 = somaGrupo3 + x;
		}
		else
		{
			peso = x * 2;
			if(peso gt 9)
				peso = peso - 9;
			if(i lte 9)
				somaGrupo1 = somaGrupo1 + peso;
			if(i gt 9 and i lte 19)
				somaGrupo2 = somaGrupo2 + peso;
			if(i gt 19)
				somaGrupo3 = somaGrupo3 + peso;
		}
	}

	digGrupo1 = (somaGrupo1 mod 10);
	if(digGrupo1 is 0) digGrupo1 = 0;
	if(digGrupo1 gt 0)
		digGrupo1 = 10 - digGrupo1;

	digGrupo2 = (somaGrupo2 mod 10);
	if(digGrupo2 is 0) digGrupo2 = 0;
	if(digGrupo2 gt 0)
		digGrupo2 = 10 - digGrupo2;

	digGrupo3 = (somaGrupo3 mod 10);
	if(digGrupo3 is 0) digGrupo3 = 0;
	if(digGrupo3 gt 0)
		digGrupo3 = 10 - digGrupo3;	 

	uniaoGrupoDigito = grupo1&digGrupo1&grupo2&digGrupo2&grupo3&digGrupo3&grupo4&grupo5&grupo6;
	return uniaoGrupoDigito;
}

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

	WriteOutput("<img src='pr.gif' width='"&fino&"' height='"&altura&"'>");
	WriteOutput("<img src='br.gif' width='"&fino&"' height='"&altura&"'>");
	WriteOutput("<img src='pr.gif' width='"&fino&"' height='"&altura&"'>");
	WriteOutput("<img src='br.gif' width='"&fino&"' height='"&altura&"'>");
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
			WriteOutput(" src='pr.gif' width='"&f1&"' height='"&altura&"'><img");
			if(mid(f, i, 1) EQ "0")
				f2 = fino;
			else
				f2 = largo;
			WriteOutput(" src='br.gif' width='"&f2&"' height='"&altura&"'><img");
		}
	}

	WriteOutput(" src='pr.gif' width='"&largo&"' height='"&altura&"'>");
	WriteOutput("<img src='br.gif' width='"&#fino#&"' height='"&altura&"'>");
	WriteOutput("<img src='pr.gif' width='1' height='"&altura&"'>");

}
</cfscript>