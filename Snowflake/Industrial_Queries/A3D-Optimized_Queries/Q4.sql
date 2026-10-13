--  test("Query with dimension, a scalar metric and a filter on two arrays dimension") 

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT
	book,
	SUM(mtm * factor) AS sum_mtm
FROM  tradeFactTable
WHERE
	ARRAY_CONTAINS('leg6'::variant, legIds) AND
	ARRAY_CONTAINS('USD'::variant, legCurrencies) 
GROUP BY
	book

