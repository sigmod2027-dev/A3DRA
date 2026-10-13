--test("Simple query with a simple dimension, a scalar metric and a filter on the array dimension handle a filter on a dimensional array which is not in by when not transposing any other array")

SELECT              
      book,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (
      SELECT DISTINCT                                                                                                                                                                         
          book,   
          sum_mtm,
          bid
      FROM (
          SELECT
              book,
              (mtm::BIGINT) * (factor::BIGINT) AS sum_mtm,
              gen_random_uuid() AS bid,
              CASE
                  WHEN cardinality(legTypes) > 0
                  THEN legTypes
                  ELSE ARRAY[CAST(NULL AS TEXT)]
              END AS legType
          FROM tradeFactTable
      ) AS subq
      CROSS JOIN UNNEST(subq.legType) AS f
      WHERE f = 'call'
  ) AS flattened
GROUP BY
      book;



