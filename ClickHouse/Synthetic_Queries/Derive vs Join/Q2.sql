
--- Q2 : Join : Reduce card of input, Sel(join) = 100M * 3 = 140K, Derive on array column ---

---original query------

select csaId, book , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.848 sec

---D-J -------
select csaId, book  , tradeId, legCurrencies 
from (
	select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies 
	from tradeFactTable 
) as fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 11.822 sec

---J-D ------------
select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
format Null
Elapsed: 3.659 sec
