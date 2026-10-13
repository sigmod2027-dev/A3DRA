--  test("Query with a dimension and a filter on group based array dimension and a filter on array dimension linked to the source of the group")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT                        
      book,
      SUM(mtm * factor) AS sum_mtm                                                                                                                                                            
FROM tradeFactTable
WHERE ARRAY_SIZE(                                                                                                                                                                           
          ARRAY_INTERSECTION(
              ARRAYS_ZIP(legTypes, legCurrencies),
              ARRAY_CONSTRUCT(
                  OBJECT_CONSTRUCT('$1', 'put', '$2', 'GBP'),
                  OBJECT_CONSTRUCT('$1', 'futureSpread', '$2', 'GBP'),
                  OBJECT_CONSTRUCT('$1', 'call', '$2', 'GBP')
              )
          )
        ) > 0
GROUP BY
      book


