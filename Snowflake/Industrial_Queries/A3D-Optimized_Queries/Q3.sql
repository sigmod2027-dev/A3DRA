--test( "Query with an array dimension, a scalar metric and a filter on a non-projected")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                                                                                                                                                                                      
      f1.value::string AS legCurrency,                                                                                                                                                         
      f2.value::string AS legType,                                                                                                                                                             
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (                                                                                                                                                                                      
      SELECT      
          SUM(mtm * factor) AS sum_mtm,
          FILTER(ARRAYS_ZIP(IFF(ARRAY_SIZE(legCurrencies) > 0, legCurrencies, ARRAY_CONSTRUCT(NULL)),
                           IFF(ARRAY_SIZE(legIds) > 0, legIds, ARRAY_CONSTRUCT(NULL)),
                           IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL))),
                 x -> x:"$2" = 'leg212') AS _legCurrencylegIdlegType,
          TRANSFORM(_legCurrencylegIdlegType, x -> x:"$1") AS legCurrency,
          TRANSFORM(_legCurrencylegIdlegType, x -> x:"$3") AS legType
      FROM tradeFactTable
      WHERE ARRAY_CONTAINS('leg212'::VARIANT, legIds)
      GROUP BY
          legCurrencies,
          legIds,
          legTypes
  ) AS subq
  ,LATERAL FLATTEN(input => subq.legCurrency) f1
  ,LATERAL FLATTEN(input => subq.legType) f2
WHERE f1.index = f2.index
GROUP BY
      f1.value::string,
      f2.value::string
    

       

