
--test( "Query with an array dimension, a scalar metric and a filter on a non-projected")

SELECT 
        legCurrency,
        legType,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
        SELECT 
                legCurrencies,
                legIds,
                legTypes,
                mtm * factor AS sum_mtm,
                rowNumberInAllBlocks() AS bid,
                if(notEmpty(legCurrencies),legCurrencies,[NULL]) AS legCurrency,
                if(notEmpty(legIds),legIds,[NULL]) AS legId,
                if(notEmpty(legTypes),legTypes,[NULL]) AS legType
        FROM tradeFactTable
)
ARRAY JOIN 
        legCurrency,
        legId,
        legType
WHERE
        legId IN 'leg212'
GROUP BY 
        legCurrency,
        legType

