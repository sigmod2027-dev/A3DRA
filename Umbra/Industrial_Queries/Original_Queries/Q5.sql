-- test("Query with dimension, two join array dimension, a scalar metric and a filter those two arrays dimension")


SELECT                         
      book,
      legCurrency,                                                                                                                                                                            
      legId,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT DISTINCT
          book,
          lc AS legCurrency,
          li AS legId,
          sum_mtm,
          bid
      FROM (
          SELECT
              book,
              (mtm::BIGINT) * (factor::BIGINT) AS sum_mtm,
              gen_random_uuid() AS bid,
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
      CROSS JOIN UNNEST(subq.legId, subq.legCurrency) AS f(li, lc)
      WHERE li = 'leg6' AND lc = 'USD'
  ) AS flattened
GROUP BY
      book,
      legCurrency,
      legId;
