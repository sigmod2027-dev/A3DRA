 -- test("Query with a dimension, an array, a metric and a filter on group based array the array")

WITH
        transform(ifNull(toString(legalEntity),''),['FR','UK','US','IMF','WTO','UN'],['governments','governments','governments','globalInstitutions','globalInstitutions','globalInstitutions'],'others') AS legalEntityGroup
SELECT 
        book,
        legalEntity,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
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
WHERE
        legalEntityGroup IN 'governments'
GROUP BY 
        book,
        legalEntity

