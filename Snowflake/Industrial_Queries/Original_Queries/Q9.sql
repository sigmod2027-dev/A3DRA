-- test("Query with a dimension, a group non-injective based on an array, a metric and a filter on the base array of the group")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                       
      book,
      legalEntityContinentNiGroup,                                                                                                                                                            
      SUM(sum_mtm) AS sum_mtm
  FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          book,
          sum_mtm,
          bid,
          f2.value::string AS legalEntityContinentNiGroup
      FROM (
          SELECT
              book,
              sum_mtm,
              bid,
              f1.value::string AS legalEntity,
              SPLIT(
                  CASE
                      WHEN f1.value::string = 'US' THEN 'NA'
                      WHEN f1.value::string = 'UN' THEN 'globalInstitutions'
                      WHEN f1.value::string = 'FR' THEN 'SA,EU'
                      WHEN f1.value::string = 'BR' THEN 'SA'
                      WHEN f1.value::string = 'IMF' THEN 'globalInstitutions'
                      WHEN f1.value::string = 'AR' THEN 'SA'
                      WHEN f1.value::string = 'UK' THEN 'EU'
                      WHEN f1.value::string = 'WTO' THEN 'globalInstitutions'
                      ELSE 'others'
                  END
              , ',') AS legalEntityContinentNiGroupArray
          FROM (
              SELECT
                  book,
                  legalEntities,
                  mtm * factor AS sum_mtm,
                  ROW_NUMBER() OVER (ORDER BY 1) AS bid,
                  IFF(ARRAY_SIZE(legalEntities) > 0, legalEntities, ARRAY_CONSTRUCT(NULL)) AS legalEntity
              FROM tradeFactTable
          ) AS subq,
          LATERAL FLATTEN(input => subq.legalEntity) f1
      ) AS flattened1,
      LATERAL FLATTEN(input => flattened1.legalEntityContinentNiGroupArray) f2
  ) AS flattened2
WHERE legalEntityContinentNiGroup = 'EU'
GROUP BY
      book,
      legalEntityContinentNiGroup

