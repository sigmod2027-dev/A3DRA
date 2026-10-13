--test("Simple query with an array dimension, a scalar metric and a filter on the array dimension")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                    
      book,
      legType,                                                                                                                                                                                
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f.value::string AS legType,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM(mtm * factor) AS sum_mtm,
              ARRAY_DISTINCT(FILTER(legTypes, x -> x = 'call')) AS legType
          FROM tradeFactTable
          WHERE ARRAY_CONTAINS('call'::VARIANT, legTypes)
          GROUP BY
              book,
              legTypes
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legType) AS f
  ) AS flattened
GROUP BY
      book,
      legType





