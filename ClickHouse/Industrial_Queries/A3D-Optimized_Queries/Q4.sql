--  test("Query with dimension, a scalar metric and a filter on two arrays dimension") 

SELECT
	book,
	sum(mtm * factor) AS sum_mtm
FROM  tradeFactTable
WHERE
	arrayExists(legId -> legId IN 'leg6',legIds) AND
	arrayExists(legCurrency,legId -> legCurrency IN 'USD' AND legId IN 'leg6',legCurrencies,legIds) 
	
GROUP BY
	book

