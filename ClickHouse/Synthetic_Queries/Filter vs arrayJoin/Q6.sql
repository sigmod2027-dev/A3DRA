
--- Q6 : non-selective filter , Sel(leg299) = 12M (12%) ---

--- original query ---------- 

select book, csaId, legId , legalEntities 
from tradeFactTable fact
array join legIds as legId
where legId = 'leg299'
format Null


---optimized query -----


select book, csaId, legId , legalEntities 
from(
	select book, csaId, arrayFilter(x -> x= 'leg299',legIds) as legId, legalEntities 
	from tradeFactTable fact
	where legId !=[]
)
array join legId
format Null

