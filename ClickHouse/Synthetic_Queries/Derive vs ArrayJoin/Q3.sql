
--- Q3: derive on the same array column, avg-length(legCurrencies) =3.5 ----

---original query-----

select csaId, book  , tradeId, lower(legCurrencies)  as  r
from tradeFactTable fact
array join legCurrencies
format Null

--- optimized query----

select csaId, book , r , tradeId 
from (
	select csaId, book , arrayMap(x -> lower(x) ,legCurrencies)  as  r , tradeId 
	from tradeFactTable fact
) as fact
array join r
format Null

