
--- Q4: derive on the same array column, avg-length(riskFactorSpots) =6.68 ----

---original query-----

select csaId, book , round(riskFactorSpots ,2) as  r , tradeId, legCurrencies 
from tradeFactTable fact
array join riskFactorSpots
format Null

--- optimized query----

select csaId, book , r , tradeId, legCurrencies 
from (
	select csaId, book , arrayMap(x -> round(x ,2),riskFactorSpots)  as  r , tradeId, legCurrencies 
	from tradeFactTable fact
) as fact
array join r
format Null

