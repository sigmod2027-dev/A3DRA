
--- Q2 : Join : Reduce card of input, Sel(join) = 100M * 3 = 140K, Sel(legCurrency) = 61.5M (before join) , Sel(legCurrency) = 40K (after join) , avg-length(legCurrencies) =3.5 ---

---original query ----------
select csaId, book , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
where arrayExists(x -> x='eur', lowerLegCurrencies) 
format Null
Elapsed: 7.483 sec

---DF-J -----
select csaId, book  , tradeId, lowerLegCurrencies 
from (
	select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies 
	from tradeFactTable 
	where arrayExists(x -> x='eur', lowerLegCurrencies) 
) as fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 10.938 sec

---J-DF ----------
select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
where arrayExists(x -> x='eur', lowerLegCurrencies) 
format Null
Elapsed: 3.867 sec
