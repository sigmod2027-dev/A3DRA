
--- Q1 : Join : Reduce card of input, Sel(join) = 100M * 3 = 140K, Sel(book) = 520K (before join) , Sel(book) = 10K (after join) ---

---original query ----------
select csaId, upper(book) as ubook , tradeId, legCurrencies 
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
where ubook = 'BOOK90'
format Null
Elapsed: 3.151 sec

---DF-J -----
select csaId, ubook  , tradeId, legCurrencies 
from (
	select csaId, upper(book) as ubook ,  tradeId, legCurrencies 
	from tradeFactTable where ubook = 'BOOK90'
) as fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.208 sec

---J-DF ----------
select csaId, upper(book) as ubook ,  tradeId, legCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
where ubook = 'BOOK90'
format Null
Elapsed: 3.990 sec
