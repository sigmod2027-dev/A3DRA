
--- Q3 : non-selective filter, Sel(0) = 50M (50%) ---

--- original query ----------

select book, mtf, legId  
from tradeFactTable fact
array join legIds as legId
where arrayExists(x->x=0, mtf)
format Null

---optimized query -----

select book, mtf, legId 
from(
	select book, mtf, legIds
	from tradeFactTable fact
	where arrayExists(x->x=0, mtf)
)
array join legIds as legId
format Null


