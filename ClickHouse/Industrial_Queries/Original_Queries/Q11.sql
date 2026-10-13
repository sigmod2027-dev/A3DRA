--  test("Query with a dimension and a filter on group based array dimension and a filter on array dimension linked to the source of the group")


SELECT 
        book,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,sum_mtm)),2)) AS sum_mtm
FROM (
        SELECT
                legCurrency,
                legType,
                book,
                legCurrencies,
                legTypes,
                sum_mtm,
                bid,
                splitByChar(',',transform(ifNull(toString(legType),''),['put','futureContract','futureSpread','call'],['options_related','future_related','options_related,future_related','options_related'],'others')) AS legTypeNiGroup
        FROM (
                SELECT 
                        book,
                        legCurrencies,
                        legTypes,
                        mtm * factor AS sum_mtm,
                        rowNumberInAllBlocks() AS bid,
                        if(notEmpty(legCurrencies),legCurrencies,[NULL]) AS legCurrency,
                        if(notEmpty(legTypes),legTypes,[NULL]) AS legType
                FROM tradeFactTable
        )
        ARRAY JOIN 
                legCurrency,
                legType
)
ARRAY JOIN 
        legTypeNiGroup
WHERE
        legCurrency IN 'GBP' AND 
        legTypeNiGroup IN 'options_related'
GROUP BY 
        book

