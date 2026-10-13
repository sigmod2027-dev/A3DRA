 -- test("Query with a dimension, an array, a metric and a filter on group based array the array")

SELECT                     
      book,
      legalEntity,                                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT      
          book,
          legalEntity,
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
          ) AS subq
          CROSS JOIN UNNEST(subq.legalEntity) AS f(le)
      ) AS flattened
  ) AS with_groups
  WHERE legalEntityGroup = 'governments'
  GROUP BY
      book,
      legalEntity;


