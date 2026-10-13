-- test("Query with a dimension, a group non-injective based on an array, a metric and a filter on the base array of the group")

SELECT
	book,
	legalEntityContinentNiGroup,
	sum(sum_mtm) AS sum_mtm
FROM (

			SELECT
				book,
				legalEntities,
				sum(mtm * factor) AS sum_mtm,
				rowNumberInAllBlocks() AS bid,
				arrayFilter(legalEntity -> legalEntity IN ('FR','UK'),if(notEmpty(legalEntities),legalEntities,[NULL])) AS legalEntity
			FROM tradeFactTable
			WHERE
				arrayExists(legalEntity -> legalEntity IN ('FR','UK'),legalEntities) 
			GROUP BY
				book,
				legalEntities
		)
		ARRAY JOIN
			arrayDistinct(arrayMap(x->transform(ifNull(toString(x),''),['FR','UK'],['EU','EU'],'others'),legalEntity)) AS legalEntityContinentNiGroup			


GROUP BY
	book,
	legalEntityContinentNiGroup

