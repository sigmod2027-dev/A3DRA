-- test("Query with a dimension, a metric and a filter on group based on an array")

SELECT
	book,
	SUM((mtm::BIGINT) * (factor::BIGINT)) AS sum_mtm
FROM tradeFactTable
WHERE
	legalEntities && ARRAY['FR', 'UK', 'US']
GROUP BY
	book;
