 -- test("Query with a dimension, a group based on an array, a metric and a filter on the base array of the group")

SELECT 
        book,
        transform(ifNull(toString(legalEntity),''),['FR','UK','US','IMF','WTO','UN'],['governments','governments','governments','globalInstitutions','globalInstitutions','globalInstitutions'],'others') AS legalEntityGroup,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_notional)),2)) AS sum_notional,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
        SELECT 
                book,
                legalEntities,
                mtm * factor AS sum_mtm,
                notional * factor AS sum_notional,
                rowNumberInAllBlocks() AS bid,
                if(notEmpty(legalEntities),legalEntities,[NULL]) AS legalEntity
        FROM  tradeFactTable

)
ARRAY JOIN 
        legalEntity
WHERE
        legalEntity IN 'FR'
GROUP BY 
        book,
        legalEntityGroup

