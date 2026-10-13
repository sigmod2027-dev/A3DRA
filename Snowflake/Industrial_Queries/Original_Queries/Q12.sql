-- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on group based array")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                    
      book,
      legType,                                                                                                                                                                                
      legalEntity,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
  FROM (          
      SELECT DISTINCT
          book,
          sum_mtm,
          bid,
          f1.value::string AS legalEntity,
          f2.value::string AS legType
      FROM (
          SELECT
              book,
              legTypes,
              legalEntities,
              mtm * factor AS sum_mtm,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)) AS legalEntity,
              IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL)) AS legType
          FROM tradeFactTable
      ) AS subq,
      LATERAL FLATTEN(input => subq.legalEntity) f1,
      LATERAL FLATTEN(input => subq.legType) f2
      WHERE f2.value::string = 'put'
        AND f1.value::string = 'FR'
  ) AS flattened
GROUP BY
      book,
      legType,
      legalEntity
