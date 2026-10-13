--test("Simple query with a simple dimension, a scalar metric and a filter on the array dimension handle a filter on a dimensional array which is not in by when not transposing any other array")

SELECT
	book,
	sum(mtm * factor) AS sum_mtm
FROM  tradeFactTable
WHERE
	arrayExists(legType -> legType IN 'call',legTypes) 
GROUP BY
	book

