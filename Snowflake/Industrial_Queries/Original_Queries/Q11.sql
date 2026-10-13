--  test("Query with a dimension and a filter on group based array dimension and a filter on array dimension linked to the source of the group")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT                     
      book,
      SUM(sum_mtm) AS sum_mtm                                                                                                                                                                 
  FROM (
      SELECT DISTINCT                                                                                                                                                                         
          book,   
          sum_mtm,
          bid,
          legCurrency
      FROM (
          SELECT
              book,
              sum_mtm,
              bid,
              f1.value::string AS legCurrency,
              f2.value::string AS legType,
              SPLIT(
                  CASE
                      WHEN f2.value::string = 'put'             THEN 'options_related'
                      WHEN f2.value::string = 'futureContract'  THEN 'future_related'
                      WHEN f2.value::string = 'futureSpread'    THEN 'options_related,future_related'
                      WHEN f2.value::string = 'call'            THEN 'options_related'
                      ELSE 'others'
                  END
              , ',') AS legTypeNiGroupArray
          FROM (
              SELECT
                  book,
                  legCurrencies,
                  legTypes,
                  mtm * factor AS sum_mtm,
                  ROW_NUMBER() OVER (ORDER BY 1) AS bid,
                  IFF(ARRAY_SIZE(legCurrencies) > 0, legCurrencies, ARRAY_CONSTRUCT(NULL)) AS legCurrency,
                  IFF(ARRAY_SIZE(legTypes) > 0, legTypes, ARRAY_CONSTRUCT(NULL)) AS legType
              FROM tradeFactTable
          ) AS subq,
          LATERAL FLATTEN(input => subq.legCurrency) f1,
          LATERAL FLATTEN(input => subq.legType) f2
      ) AS flattened1,
      LATERAL FLATTEN(input => flattened1.legTypeNiGroupArray) f3
      WHERE legCurrency = 'GBP'
        AND f3.value::string = 'options_related'
  ) AS flattened2
GROUP BY 
      book

