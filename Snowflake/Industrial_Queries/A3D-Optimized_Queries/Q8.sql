 -- test("Query with a dimension, a group based on an array, a metric and a filter on the base array of the group")
 
 ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                     
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_notional) AS sum_notional,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
  FROM (          
      SELECT
          book,
          f.value::string AS legalEntityGroup,
          sum_notional,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM(mtm * factor) AS sum_mtm,
              SUM(notional * factor) AS sum_notional,
              FILTER(IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)),
                     legalEntity -> legalEntity IN ('FR')) AS legalEntity
          FROM tradeFactTable
          WHERE ARRAY_CONTAINS('FR'::VARIANT, legalEntities)
          GROUP BY
              book,
              legalEntities
      ) AS subq
      ,LATERAL FLATTEN(input => ARRAY_DISTINCT(TRANSFORM(subq.legalEntity, x ->
          CASE
              WHEN x IS NULL THEN 'others'
              WHEN x IN ('FR', 'UK', 'US') THEN 'governments'
              WHEN x IN ('US','IMF','WTO','UN') THEN 'globalInstitutions'
              ELSE 'others'
          END
      ))) AS f
  ) AS flattened
GROUP BY
      book,
      legalEntityGroup

