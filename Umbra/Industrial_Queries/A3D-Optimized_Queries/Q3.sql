--test( "Query with an array dimension, a scalar metric and a filter on a non-projected")

SELECT                                                                                                                                                                                      
      legCurrency,                                                                                                                                                                            
      legType,                                                                                                                                                                                
      SUM(sum_mtm) AS sum_mtm
FROM (
      SELECT
          lc AS legCurrency,
          lt AS legType,
          sum_mtm
      FROM (
          SELECT
              SUM(mtm::BIGINT * factor::BIGINT) AS sum_mtm,
              legCurrencies,
              legIds,
              legTypes
          FROM tradeFactTable
          WHERE legIds @> ARRAY['leg212']
          GROUP BY
              legCurrencies,
              legIds,
              legTypes
      ) AS subq
      CROSS JOIN UNNEST(
          COALESCE(subq.legCurrencies, ARRAY[NULL::TEXT]),
          COALESCE(subq.legIds, ARRAY[NULL::TEXT]),
          COALESCE(subq.legTypes, ARRAY[NULL::TEXT])
      ) AS f(lc, li, lt)
      WHERE li = 'leg212'
  ) AS flattened
GROUP BY
      legCurrency,
      legType;




