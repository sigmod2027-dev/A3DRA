--test("Simple query with an array dimension, a scalar metric and a filter on the array dimension")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT
      book,                                                                     
      legType,    
      SUM(sum_mtm) AS sum_mtm
  FROM (
      SELECT DISTINCT
          book,
          bid,
          f.value::string AS legType,
          sum_mtm
      FROM (
          SELECT
              book,
              mtm * factor AS sum_mtm,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL)) AS legType
          FROM tradeFactTable
      ) AS subq,
      LATERAL FLATTEN(input => subq.legType) f
      WHERE f.value::string = 'call'
  ) AS flattened
 GROUP BY
      book,
      legType

  





