-- test("Query with a dimension, a group based on an array, and a metric and a filter on the group") 

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                       
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          book,
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
  ) AS flattened
  WHERE legalEntityGroup = 'governments'
GROUP BY
      book,
      legalEntityGroup



