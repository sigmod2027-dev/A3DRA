-- test("Query with dimension, two join array dimension, a scalar metric and a filter those two arrays dimension")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                       
      book,
      f1.value::string AS legCurrency,                                                                                                                                                        
      f2.value::string AS legId,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT
          book,
          SUM(mtm * factor) AS sum_mtm,
          ARRAY_DISTINCT(FILTER(ARRAYS_ZIP(IFF(ARRAY_SIZE(legCurrencies) > 0, legCurrencies, ARRAY_CONSTRUCT(NULL)),
                                           IFF(ARRAY_SIZE(legIds) > 0, legIds, ARRAY_CONSTRUCT(NULL))),
                                x -> x:"$1" = 'USD' AND x:"$2" = 'leg6')) AS _legCurrencylegId,
          TRANSFORM(_legCurrencylegId, x -> x:"$1") AS legCurrency,
          TRANSFORM(_legCurrencylegId, x -> x:"$2") AS legId
      FROM tradeFactTable
      WHERE ARRAY_CONTAINS(OBJECT_CONSTRUCT('$1', 'leg6', '$2', 'USD'), ARRAYS_ZIP(legIds, legCurrencies))
      GROUP BY
          book,
          legCurrencies,
          legIds
  ) AS subq
  ,LATERAL FLATTEN(input => subq.legCurrency) f1
  ,LATERAL FLATTEN(input => subq.legId) f2
  WHERE f1.index = f2.index
GROUP BY
      book,
      f1.value::string,
      f2.value::string


