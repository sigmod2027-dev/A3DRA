---original query----
SELECT
	book,
	riskFactorSpots,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		book,
		riskFactorSpots,
		mtm * factor AS sum_mtm
	FROM tradeFactTable
)
ARRAY JOIN
	riskFactorSpots
GROUP BY
	book,
	riskFactorSpots
format Null

---optimized query -----
SELECT
	book,
	riskFactorSpots,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		book,
		riskFactorSpots,
		sum(mtm * factor) AS sum_mtm
	FROM tradeFactTable
	
	GROUP BY
		book,
		riskFactorSpots
)
ARRAY JOIN
	riskFactorSpots
GROUP BY
	book,
	riskFactorSpots
format Null		

