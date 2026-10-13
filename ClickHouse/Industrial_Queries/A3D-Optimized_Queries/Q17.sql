  -- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on a dimension ")
 SELECT 
        book,
        legType,
        sum(sum_mtm) AS sum_mtm

        FROM (
                SELECT 
                        book,
                        legTypes,
                        sum(mtm * factor) AS sum_mtm,
                        arrayDistinct(if(notEmpty(legTypes),legTypes,[NULL])) AS legType
                FROM  tradeFactTable
                WHERE
               		book IN 'book9' 
               	GROUP BY 
               		book,
                        legTypes
        )
ARRAY JOIN 
        legType
GROUP BY 
        book,
        legType
