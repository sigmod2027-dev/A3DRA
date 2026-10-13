
--- Q3 : Join : keep the card of input, Sel(join) = 100M * 3 = 100M , Derive on scalar column ---

---original query------

select csaId, upper(book) , tradeId, legCurrencies 
from tradeFactTable fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 12.496 sec

---D-J -------
select csaId, book  , tradeId, legCurrencies 
from (
	select csaId, upper(book) as book ,  tradeId, legCurrencies 
	from tradeFactTable 
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 12.283 sec

---J-D ------------
select csaId, upper(book) as book ,  tradeId, legCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	left join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
format Null
Elapsed: 12.856 sec
