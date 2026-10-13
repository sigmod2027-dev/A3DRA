--   test("Query with a dimension, an array and, and a metric of array filtered")

SELECT
	book,
	legType,
	sum(sum_legNotional) AS sum_legNotional
FROM (
	SELECT
		legType,
		sum_legNotional,
		book,
		legTypes
	FROM (
		SELECT
			book,
			legTypes,
			arrayDistinct(arrayZip(if(notEmpty(legTypes),legTypes,[NULL]),sumForEach(arrayMap(x -> x * factor,legNotionals)))) AS
			legTypesum_legNotional,
			tupleElement(legTypesum_legNotional,1) AS legType,
			tupleElement(legTypesum_legNotional,2) AS sum_legNotional
		FROM  tradeFactTable
		GROUP BY
			book,
			legTypes
	)
	ARRAY JOIN
		legType,
		sum_legNotional
)
GROUP BY
	book,
	legType
 HAVING
	sum_legNotional > 200000000000 AND 
        sum_legNotional < 300000000000


