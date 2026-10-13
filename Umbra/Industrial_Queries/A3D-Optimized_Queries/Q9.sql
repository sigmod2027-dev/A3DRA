-- test("Query with a dimension, a group non-injective based on an array, a metric and a filter on the base array of the group")


SELECT                  
      book,
      legalEntityContinentNiGroup,                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f.legalEntityContinentNiGroup,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              array_fill('FR', ARRAY[cardinality(array_positions(
                  CASE WHEN cardinality(legalEntities) > 0
                       THEN legalEntities
                       ELSE ARRAY[CAST(NULL AS TEXT)]
                  END, 'FR')
              )]) ||
              array_fill('UK', ARRAY[cardinality(array_positions(
                  CASE WHEN cardinality(legalEntities) > 0
                       THEN legalEntities
                       ELSE ARRAY[CAST(NULL AS TEXT)]
                  END, 'UK')
              )]) AS legalEntity
          FROM tradeFactTable
          WHERE legalEntities && ARRAY['FR', 'UK']
          GROUP BY
              book,
              legalEntities
      ) AS subq
      CROSS JOIN LATERAL (
          SELECT DISTINCT
              CASE
                  WHEN x IN ('FR','UK') THEN 'EU'
                  ELSE 'others'
              END AS legalEntityContinentNiGroup
          FROM UNNEST(subq.legalEntity) AS u(x)
      ) AS f
  ) AS flattened
GROUP BY
      book,
      legalEntityContinentNiGroup;

