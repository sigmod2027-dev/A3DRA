--  test("Query with a dimension and a filter on group based array dimension and a filter on array dimension linked to the source of the group")


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
              sum_mtm,
              bid,
              ltnig AS legTypeNiGroup
          FROM (
              SELECT
                  book,
                  lc AS legCurrency,
                  lt AS legType,
                  sum_mtm,
                  bid
              FROM (
                  SELECT
                      book,
                      (mtm::BIGINT) * (factor::BIGINT) AS sum_mtm,
                      gen_random_uuid() AS bid,
                      CASE
                          WHEN cardinality(legCurrencies) > 0
                          THEN legCurrencies
                          ELSE ARRAY[CAST(NULL AS TEXT)]
                      END AS legCurrency,
                      CASE
                          WHEN cardinality(legTypes) > 0
                          THEN legTypes
                          ELSE ARRAY[CAST(NULL AS TEXT)]
                      END AS legType
                  FROM tradeFactTable
              ) AS subq
              CROSS JOIN UNNEST(subq.legCurrency, subq.legType) AS f(lc, lt)
          ) AS unnested
          CROSS JOIN UNNEST(
              CASE
                  WHEN legType = 'put' THEN ARRAY['options_related']
                  WHEN legType = 'futureContract' THEN ARRAY['future_related']
                  WHEN legType = 'futureSpread' THEN ARRAY['options_related', 'future_related']
                  WHEN legType = 'call' THEN ARRAY['options_related']
                  ELSE ARRAY['others']
              END
          ) AS f2(ltnig)
          WHERE legCurrency = 'GBP' AND ltnig = 'options_related'
      ) AS with_groups
  ) AS flattened
GROUP BY
      book;
