-- test("Query with a dimension, a group based on an array, and a metric and a filter on the group") 
 
 SELECT
	book,
	legalEntityGroup,
	sum(sum_mtm) AS sum_mtm
	FROM (
		SELECT
			book,
			legalEntities,
			sum(mtm * factor) AS sum_mtm,
			rowNumberInAllBlocks() AS bid,
			arrayFilter(legalEntity -> legalEntity IN ('FR','UK','US'),if(notEmpty(legalEntities),legalEntities,[NULL])) AS legalEntity
		FROM tradeFactTable
		WHERE
			arrayExists(legalEntity -> legalEntity IN ('FR','UK','US'),legalEntities) 
		GROUP BY
			book,
			legalEntities
	)
ARRAY JOIN
	arrayDistinct(arrayMap(x->transform(ifNull(toString(x),''),['FR','UK','US'],['governments','governments','governments'],'others'),legalEntity)) AS legalEntityGroup		
GROUP BY
	book,
	legalEntityGroup

