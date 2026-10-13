---original query----
SELECT
	book,
	counterparty,
	sum(mtf) AS sum_mtf
	FROM tradeFactTable

ARRAY JOIN
	mtf
GROUP BY
	book,counterparty
format Null

---optimized query -----
SELECT
	book,
	counterparty,
	arraySum(sum_mtf) AS sum_mtf
FROM (
	SELECT
		book,
		counterparty,
		sumForEach(mtf) AS sum_mtf
	FROM tradeFactTable
	GROUP BY
		book,counterparty
)
format Null		

