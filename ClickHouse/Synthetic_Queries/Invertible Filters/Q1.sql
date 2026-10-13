
--- Q1 : Join : Reduce card of input, Sel(join) = 100M * 3 = 140K, Sel(book) = 520K (before join) , Sel(book) = 10K (after join) ---

---original query ----------
select csaId, upper(book) as ubook , tradeId, legCurrencies 
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
where ubook = 'BOOK90'
format Null
Elapsed: 3.286 sec

---FJD -----
select csaId, upper(book) as ubook  , tradeId, legCurrencies 
from(
	select csaId, book ,  tradeId, legCurrencies 
	from tradeFactTable where book = 'book90'
) as fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.074 sec

---FDJ----
select csaId,ubook  , tradeId, legCurrencies 
from(
	select csaId, upper(book) as ubook ,  tradeId, legCurrencies 
	from tradeFactTable where book = 'book90'
) as fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.098 sec

---JFD ----
select csaId, upper(b) as book ,  tradeId, legCurrencies
from (
	select csaId, book as b  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
where b = 'book90'
format Null
Elapsed: 4.003 sec
