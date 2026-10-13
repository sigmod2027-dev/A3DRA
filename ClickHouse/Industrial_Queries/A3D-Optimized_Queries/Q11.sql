--  test("Query with a dimension and a filter on group based array dimension and a filter on array dimension linked to the source of the group")

SELECT
	book,
	sum(mtm * factor) AS sum_mtm
FROM tradeFactTable
WHERE
	arrayExists(legCurrency,legType -> legType IN ('put','futureSpread','call') AND legCurrency IN 'GBP',legCurrencies,legTypes) AND
	arrayExists(legCurrency -> legCurrency IN 'GBP',legCurrencies) 
GROUP BY
	book

