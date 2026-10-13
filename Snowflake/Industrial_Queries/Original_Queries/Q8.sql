 -- test("Query with a dimension, a group based on an array, a metric and a filter on the base array of the group")
 
 ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                       
      book,
      legalEntityGroup,                                                                                                                                                                       
      SUM(sum_mtm) AS sum_mtm,
      SUM(sum_notional) AS sum_notional                                                                                                                                                       
  FROM (          
      SELECT DISTINCT
          book,
          CASE
              WHEN f.value::string IN ('FR','UK','US') THEN 'governments'
              WHEN f.value::string IN ('IMF','WTO','UN') THEN 'globalInstitutions'
              ELSE 'others'
          END AS legalEntityGroup,
          sum_mtm,
          sum_notional,
          bid
      FROM (
          SELECT
              book,
              mtm * factor AS sum_mtm,
              notional * factor AS sum_notional,
              ROW_NUMBER() OVER (ORDER BY 1) AS bid,
              IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)) AS legalEntity
          FROM tradeFactTable
      ) AS subq
      ,LATERAL FLATTEN(input => subq.legalEntity) f
      WHERE f.value::string = 'FR'
  ) AS flattened
GROUP BY
      book,
      legalEntityGroup

