---original query----
SELECT
	book,
	sum(mtf) AS sum_mtf
	FROM tradeFactTable
ARRAY JOIN
	mtf
GROUP BY
	book
format Null

---optimized query -----
SELECT
	book,
	arraySum(sum_mtf) AS sum_mtf
FROM (
	SELECT
		book,
		sumForEach(mtf) AS sum_mtf
	FROM tradeFactTable
	GROUP BY
		book
)
format Null	

