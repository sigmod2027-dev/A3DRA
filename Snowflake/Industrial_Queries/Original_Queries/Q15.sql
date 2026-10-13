--   test("Query with a dimension, an array and, and a metric of array filtered")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                                                                                                                                                                                      
      book,                                                                                                                                                                                   
      legType,                                                                                                                                                                                
      SUM(sum_legNotional) AS sum_legNotional                                                                                                                                                 
  FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          book,
          bid,
          f1.INDEX AS array_index,
          f1.VALUE::string AS legType,
          f2.VALUE * subq.factor AS sum_legNotional
      FROM (
          SELECT
              book,
              factor,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL)) AS legType,
              IFF(ARRAY_SIZE(legNotionals) > 0, legNotionals, ARRAY_CONSTRUCT(NULL)) AS legNotional
          FROM tradeFactTable
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legType) f1
      ,LATERAL FLATTEN(input => subq.legNotional) f2
      WHERE f1.INDEX = f2.INDEX
  ) AS flattened
GROUP BY
      book,
      legType
HAVING
      SUM(sum_legNotional) > 200000000000 AND
      SUM(sum_legNotional) < 300000000000

    



