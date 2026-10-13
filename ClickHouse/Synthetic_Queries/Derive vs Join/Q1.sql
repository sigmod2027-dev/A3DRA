
--- Q1 : Join : Reduce card of input, Sel(join) = 100M * 3 = 140K , Derive on scalar column ---

---original query------

select csaId, upper(book) , tradeId, legCurrencies 
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 3.936 sec

---D-J -------
select csaId, book  , tradeId, legCurrencies 
from (
select csaId, upper(book) as book ,  tradeId, legCurrencies 
from tradeFactTable 
) as fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
format Null
Elapsed: 11.679 sec

---J-D ------------
select csaId, upper(book) as book ,  tradeId, legCurrencies
from (
select csaId, book  , tradeId, legCurrencies 
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
)
format Null
Elapsed: 3.688 sec
