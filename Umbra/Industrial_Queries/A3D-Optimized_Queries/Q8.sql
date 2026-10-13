 -- test("Query with a dimension, a group based on an array, a metric and a filter on the base array of the group")
 
SELECT                   
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_notional) AS sum_notional,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT
          book,
          f.legalEntityGroup,
          sum_notional,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((notional::BIGINT) * (factor::BIGINT)) AS sum_notional,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              array_fill('FR', ARRAY[cardinality(array_positions(
                  CASE
                      WHEN cardinality(legalEntities) > 0
                      THEN legalEntities
                      ELSE ARRAY[CAST(NULL AS TEXT)]
                  END, 'FR'))]) AS legalEntity
          FROM tradeFactTable
          WHERE legalEntities @> ARRAY['FR']
          GROUP BY
              book,
              legalEntities
      ) AS subq
      CROSS JOIN LATERAL (
          SELECT DISTINCT
              CASE
                  WHEN x IN ('FR', 'UK', 'US') THEN 'governments'
                  WHEN x IN ('IMF', 'WTO', 'UN') THEN 'globalInstitutions'
                  ELSE 'others'
              END AS legalEntityGroup
          FROM UNNEST(subq.legalEntity) AS u(x)
      ) AS f
  ) AS flattened
GROUP BY
      book,
      legalEntityGroup;



