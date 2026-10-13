--  test("Query with dimension, a scalar metric and a filter on two arrays dimension") 


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
sGROUP BY
      book;

