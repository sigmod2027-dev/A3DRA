 -- test("Query with a dimension, a group based on an array, a metric and a filter on the base array of the group")

SELECT                     
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_notional) AS sum_notional,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT DISTINCT
          book,
          legalEntityGroup,
          sum_notional,
          sum_mtm,
          bid
      FROM (
          SELECT
              book,
              le AS legalEntity,
              sum_mtm,
              sum_notional,
              bid,
              CASE
                  WHEN COALESCE(le::TEXT, '') IN ('FR', 'UK', 'US')
                      THEN 'governments'
                  WHEN COALESCE(le::TEXT, '') IN ('IMF', 'WTO', 'UN')
                      THEN 'globalInstitutions'
                  ELSE 'others'
              END AS legalEntityGroup
          FROM (
              SELECT
                  book,
                  (mtm::BIGINT) * (factor::BIGINT) AS sum_mtm,
                  (notional::BIGINT) * (factor::BIGINT) AS sum_notional,
                  gen_random_uuid() AS bid,
                  CASE
                      WHEN cardinality(legalEntities) > 0
                      THEN legalEntities
                      ELSE ARRAY[NULL::TEXT]
                  END AS legalEntity
              FROM tradeFactTable
          ) AS subq
          CROSS JOIN UNNEST(subq.legalEntity) AS f(le)
          WHERE le = 'FR'
      ) AS with_groups
  ) AS flattened
GROUP BY
      book,
      legalEntityGroup;

