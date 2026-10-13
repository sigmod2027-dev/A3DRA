
--- Q6 : Join : increase card of the input, Sel(join) = 100M * 6 = 384M, Sel(legCurrency) = 61.5M (before join) , Sel(legCurrency) = 236M (after join) , avg-length(legCurrencies) =3.5 ---

---original query ----------
select mtfScenario, book , tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
from tradeFactTable fact
inner join (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
where arrayExists(x -> x='eur', lowerLegCurrencies) 
format Null
Elapsed: 27.328 sec

---DF-J -----
select mtfScenario, book  , tradeId, lowerLegCurrencies 
from (
	select mtfScenario, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies 
	from tradeFactTable 
	where arrayExists(x -> x='eur', lowerLegCurrencies) 
) as fact
inner join  (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
on fact.mtfScenario = zip.mtfScenario
format Null
Elapsed: 17.541 sec

---J-DF ----------
select mtfScenario, book ,  tradeId, arrayMap(x -> lower(x) ,legCurrencies) as lowerLegCurrencies
from (
	select mtfScenario, book  , tradeId, legCurrencies 
	from tradeFactTable fact
	inner join  (select * from testingArrays.shard_datePlotsZipTable zip array join datePlots) as zip 
	on fact.mtfScenario = zip.mtfScenario
)
where arrayExists(x -> x='eur', lowerLegCurrencies) 
format Null
Elapsed: 45.848 sec

