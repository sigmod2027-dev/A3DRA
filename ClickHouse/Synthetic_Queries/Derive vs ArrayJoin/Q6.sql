
--- Q6: derive on the same array column and another scalar column, avg-length(riskFactorSpots) =6.68 ----

---original query-----

select csaId, book , riskFactorSpots * mtm as r , tradeId, legCurrencies 
from tradeFactTable fact
array join riskFactorSpots
format Null

--- optimized query----

select csaId, book , r , tradeId, legCurrencies 
from (
	select csaId, book , arrayMap(x -> x *mtm ,riskFactorSpots)  as  r , tradeId, legCurrencies 
	from tradeFactTable fact
) as fact
array join r
format Null

