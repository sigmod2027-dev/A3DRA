  -- test("Query with a dimension, an array and another array dimension from another group, a metric and a filter on a dimension ")

SELECT                         
      book,
      legType,                                                                                                                                                                                
      SUM(sum_mtm) AS sum_mtm
FROM (                                                                                                                                                                                      
      SELECT      
          book,
          f AS legType,
          sum_mtm
      FROM (
          SELECT
              book,
              SUM(mtm::BIGINT * factor::BIGINT) AS sum_mtm,
              ARRAY(SELECT DISTINCT unnest(
                  CASE WHEN cardinality(legTypes) > 0 THEN legTypes ELSE ARRAY[NULL] END
              )) AS legType
          FROM tradeFactTable
          WHERE book = 'book9'
          GROUP BY book, legTypes
      ) AS subq
      CROSS JOIN UNNEST(subq.legType) AS f
  ) AS flattened
GROUP BY
      book,
      legType;

