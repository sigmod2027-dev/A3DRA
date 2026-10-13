
--- Q4 : Join : keep the card of input,Sel(join) = 100M * 3 = 100M, Sel(legCurrency) = 61.5M (before join) , Sel(legCurrency) = 61.5M (after join) , avg-length(legCurrencies) =3.5 ----

---original query ----------
select csaId, book , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
from tradeFactTable fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
where arrayExists(x -> x='eur', lowerLegCurrencies) 
format Null
Elapsed: 11.957 sec

---FJD---
select csaId, book  , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies  
from (
	select csaId, book ,  tradeId, legCurrencies
	from tradeFactTable 
	where arrayExists(x -> x='EUR', legCurrencies) 
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 11.141 sec

----FDJ----
select csaId, book  , tradeId, lowerLegCurrencies  
from (
	select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
	from tradeFactTable 
	where arrayExists(x -> x='EUR', legCurrencies) 
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 11.343 sec

---JFD---
select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	left join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
where arrayExists(x -> x='EUR', legCurrencies) 
format Null
Elapsed: 14.400 sec

