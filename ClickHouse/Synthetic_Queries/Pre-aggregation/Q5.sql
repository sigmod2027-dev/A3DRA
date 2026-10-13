---original query----
SELECT
	book,
	legTypes,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		book,
		legTypes,
		mtm * factor AS sum_mtm
	FROM tradeFactTable
)
ARRAY JOIN
	legTypes
GROUP BY
	book,
	legTypes
Format Null

---optimized query -----
SELECT
	book,
	legTypes,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		book,
		legTypes,
		sum(mtm * factor) AS sum_mtm
	FROM tradeFactTable
	
	GROUP BY
		book,
		legTypes
)
ARRAY JOIN
	legTypes
GROUP BY
	book,
	legTypes
Format Null	

