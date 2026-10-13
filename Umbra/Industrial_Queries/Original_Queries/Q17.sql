 -- test("Query with a dimension, an array, a metric and a filter on a dimension ")
 


SELECT                    
      book,
      legType,                                                                                                                                                                                
      SUM(sum_mtm) AS sum_mtm
FROM (                                                                                                                                                                                      
      SELECT DISTINCT
          book,
          legType,
          sum_mtm,
          bid
      FROM (
          SELECT
              book,
              mtm * factor AS sum_mtm,
              ROW_NUMBER() OVER() AS bid,
              CASE
                  WHEN cardinality(legTypes) > 0 THEN legTypes
                  ELSE ARRAY[NULL]
              END AS legType_array
          FROM tradeFactTable
      ) AS subq
      CROSS JOIN UNNEST(subq.legType_array) AS f
      WHERE book = 'book9'
  ) AS flattened
GROUP BY
      book,
      legType;

