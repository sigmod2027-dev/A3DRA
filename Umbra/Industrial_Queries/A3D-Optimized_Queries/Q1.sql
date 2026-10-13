--test("Simple query with an array dimension, a scalar metric and a filter on the array dimension")


SELECT                                                                                                                                                                                      
      book,                                                                                                                                                                                   
      legType,                                                                                                                                                                                
      SUM(sum_mtm) AS sum_mtm
FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f AS legType,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              ARRAY(
                  SELECT DISTINCT x
                  FROM UNNEST(array_fill('call', ARRAY[cardinality(array_positions(
                      CASE
                          WHEN cardinality(legTypes) > 0
                          THEN legTypes
                          ELSE ARRAY[CAST(NULL AS TEXT)]
                      END, 'call'))])) AS u(x)
              ) AS legType
          FROM tradeFactTable
          WHERE legTypes @> ARRAY['call']
          GROUP BY
              book,
              legTypes
      ) AS subq
      CROSS JOIN UNNEST(subq.legType) AS f
  ) AS flattened
GROUP BY
      book,
      legType;





        
