--test("Simple query with a simple dimension, a scalar metric and a filter on the array dimension handle a filter on a dimensional array which is not in by when not transposing any other array")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                                                                        
      book,
      SUM(sum_mtm) AS sum_mtm                                                   
  FROM (          
      SELECT DISTINCT
          book,
          bid,
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
GROUP BY book

