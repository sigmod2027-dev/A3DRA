
--- Q5 : selective filter, Sel(leg39) = 80k (0.08%) ---

--- original query ---------- 

select book, csaId, legId , legalEntities 
from tradeFactTable fact
array join legIds as legId
where legId = 'leg39'
format Null


---optimized query -----

select book, csaId, legId , legalEntities 
from(
	select book, csaId, arrayFilter(x -> x= 'leg39',legIds) as legId, legalEntities 
	from tradeFactTable fact
	where legId !=[]
)
array join legId
format Null

