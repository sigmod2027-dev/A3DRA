---original query----
SELECT
	book,
	legalEntities,
	sum(riskFactorSpots) AS sum_riskFactorSpots
	FROM tradeFactTable

ARRAY JOIN
	riskFactorSpots
GROUP BY
	book,legalEntities
format Null

---optimized query -----
SELECT
	book,
	legalEntities,
	arraySum(sum_riskFactorSpots) AS sum_riskFactorSpots
FROM (
	SELECT
		book,
		legalEntities,
		sumForEach(riskFactorSpots) AS sum_riskFactorSpots
	FROM tradeFactTable
	GROUP BY
		book,legalEntities
)
format Null			

