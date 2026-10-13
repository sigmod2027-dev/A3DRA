-- test("Query with a dimension, an array and another array dimension from another group, filtered by a OR on both group")

 SELECT
	book,
	legType,
	legalEntity,
	sum(sum_mtm) AS sum_mtm
 
	FROM (
				SELECT
					csaId,
					legTypes,
					book,
					legalEntities,
					sum(mtm * factor) AS sum_mtm,
					arrayDistinct(arrayFilter(csaId,legType,legalEntity -> csaId IN 'csa1' OR legType IN 'put' OR legalEntity IN 'FR',
						arrayFlatten(arrayMap(x -> arrayMap(y -> (csaId,x, y), if(notEmpty(legalEntities),legalEntities,[NULL])), 
						if(notEmpty(legTypes),legTypes,[NULL]) )))) AS _csaIdLegTypeLegalEntity,
					tupleElement(_csaIdLegTypeLegalEntity,2) AS legType,
					tupleElement(_csaIdLegTypeLegalEntity,3) AS legalEntity
				FROM  tradeFactTable
				WHERE csaId IN 'csa1'  
					OR arrayExists(legType -> legType IN 'put',legTypes) 
					OR arrayExists(legalEntity -> legalEntity IN 'FR',legalEntities)
				GROUP BY
					book,
					csaId,
					legTypes,
					legalEntities
			)
			ARRAY JOIN
				legalEntity,legType

GROUP BY
	book,
	legType,
	legalEntity

