
--- Q9 : Empty filter , Sel(1) = 0 (0%)  ---

--- original query ---------- 

select tradeId, mtf , mtfScenario, mtm, notional  
from tradeFactTable fact
array join mtf 
where mtf = 1
format Null

---optimized query -----

select tradeId, mtf , mtfScenario, mtm, notional 
from(
	select tradeId, arrayFilter(x -> x= 1 ,mtf) as mtf , mtfScenario, mtm, notional   
	from tradeFactTable fact
	where mtf!=[]
)
array join mtf
format Null

