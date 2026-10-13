
--- Q8 : non-selective filter , Sel(0) = 50M (50%) ---

--- original query ---------- 

select tradeId, mtf  , mtfScenario, mtm, notional  
from tradeFactTable fact
array join mtf
where mtf = 0
format Null


---optimized query -----


select tradeId, mtf , mtfScenario, mtm, notional 
from(
	select tradeId, arrayFilter(x -> x= 0 ,mtf) as mtf , mtfScenario, mtm, notional   
	from tradeFactTable fact
	where mtf!=[]
)
array join mtf
format Null




