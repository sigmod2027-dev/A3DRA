-- test("Query with a dimension, a group non-injective based on an arra, a metric and a filter on the base array of the group")

SELECT 
        book,
        legalEntityContinentNiGroup,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
        SELECT 
                legalEntity,
                book,
                legalEntities,
                sum_mtm,
                bid,
                splitByChar(',',transform(ifNull(toString(legalEntity),''),['US','UN','FR','BR','IMF','AR','UK','WTO'],['NA','globalInstitutions','SA,EU','SA','globalInstitutions','SA','EU','globalInstitutions'],'others')) AS legalEntityContinentNiGroup
        
        FROM (
                SELECT 
                        book,
                        legalEntities,
                        mtm * factor AS sum_mtm,
                        rowNumberInAllBlocks() AS bid,
                        if(notEmpty(legalEntities),legalEntities,[NULL]) AS legalEntity
                FROM  tradeFactTable
        )
        ARRAY JOIN 
                legalEntity
)
ARRAY JOIN 
        legalEntityContinentNiGroup
WHERE
        legalEntityContinentNiGroup IN 'EU'
GROUP BY 
        book,
        legalEntityContinentNiGroup

