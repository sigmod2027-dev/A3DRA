-- test("Query with a dimension, a metric and a filter on group based on an array")


SELECT                                                                                                                                                                                      
      book,      
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (                                                                                                                                                                                      
      SELECT
          book,
          sum_mtm,
          CASE
              WHEN legalEntity IN ('FR', 'UK', 'US') THEN 'governments'
              WHEN legalEntity IN ('IMF', 'WTO', 'UN') THEN 'globalInstitutions'
              ELSE 'others'
          END AS legalEntityGroup
      FROM (
          SELECT DISTINCT
              book,
              le AS legalEntity,
              sum_mtm,
              bid
          FROM (
              SELECT
                  book,
                  (mtm::BIGINT) * (factor::BIGINT) AS sum_mtm,
                  gen_random_uuid() AS bid,
                  CASE
                      WHEN cardinality(legalEntities) > 0
                      THEN legalEntities
                      ELSE ARRAY[CAST(NULL AS TEXT)]
                  END AS legalEntity
              FROM tradeFactTable
          ) base
          CROSS JOIN UNNEST(base.legalEntity) AS u(le)
      ) deduplicated
  ) with_groups
WHERE legalEntityGroup = 'governments'
GROUP BY
      book;


