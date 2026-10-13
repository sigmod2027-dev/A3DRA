 -- test("Query with a dimension, an array and, and a metric that are not optimizable and that have plus inside and outside")

SELECT
	book,
	legType,
	arrayReduce('sum',tupleElement(groupUniqArray((bid,avg_mtm00,avg_mtm01)),2)) / arrayReduce('sum',tupleElement(groupUniqArray((bid,avg_mtm00,avg_mtm01)),3)) + 2 AS avg_mtm,
	sum(avg_legNotional00) / sum(avg_legNotional01) + 2 AS avg_legNotional
FROM (
	SELECT
		sum(if(isNull(mtm + 3),0,super.nb_aggregated) * factor) AS avg_mtm01,
		sumForEach(arrayMap(legNotional -> (legNotional + 3) * factor,legNotionals)) AS avg_legNotional00,
		sumForEach(arrayMap(legNotional -> if(isNull(legNotional + 3),0,super.nb_aggregated) * factor,legNotionals)) AS avg_legNotional01,
		sum((mtm + 3) * factor) AS avg_mtm00,
		legTypes,
		book,
		arrayEnumerate(avg_legNotional00) AS _arrayGroupIdx0,
		rowNumberInAllBlocks() AS bid,
		if(notEmpty(legTypes),legTypes,[NULL]) AS legType
	FROM  tradeFactTable AS super
	GROUP BY
		book,
		legTypes
)
ARRAY JOIN
	avg_legNotional00,
	avg_legNotional01,
	legType
GROUP BY
	book,
	legType

