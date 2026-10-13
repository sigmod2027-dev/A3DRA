
--- Q7 : compound filters, Sel(['leg1','leg5','leg20']) = 550K (0.55%) ---

--- original query ---------- 

select book, csaId, legId , legalEntities 
from tradeFactTable fact
array join legIds as legId
where legId in ['leg1','leg5','leg20']
format Null


---optimized query -----


select book, csaId, legId , legalEntities 
from(
	select book, csaId, arrayFilter(x -> x in ['leg1','leg5','leg20'],legIds) as legId, legalEntities 
	from tradeFactTable fact
	where legId !=[]
)
array join legId
format Null

