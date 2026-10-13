--  test("Query with dimension, a scalar metric and a filter on two arrays dimension") 

SELECT 
        book,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
        SELECT 
                book,
                legCurrencies,
                legIds,
                mtm * factor AS sum_mtm,
                rowNumberInAllBlocks() AS bid,
                if(notEmpty(legCurrencies),legCurrencies,[NULL]) AS legCurrency,
                if(notEmpty(legIds),legIds,[NULL]) AS legId
        FROM  tradeFactTable
)
ARRAY JOIN 
        legCurrency,
        legId
WHERE
        legCurrency IN 'USD' AND 
        legId IN 'leg6'
GROUP BY 
        book

