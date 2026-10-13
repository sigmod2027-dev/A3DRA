
--- Q4 : non-selective filter, Sel(0) = 50M (50%), Large array : riskFactorSpots ---

--- original query ---------- 

select book, mtf, riskFactorSpots  
from tradeFactTable fact
array join riskFactorSpots as riskFactorSpot
where arrayExists(x->x=0, mtf)
format Null

---optimized query -----

select book, mtf, riskFactorSpot 
from(
select book, mtf, riskFactorSpots
from tradeFactTable fact
where arrayExists(x->x=0, mtf)
)
array join riskFactorSpots as riskFactorSpot
format Null


