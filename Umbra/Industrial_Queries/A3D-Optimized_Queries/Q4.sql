--  test("Query with dimension, a scalar metric and a filter on two arrays dimension") 

SELECT
	book,
	SUM( (mtm::BIGINT) * (factor::BIGINT) ) AS sum_mtm
FROM  tradeFactTable 
WHERE
       legIds @> ARRAY['leg6']
      AND array_positions(legCurrencies, 'USD') && array_positions(legIds, 'leg6')
GROUP BY
	book;
