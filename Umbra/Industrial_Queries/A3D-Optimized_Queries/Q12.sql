-- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on group based array")


SELECT                     
      book,
      legType,                                                                                                                                                                                
      legalEntity,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT
          book,
          f1 AS legType,
          f2 AS legalEntity,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm,
              ARRAY(
                  SELECT DISTINCT x
                  FROM UNNEST(
                      array_fill('put', ARRAY[
                          cardinality(array_positions(
                              CASE WHEN cardinality(legTypes) > 0
                                   THEN legTypes
                                   ELSE ARRAY[CAST(NULL AS TEXT)]
                              END, 'put'))
                      ])
                  ) AS u(x)
              ) AS legType,
              ARRAY(
                  SELECT DISTINCT x
                  FROM UNNEST(
                      array_fill('FR', ARRAY[
                          cardinality(array_positions(
                              CASE WHEN cardinality(legalEntities) > 0
                                   THEN legalEntities
                                   ELSE ARRAY[CAST(NULL AS TEXT)]
                              END, 'FR'))
                      ])
                  ) AS v(x)
              ) AS legalEntity
          FROM tradeFactTable
          WHERE legTypes @> ARRAY['put']
            AND legalEntities @> ARRAY['FR']
          GROUP BY
              book,
              legTypes,
              legalEntities
      ) AS subq
      CROSS JOIN UNNEST(subq.legType) AS f1
      CROSS JOIN UNNEST(subq.legalEntity) AS f2
  ) AS flattened
GROUP BY
      book,
      legType,
      legalEntity;


