-- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on group based array ")

SELECT 
        book,
        legType,
        legalEntity,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
        SELECT 
                legalEntity,
                book,
                legTypes,
                legalEntities,
                sum_mtm,
                bid,
                if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
                arrayEnumerate(legType) AS _arrayGroupIdx1
        FROM (
                SELECT 
                        book,
                        legTypes,
                        legalEntities,
                        mtm * factor AS sum_mtm,
                        rowNumberInAllBlocks() AS bid,
                        if(notEmpty(legalEntities),legalEntities,[NULL]) AS legalEntity
                FROM tradeFactTable
        )
        ARRAY JOIN 
                legalEntity
)
ARRAY JOIN 
        legType
WHERE
        legType IN 'put' AND 
        legalEntity IN 'FR'
GROUP BY 
        book,
        legType,
        legalEntity

