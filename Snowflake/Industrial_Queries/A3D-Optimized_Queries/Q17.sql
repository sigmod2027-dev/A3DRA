 -- test("Query with a dimension, an array, a metric and a filter on a dimension ")

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
              ARRAY_DISTINCT(IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL))) AS legType
          FROM tradeFactTable
          WHERE book = 'book9'
          GROUP BY book, legTypes
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legType) AS f
  ) AS flattened
GROUP BY
      book,
      legType

