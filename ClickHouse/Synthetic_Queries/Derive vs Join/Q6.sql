
--- Q6 : Join : increase card of the input, Sel(join) = 100M * 6 = 384M, Derive on array column ---

---original query------

select mtfScenario, book , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies
from tradeFactTable fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 36.794 sec

---D-J -------
select mtfScenario, book  , tradeId, legCurrencies 
from (
	select mtfScenario, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies 
	from tradeFactTable 
) as fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 16.998 sec

---J-D ------------
select mtfScenario, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as legCurrencies
from (
	select mtfScenario, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
	on fact.mtfScenario = zip.mtfScenario
)
format Null
Elapsed: 38.251 sec
