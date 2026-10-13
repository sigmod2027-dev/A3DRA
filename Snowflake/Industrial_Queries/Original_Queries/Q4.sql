--  test("Query with dimension, a scalar metric and a filter on two arrays dimension") 

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

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
              mtm * factor AS sum_mtm,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legCurrencies) > 0, legCurrencies, ARRAY_CONSTRUCT(NULL)) AS legCurrency,
              IFF(ARRAY_SIZE(legIds) > 0, legIds, ARRAY_CONSTRUCT(NULL)) AS legId
          FROM tradeFactTable
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legCurrency) f
      ,LATERAL FLATTEN(input => subq.legId) g
      WHERE f.index = g.index
        AND f.value::string = 'USD'
        AND g.value::string = 'leg6'
  ) AS flattened
GROUP BY
      book

