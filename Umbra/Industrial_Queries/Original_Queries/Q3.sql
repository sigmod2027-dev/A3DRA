
--test( "Query with an array dimension, a scalar metric and a filter on a non-projected")



SELECT                         
      legCurrency,
      legType,                                                                                                                                                                                
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          lt AS legType,
          lc AS legCurrency,
          sum_mtm,
          bid
      FROM (
          SELECT
              (mtm::BIGINT) * (factor::BIGINT) AS sum_mtm,
              gen_random_uuid() AS bid,
              CASE
                  WHEN cardinality(legTypes) > 0
                  THEN legTypes
                  ELSE ARRAY[CAST(NULL AS TEXT)]
              END AS legType,
              CASE
                  WHEN cardinality(legIds) > 0
                  THEN legIds
                  ELSE ARRAY[CAST(NULL AS TEXT)]
              END AS legId,
              CASE
                  WHEN cardinality(legCurrencies) > 0
                  THEN legCurrencies
                  ELSE ARRAY[CAST(NULL AS TEXT)]
              END AS legCurrency
          FROM tradeFactTable
      ) AS subq
      CROSS JOIN UNNEST(subq.legType, subq.legId, subq.legCurrency) AS f(lt, li, lc)
      WHERE li = 'leg212'
  ) AS flattened
  GROUP BY
      legCurrency,
      legType;

