
--- Q3 : Join : keep the card of input, Sel(join) = 100M * 3 = 100M, Sel(book) = 520K (before join) , Sel(book) = 520K (after join) ---

---original query ----------
select csaId, upper(book) as ubook , tradeId, legCurrencies 
from tradeFactTable fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
where ubook = 'BOOK90'
format Null
Elapsed: 3.382 sec


---FJD---
select csaId, upper(book) as ubook  , tradeId, legCurrencies 
from(
	select csaId, book ,  tradeId, legCurrencies 
	from tradeFactTable where book = 'book90'
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.040 sec

---FDJ---
select csaId,ubook  , tradeId, legCurrencies 
from(
	select csaId, upper(book) as ubook ,  tradeId, legCurrencies 
	from tradeFactTable where book = 'book90'
) as fact
left join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.018 sec

---JFD---
select csaId, upper(book) as book ,  tradeId, legCurrencies
from (
	select csaId, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	left join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
where book = 'book90'
format Null
Elapsed: 12.825 sec

