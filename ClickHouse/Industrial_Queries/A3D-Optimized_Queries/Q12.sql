-- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on group based array")

SELECT
	book,
	legType,
	legalEntity,
	sum(sum_mtm) AS sum_mtm
FROM (
	
			SELECT
				legTypes,
				book,
				legalEntities,
				sum(mtm * factor) AS sum_mtm,
				rowNumberInAllBlocks() AS bid,
				arrayDistinct(arrayFilter(legalEntity -> legalEntity IN 'FR',if(notEmpty(legalEntities),legalEntities,[NULL]))) AS legalEntity,
				arrayDistinct(arrayFilter(legType -> legType IN 'put',if(notEmpty(legTypes),legTypes,[NULL]))) AS legType
			FROM tradeFactTable
			WHERE
				arrayExists(legalEntity -> legalEntity IN 'FR',legalEntities) AND
				arrayExists(legType -> legType IN 'put',legTypes) 
			GROUP BY
				book,
				legTypes,
				legalEntities
		)
		ARRAY JOIN
			legType
			
	
	ARRAY JOIN
		legalEntity
GROUP BY
	book,
	legType,
	legalEntity

