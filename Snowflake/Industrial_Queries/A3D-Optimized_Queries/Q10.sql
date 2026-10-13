-- test("Query with a dimension, an array, a metric and a filter on group based array the array")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                     
      book,
      legalEntity,                                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f.value::string AS legalEntity,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM(mtm * factor) AS sum_mtm,
              ARRAY_DISTINCT(FILTER(IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)),
                                    legalEntity -> legalEntity IN ('FR','UK','US'))) AS legalEntity
          FROM tradeFactTable
          WHERE ARRAY_SIZE(
                  ARRAY_INTERSECTION(
                      legalEntities,
                      ARRAY_CONSTRUCT('FR'::VARIANT, 'UK'::VARIANT, 'US'::VARIANT)
                  )
                ) > 0
          GROUP BY
              book,
              legalEntities
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legalEntity) AS f
  ) AS flattened
GROUP BY
      book,
      legalEntity
