
--- Q5 : Join : increase card of the input, Sel(join) = 100M * 6 = 384M, Sel(book) = 520K (before join) , Sel(book) = 2M (after join) ---

---original query ----------
select mtfScenario, upper(book) as ubook , tradeId, legCurrencies 
from tradeFactTable fact
inner join  (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
where ubook = 'BOOK90'
format Null
Elapsed: 2.611 sec

---DF-J -----
select mtfScenario, ubook  , tradeId, legCurrencies 
from (
	select mtfScenario, upper(book) as ubook ,  tradeId, legCurrencies 
	from tradeFactTable where ubook = 'BOOK90'
) as fact
inner join  (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 11.049 sec

---J-DF ----------
select mtfScenario, upper(book) as ubook ,  tradeId, legCurrencies
from (
	select mtfScenario, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join  (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
	on fact.mtfScenario = zip.mtfScenario
)
where ubook = 'BOOK90'
format Null
Elapsed: 38.281 sec

