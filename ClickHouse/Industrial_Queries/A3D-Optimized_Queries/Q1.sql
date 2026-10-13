--test("Simple query with an array dimension, a scalar metric and a filter on the array dimension")

SELECT
	book,
	legType,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		book,
		legTypes,
		sum(mtm * factor) AS sum_mtm,
		arrayDistinct(arrayFilter(legType -> legType IN 'call',if(notEmpty(legTypes),legTypes,[NULL]))) AS legType
	FROM  tradeFactTable
	WHERE
		arrayExists(legType -> legType IN 'call',legTypes) 
	GROUP BY
		book,
		legTypes
)
ARRAY JOIN
	legType
GROUP BY
	book,
	legType






        
