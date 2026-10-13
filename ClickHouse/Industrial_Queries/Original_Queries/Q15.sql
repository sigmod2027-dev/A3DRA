--   test("Query with a dimension, an array and, and a metric of array filtered")

SELECT 
        book,
        legType,
        SUM(sum_legNotional) AS sum_legNotional
FROM (
        SELECT 
                legType,
                sum_legNotional,
                book,
                legTypes,
            
        FROM (
                SELECT 
                        book,
                        legTypes,
                        arrayMap(x -> x * factor,legNotionals) AS sum_legNotional,
                        if(notEmpty(legTypes),legTypes,[NULL]) AS legType
                FROM  tradeFactTable
        )
        ARRAY JOIN 
            
                legType,
                sum_legNotional
)
GROUP BY 
        book,
        legType
 HAVING 
        sum_legNotional > 200000000000 AND 
        sum_legNotional < 300000000000
