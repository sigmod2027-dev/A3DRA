
--- Q2 : selective filter, Sel(book1) = 510k (0.51%), Large array : riskFactorSpots ---

--- original query ----------

select book, csaId, riskFactorSpot  
from tradeFactTable fact
array join riskFactorSpots as riskFactorSpot
where book = 'book1'
format Null

---optimized query -----

select book, csaId, riskFactorSpots 
from(
select book, csaId, riskFactorSpots
from tradeFactTable fact
where book = 'book1'
)
array join riskFactorSpots as riskFactorSpot
format Null


