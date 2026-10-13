
--- Q11 : selective Filter Sel(116740.0) = 10k (0.01%) , large array  ---

--- original query ---------- 

select book, csaId, counterparty , riskFactorSpot 
from tradeFactTable fact
array join riskFactorSpots as riskFactorSpot
where riskFactorSpot = 116740.0
format Null

---optimized query -----

select book, csaId, counterparty , riskFactorSpot 
from(
	select book, csaId, counterparty , arrayFilter(x -> x= 116740.0,riskFactorSpots) as riskFactorSpot
	from tradeFactTable fact
	where riskFactorSpot!=[]
)
array join riskFactorSpot
format Null

