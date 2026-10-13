 -- test("Query with a dimension, a group based on an array, a metric and a filter on the base array of the group")
 
 SELECT
	book,
	legalEntityGroup,
	sum(sum_notional) AS sum_notional,
	sum(sum_mtm) AS sum_mtm
	FROM (
		SELECT
			sum(notional * factor) AS sum_notional,
			book,
			legalEntities,
			sum(mtm * factor) AS sum_mtm,
			rowNumberInAllBlocks() AS bid,
			arrayFilter(legalEntity -> legalEntity IN 'FR',if(notEmpty(legalEntities),legalEntities,[NULL])) AS legalEntity
		FROM tradeFactTable
		WHERE
			arrayExists(legalEntity -> legalEntity IN 'FR',legalEntities)
			
		GROUP BY
			book,
			legalEntities
	)
	ARRAY JOIN
		arrayDistinct(arrayMap(x->transform(ifNull(toString(x),''),['FR','UK','US','IMF','WTO','UN'],['governments','governments','governments','globalInstitutions','globalInstitutions','globalInstitutions'],'others'),legalEntity)) AS legalEntityGroup

GROUP BY
	book,
	legalEntityGroup   

