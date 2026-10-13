 -- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on group based array ")


SELECT                   
      book,
      legType,                                                                                                                                                                                
      legalEntity,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
  FROM (          
      SELECT DISTINCT
          book,
          lt AS legType,
          le AS legalEntity,
          sum_mtm,
          bid
      FROM (
          SELECT
              book,
              (mtm::BIGINT * factor::BIGINT) AS sum_mtm,
              gen_random_uuid() AS bid,
              CASE
                  WHEN cardinality(legalEntities) > 0
                  THEN legalEntities
                  ELSE ARRAY[NULL::TEXT]
              END AS legalEntity,
              CASE
                  WHEN cardinality(legTypes) > 0
                  THEN legTypes
                  ELSE ARRAY[NULL::TEXT]
              END AS legType
          FROM tradeFactTable
      ) AS subq
      CROSS JOIN UNNEST(subq.legalEntity) AS f(le)
      CROSS JOIN UNNEST(subq.legType) AS f2(lt)
      WHERE lt = 'put' AND le = 'FR'
  ) AS flattened
  GROUP BY
      book,
      legType,
      legalEntity;



