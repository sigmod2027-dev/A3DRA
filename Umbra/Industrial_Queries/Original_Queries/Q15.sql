--   test("Query with a dimension, an array and, and a metric of array filtered")


SELECT                          
      book,
      legType,                                                                                                                                                                                
      SUM(sum_legNotional) AS sum_legNotional
FROM (                                                                                                                                                                                      
      SELECT      
          book,
          lt AS legType,
          sln AS sum_legNotional
      FROM (
          SELECT
              book,
              gen_random_uuid() AS bid,
              CASE
                  WHEN cardinality(legTypes) > 0
                  THEN legTypes
                  ELSE ARRAY[NULL::TEXT]
              END AS legType,
              ARRAY(
                  SELECT unnest(legNotionals)::BIGINT * factor::BIGINT
              ) AS sum_legNotional
          FROM tradeFactTable
      ) AS subq
      CROSS JOIN UNNEST(subq.legType, subq.sum_legNotional) AS f(lt, sln)
  ) AS flattened
GROUP BY
      book,
      legType
HAVING
      SUM(sum_legNotional) > 200000000000 AND
      SUM(sum_legNotional) < 300000000000;


