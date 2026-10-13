-- test("Query with a dimension, an array, a metric and a filter on group based array the array")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                     
      book,
      legalEntity,                                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          book,
          f.value::string AS legalEntity,
          sum_mtm,
          bid,
          CASE
              WHEN f.value::string IN ('FR','UK','US')
                  THEN 'governments'
              WHEN f.value::string IN ('IMF','WTO','UN')
                  THEN 'globalInstitutions'
              ELSE 'others'
          END AS legalEntityGroup
      FROM (
          SELECT
              book,
              mtm * factor AS sum_mtm,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)) AS legalEntity
          FROM tradeFactTable
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legalEntity) f
      WHERE legalEntityGroup = 'governments'
  ) AS flattened
GROUP BY
      book,
      legalEntity

