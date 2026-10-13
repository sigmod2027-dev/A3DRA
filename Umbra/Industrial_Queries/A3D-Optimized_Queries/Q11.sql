--  test("Query with a dimension and a filter on group based array dimension and a filter on array dimension linked to the source of the group")


SELECT
	book,
	SUM( (mtm::BIGINT) * (factor::BIGINT) ) AS sum_mtm
FROM  tradeFactTable
WHERE
	legCurrencies @> ARRAY['GBP'] AND
	(array_positions(legTypes,'put') && array_positions(legCurrencies,'GBP') OR 
	array_positions(legTypes,'futureSpread') && array_positions(legCurrencies,'GBP') OR 
	array_positions(legTypes,'call') && array_positions(legCurrencies,'GBP'))
GROUP BY
	book;
