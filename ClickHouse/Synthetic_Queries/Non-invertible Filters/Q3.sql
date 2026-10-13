
--- Q3 : Join : keep the card of input, Sel(join) = 100M * 3 = 100M, Sel(book) = 520K (before join) , Sel(book) = 520K (after join) ---

---original query ----------
select csaId, upper(book) as ubook , tradeId, legCurrencies 
from tradeFactTable fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
where ubook = 'BOOK90'
format Null
Elapsed: 3.182 sec

---DF-J -----
select csaId, ubook  , tradeId, legCurrencies 
from (
	select csaId, upper(book) as ubook ,  tradeId, legCurrencies 
	from tradeFactTable where ubook = 'BOOK90'
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.203 sec

---J-DF ----------
select csaId, upper(book) as ubook ,  tradeId, legCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	left join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
where ubook = 'BOOK90'
format Null
Elapsed: 13.263 sec

