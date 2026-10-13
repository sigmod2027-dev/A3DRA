--test("Query with a dimension, an array and another array dimension from another group, and a metric of array and a scalar metric")

SELECT
	legType,
	arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm,
	legalEntity,
	arrayReduce('sum',tupleElement(groupUniqArray((bid,_arrayGroupIdx0,sum_legNotional)),3)) AS sum_legNotional,
	book
FROM (
	SELECT
		_arrayGroupIdx0,
		legType,
		sum_legNotional,
		legTypes,
		book,
		legalEntities,
		sum_mtm,
		bid,
		legalEntity
	FROM (
		SELECT
			arrayMap(x -> x * factor,legNotionals) AS sum_legNotional,
			legTypes,
			book,
			legalEntities,
			mtm * factor AS sum_mtm,
			rowNumberInAllBlocks() AS bid,
			if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
			arrayEnumerate(legType) AS _arrayGroupIdx0,
			if(notEmpty(legalEntities),legalEntities,[NULL]) AS legalEntity
		FROM  tradeFactTable
	)
	ARRAY JOIN
		_arrayGroupIdx0,
		legType,
		sum_legNotional
)
ARRAY JOIN
	legalEntity
GROUP BY
	book,
	legType,
	legalEntity

