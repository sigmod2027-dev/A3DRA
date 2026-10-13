---original query----
SELECT
	tradeId,
	legCurrencies,
	sum(legNotionals) AS sum_legNotionals
	FROM tradeFactTable

ARRAY JOIN
	legCurrencies,legNotionals
GROUP BY
	tradeId,legCurrencies
format Null

---optimized query -----
SELECT
	tradeId,
	c,
	sum(s) AS sum_legNotionals
from(
select  tradeId, c,s 
FROM (
	SELECT
		tradeId,
		legCurrencies,
		sumForEach(legNotionals) AS sum_legNotionals
	FROM tradeFactTable
	GROUP BY
		tradeId,legCurrencies,legNotionals
)
ARRAY JOIN
	legCurrencies as c ,sum_legNotionals as s)
GROUP BY
	tradeId,c
format Null	

