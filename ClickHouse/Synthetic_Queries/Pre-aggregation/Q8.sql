---original query----
SELECT
	book,
	legIds,
	sum(legNotionals) AS sum_legNotionals
FROM tradeFactTable
ARRAY JOIN
	legIds, legNotionals
GROUP BY
	book,
	legIds
format Null

---optimized query -----
SELECT
	book,
	legId,
	sum(sum_legNotional) AS sum_legNotional
FROM (
	SELECT
		book,
		legIds,
		sumForEach(legNotionals) AS sum_legNotionals
	FROM tradeFactTable
	GROUP BY
		book,
		legIds
)
ARRAY JOIN
	legIds as legId, sum_legNotionals as sum_legNotional
GROUP BY
	book,
	legId
format Null
