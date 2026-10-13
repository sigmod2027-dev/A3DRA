-- test("Query with dimension, two join array dimension, a scalar metric and a filter those two arrays dimension")

SELECT                    
      book,
      legCurrency,                                                                                                                                                                            
      legId,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT
          book,
          f.legCurrency,
          f.legId,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              legCurrencies,
              legIds
          FROM tradeFactTable
          WHERE legIds @> ARRAY['leg6']
            AND array_positions(legCurrencies, 'USD') && array_positions(legIds, 'leg6')
          GROUP BY
              book,
              legCurrencies,
              legIds
      ) AS subq
      CROSS JOIN LATERAL (
          SELECT DISTINCT
              lc AS legCurrency,
              li AS legId
          FROM UNNEST(
              CASE
                  WHEN cardinality(subq.legCurrencies) > 0
                  THEN subq.legCurrencies
                  ELSE ARRAY[CAST(NULL AS TEXT)]
              END,
              CASE
                  WHEN cardinality(subq.legIds) > 0
                  THEN subq.legIds
                  ELSE ARRAY[CAST(NULL AS TEXT)]
              END
          ) AS u(lc, li)
          WHERE lc = 'USD' AND li = 'leg6'
      ) AS f
  ) AS flattened
GROUP BY
      book,
      legCurrency,
      legId;

