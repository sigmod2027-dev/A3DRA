-- test("Query with a dimension, a group non-injective based on an array, a metric and a filter on the base array of the group")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                          
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f.value::string AS legalEntityGroup,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM(mtm * factor) AS sum_mtm,
              FILTER(IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)),
                     legalEntity -> legalEntity IN ('FR','UK')) AS legalEntity
          FROM tradeFactTable
          WHERE ARRAY_SIZE(
                  ARRAY_INTERSECTION(
                      legalEntities,
                      ARRAY_CONSTRUCT('FR'::VARIANT, 'UK'::VARIANT)
                  )
                ) > 0
          GROUP BY
              book,
              legalEntities
      ) AS subq
      ,LATERAL FLATTEN(input => ARRAY_DISTINCT(TRANSFORM(subq.legalEntity, x ->
          CASE
              WHEN x IS NULL THEN 'others'
              WHEN x IN ('FR','UK') THEN 'EU'
              ELSE 'others'
          END
      ))) AS f
  ) AS flattened
GROUP BY
      book,
      legalEntityGroup

