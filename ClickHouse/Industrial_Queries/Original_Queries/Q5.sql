-- test("Query with dimension, two join array dimension, a scalar metric and a filter those two arrays dimension")

SELECT 
        book,
        legCurrency,
        legId,
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
        book,
        legCurrency,
        legId

