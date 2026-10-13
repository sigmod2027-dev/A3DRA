-- test("Query with a dimension, a metric and a filter on group based on an array")

SELECT
	book,
	sum(mtm * factor) AS sum_mtm
FROM tradeFactTable
WHERE
	arrayExists(legalEntity -> legalEntity IN ('FR','UK','US'),legalEntities)
GROUP BY
	book

