--test("Simple query with a simple dimension, a scalar metric and a filter on the array dimension handle a filter on a dimensional array which is not in by when not transposing any other array")

SELECT 
        book,
	arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
       
        SELECT 
                book,
                mtm * factor AS sum_mtm,
                rowNumberInAllBlocks() AS bid,
                if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
                arrayEnumerate(legType) AS _arrayGroupIdx0
     
        FROM tradeFactTable
         
)
ARRAY JOIN 
        _arrayGroupIdx0,
        legType
WHERE
        legType IN 'call'

GROUP BY 
        book

