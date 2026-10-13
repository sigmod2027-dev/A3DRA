-- test("Query with a dimension, a group based on an array, and a metric and a filter on the group") 
 
 SELECT                      
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_mtm) AS sum_mtm
FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f.legalEntityGroup,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              array_fill('FR', ARRAY[cardinality(array_positions(
                  CASE
                      WHEN cardinality(legalEntities) > 0
                      THEN legalEntities
                      ELSE ARRAY[CAST(NULL AS TEXT)]
                  END, 'FR'))]) ||
              array_fill('UK', ARRAY[cardinality(array_positions(
                  CASE
                      WHEN cardinality(legalEntities) > 0
                      THEN legalEntities
                      ELSE ARRAY[CAST(NULL AS TEXT)]
                  END, 'UK'))]) ||
              array_fill('US', ARRAY[cardinality(array_positions(
                  CASE
                      WHEN cardinality(legalEntities) > 0
                      THEN legalEntities
                      ELSE ARRAY[CAST(NULL AS TEXT)]
                  END, 'US'))]) AS legalEntity
          FROM tradeFactTable
          WHERE legalEntities && ARRAY['FR', 'UK', 'US']
          GROUP BY
              book,
              legalEntities
      ) AS subq
      CROSS JOIN LATERAL (
          SELECT DISTINCT
              CASE
                  WHEN x IN ('FR','UK','US') THEN 'governments'
                  ELSE 'others'
              END AS legalEntityGroup
          FROM UNNEST(subq.legalEntity) AS u(x)
      ) AS f
  ) AS flattened
GROUP BY
      book,
      legalEntityGroup;

