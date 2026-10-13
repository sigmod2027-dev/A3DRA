--test("Query with a dimension, an array and another array dimension from another group, and a metric of array and a scalar metric")

SELECT
	legType,
	arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm,
	legalEntity,
	sum(b) AS x,
	book

FROM (
		SELECT
			sumForEach(arrayMap(x -> x * factor,legNotionals)) AS sum_legNotional,
			legTypes,
			book,
			legalEntities,
			sum(mtm * factor) AS sum_mtm,
			rowNumberInAllBlocks() AS bid,
			if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
			arrayDistinct(if(notEmpty(legalEntities),legalEntities,[NULL])) AS legalEntity
		FROM  tradeFactTable
		GROUP BY
			book,
			legTypes,
			legalEntities
	)
	ARRAY JOIN
	legalEntity
	ARRAY JOIN
		legType,
		sum_legNotional as b

GROUP BY
	book,
	legType,
	legalEntity

