
--- Q10 : Full-selectivity filter , Sel(BCE) = 100M (100%)  ---

--- original query ---------- 

select book, csaId, legIds , legalEntity 
from tradeFactTable fact
array join legalEntities as legalEntity
where legalEntity = 'BCE'
format Null



---optimized query -----

select book, csaId, legIds , legalEntity 
from(
	select book, csaId, legIds , arrayFilter(x -> x= 'BCE',legalEntities) as legalEntity
	from tradeFactTable fact
	where legalEntity!=[]
)
array join legalEntity
format Null


