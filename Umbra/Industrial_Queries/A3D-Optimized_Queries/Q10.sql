-- test("Query with a dimension, an array, a metric and a filter on group based array the array")
 
SELECT                     
      book,
      legalEntity,                                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f AS legalEntity,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              ARRAY(
                  SELECT DISTINCT x
                  FROM UNNEST(
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
                      )]) ||
                      array_fill('US', ARRAY[cardinality(array_positions(
                          CASE WHEN cardinality(legalEntities) > 0
                               THEN legalEntities
                               ELSE ARRAY[CAST(NULL AS TEXT)]
                          END, 'US')
                      )])
                  ) AS u(x)
              ) AS legalEntity
          FROM tradeFactTable
          WHERE legalEntities && ARRAY['FR', 'UK', 'US']
          GROUP BY
              book,
              legalEntities
      ) AS subq
      CROSS JOIN UNNEST(subq.legalEntity) AS f
  ) AS flattened
  GROUP BY
      book,
      legalEntity;
