-- test("Query with a dimension, a group non-injective based on an arra, a metric and a filter on the base array of the group")


SELECT                        
      book,
      legalEntityContinentNiGroup,                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          book,
          legalEntityContinentNiGroup,
          sum_mtm,
          bid
      FROM (
          SELECT
              book,
              sum_mtm,
              bid,
              lecnig AS legalEntityContinentNiGroup
          FROM (
              SELECT
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
          ) AS unnested
          CROSS JOIN UNNEST(
              CASE
                  WHEN legalEntity = 'US' THEN ARRAY['NA']
                  WHEN legalEntity IN ('UN', 'IMF', 'WTO') THEN ARRAY['globalInstitutions']
                  WHEN legalEntity = 'FR' THEN ARRAY['SA', 'EU']
                  WHEN legalEntity = 'BR' THEN ARRAY['SA']
                  WHEN legalEntity = 'AR' THEN ARRAY['SA']
                  WHEN legalEntity = 'UK' THEN ARRAY['EU']
                  ELSE ARRAY['others']
              END
          ) AS f2(lecnig)
          WHERE lecnig = 'EU'
      ) AS with_groups
  ) AS flattened
GROUP BY
      book,
      legalEntityContinentNiGroup;
