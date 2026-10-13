-- test("Query with a dimension, an array, a metric and a filter on group based array the array")
 
 SELECT
	book,
	legalEntity,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		book,
		legalEntities,
		sum(mtm * factor) AS sum_mtm,
		arrayDistinct(arrayFilter(legalEntity -> legalEntity IN ('FR','UK','US'),if(notEmpty(legalEntities),legalEntities,[NULL]))) AS legalEntity
	FROM tradeFactTable
	WHERE
		arrayExists(legalEntity -> legalEntity IN ('FR','UK','US'),legalEntities)
	GROUP BY
		book,
		legalEntities
)
ARRAY JOIN
	legalEntity
GROUP BY
	book,
	legalEntity

