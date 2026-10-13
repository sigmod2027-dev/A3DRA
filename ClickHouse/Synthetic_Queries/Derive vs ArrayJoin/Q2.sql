
--- Q2: derive on scalar column, avg-length(legCurrencies) =3.5 ----

---original query-----

select csaId, upper(book) as ubook , riskFactorSpots , tradeId, legCurrencies 
from tradeFactTable fact
array join legCurrencies
format Null

--- optimized query----

select csaId, ubook , riskFactorSpots , tradeId, legCurrencies 
from (
	select csaId, upper(book) as ubook , riskFactorSpots , tradeId, legCurrencies 
	from tradeFactTable fact
) as fact
array join legCurrencies
format Null

