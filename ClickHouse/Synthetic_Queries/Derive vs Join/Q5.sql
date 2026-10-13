
--- Q5 : Join : increase card of the input, Sel(join) = 100M * 6 = 384M , Derive on scalar column ---

---original query------

select mtfScenario, upper(book) , tradeId, legCurrencies 
from tradeFactTable fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 36.239 sec

---D-J -------
select mtfScenario, book  , tradeId, legCurrencies 
from (
	select mtfScenario, upper(book) as book ,  tradeId, legCurrencies 
	from tradeFactTable 
) as fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 16.235 sec

---J-D ------------
select mtfScenario, upper(book) as book ,  tradeId, legCurrencies
from (
	select mtfScenario, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
	on fact.mtfScenario = zip.mtfScenario
)
format Null
Elapsed: 36.466 sec
