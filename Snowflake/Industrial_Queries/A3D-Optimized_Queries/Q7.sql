-- test("Query with a dimension, a metric and a filter on group based on an array")

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT
	book,
	SUM(mtm * factor) AS sum_mtm
FROM tradeFactTable
WHERE
	ARRAY_SIZE(
            ARRAY_INTERSECTION(
            legalEntities,                                     
            ARRAY_CONSTRUCT('FR'::VARIANT, 'UK'::VARIANT, 'US'::VARIANT) 
        )
    ) > 0
GROUP BY
	book
