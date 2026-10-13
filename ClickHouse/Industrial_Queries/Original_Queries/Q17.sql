 -- test("Query with a dimension, an array, a metric and a filter on a dimension ")
 
 SELECT 
        book,
        legType,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
                SELECT 
                        book,
                        legTypes,
                        mtm * factor AS sum_mtm,
                        rowNumberInAllBlocks() AS bid,
                        if(notEmpty(legTypes),legTypes,[NULL]) AS legType
                FROM  tradeFactTable
        )
ARRAY JOIN 
        legType
WHERE
        book IN 'book9' 
GROUP BY 
        book,
        legType


