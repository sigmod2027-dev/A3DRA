
--- Q5 : Join : increase card of the input, Sel(join) = 100M * 6 = 384M, Sel(book) = 520K (before join) , Sel(book) = 2M (after join) ---

---original query ----------
select mtfScenario, upper(book) as ubook , tradeId, legCurrencies 
from tradeFactTable fact
inner join csaDictionaryJoin dict on fact.csaId = dict.csaId
where ubook = 'BOOK90'
format Null
Elapsed: 3.506 sec

---FJD---
select mtfScenario, upper(book) as ubook  , tradeId, legCurrencies 
from(
	select mtfScenario, book ,  tradeId, legCurrencies 
	from tradeFactTable where book = 'book90'
) as fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 2.927 sec

---FDJ---
select mtfScenario,ubook  , tradeId, legCurrencies 
from(
	select mtfScenario, upper(book) as ubook ,  tradeId, legCurrencies 
	from tradeFactTable where book = 'book90'
) as fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 2.896 sec

---JFD---
select mtfScenario, upper(book) as book ,  tradeId, legCurrencies
from (
	select mtfScenario, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
	on fact.mtfScenario = zip.mtfScenario
)
where book = 'book90'
format Null
Elapsed: 35.591 sec

