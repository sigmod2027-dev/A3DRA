
--- Q4 : Join : keep the card of input, Sel(join) = 100M * 3 = 100M, Derive on array column ---

---original query------

select csaId, book , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies
from tradeFactTable fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 13.003 sec

---D-J -------
select csaId, book  , tradeId, legCurrencies 
from (
	select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies 
	from tradeFactTable 
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 12.714 sec

---J-D ------------
select csaId, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	left join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
format Null
Elapsed: 13.103 sec
