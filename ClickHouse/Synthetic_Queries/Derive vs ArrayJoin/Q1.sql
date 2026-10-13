
--- Q1: derive on scalar column, large array: avg-length(riskFactorSpots) =6.68 ----

---original query-----

select csaId, upper(book) as ubook , riskFactorSpots , tradeId, legCurrencies 
from tradeFactTable fact
array join riskFactorSpots
format Null

--- optimized query----

select csaId, ubook , riskFactorSpots , tradeId, legCurrencies 
from (
	select csaId, upper(book) as ubook , riskFactorSpots , tradeId, legCurrencies 
	from tradeFactTable fact
) as fact
array join riskFactorSpots
format Null

