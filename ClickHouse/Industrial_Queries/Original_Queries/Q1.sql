-----test("Simple query with an array dimension, a scalar metric and a filter on the array dimension")

SELECT 
        book,
        legType,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
       
        SELECT 
                book,
                mtm * factor AS sum_mtm,
                rowNumberInAllBlocks() AS bid,
                if(notEmpty(legTypes),legTypes,[NULL]) AS legType
        FROM tradeFactTable
)
ARRAY JOIN 
        legType
WHERE
        legType IN 'call'

GROUP BY 
        book,
        legType

