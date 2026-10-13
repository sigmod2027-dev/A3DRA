--test("Simple query with a simple dimension, a scalar metric and a filter on the array dimension handle a filter on a dimensional array which is not in by when not transposing any other array")


SELECT
	book,
	SUM( (mtm::BIGINT) * (factor::BIGINT) ) AS sum_mtm
FROM  tradeFactTable
WHERE
	legTypes @> ARRAY['call']
GROUP BY
	book;
