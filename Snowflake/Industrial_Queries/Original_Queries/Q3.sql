--test( "Query with an array dimension, a scalar metric and a filter on a non-projected")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                                                                        
      legCurrency,
      legType,                                                                  
      SUM(sum_mtm) AS sum_mtm
  FROM (
      SELECT DISTINCT
          f.value::string AS legCurrency,
          h.value::string AS legType,
          bid,
          sum_mtm
      FROM (
          SELECT
              mtm * factor AS sum_mtm,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legCurrencies) > 0, legCurrencies, ARRAY_CONSTRUCT(NULL)) AS legCurrency,
              IFF(ARRAY_SIZE(legIds) > 0, legIds, ARRAY_CONSTRUCT(NULL)) AS legId,
              IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL)) AS legType
          FROM tradeFactTable
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legCurrency) f
      ,LATERAL FLATTEN(input => subq.legId) g
      ,LATERAL FLATTEN(input => subq.legType) h
      WHERE f.index = g.index
        AND f.index = h.index
        AND g.value::string = 'leg212'
  ) AS flattened
GROUP BY
      legCurrency,
      legType



       

