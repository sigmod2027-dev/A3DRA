
--- Q1 : selective filter, Sel(book1) = 510k (0.51%) ---

--- original query ----------

select  book, csaId, legId  
from tradeFactTable fact
array join legIds as legId
where book = 'book1'
format Null

---optimized query -----

select book, csaId, legId 
from(
select book, csaId, legIds
from tradeFactTable fact
where book = 'book1'
)
array join legIds as legId
format Null


