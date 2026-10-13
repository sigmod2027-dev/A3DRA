-- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on group based array")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                    
      book,
      legType,                                                                                                                                                                                
      legalEntity,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
FROM (          
      SELECT
          book,
          t.value::string AS legType,
          e.value::string AS legalEntity,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM(mtm * factor) AS sum_mtm,
              ARRAY_DISTINCT(FILTER(IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)),
                                    legalEntity -> legalEntity = 'FR')) AS legalEntity,
              ARRAY_DISTINCT(FILTER(IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL)),
                                    legType -> legType = 'put')) AS legType
          FROM tradeFactTable
          WHERE ARRAY_CONTAINS('FR'::VARIANT, legalEntities)
            AND ARRAY_CONTAINS('put'::VARIANT, legTypes)
          GROUP BY
              book,
              legTypes,
              legalEntities
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legType) AS t
      ,LATERAL FLATTEN(input => subq.legalEntity) AS e
  ) AS flattened
GROUP BY
      book,
      legType,
      legalEntity

