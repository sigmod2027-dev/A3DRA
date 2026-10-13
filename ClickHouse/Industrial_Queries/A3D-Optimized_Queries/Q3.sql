--test( "Query with an array dimension, a scalar metric and a filter on a non-projected")

SELECT
	legCurrency,
	legType,
	sum(sum_mtm) AS sum_mtm
FROM (
	WITH
		arrayFilter(legCurrency,legId,legType -> legId IN 'leg212',arrayZip(if(notEmpty(legCurrencies),legCurrencies,[NULL]),if(notEmpty(legIds),legIds,[NULL]),if(notEmpty(legTypes),legTypes,[NULL]))) AS _legCurrencylegIdlegType
	SELECT
		legCurrencies,
		sum(mtm * factor) AS sum_mtm,
		legIds,
		legTypes,
		tupleElement(_legCurrencylegIdlegType,2) AS legId,
		tupleElement(_legCurrencylegIdlegType,1) AS legCurrency,
		tupleElement(_legCurrencylegIdlegType,3) AS legType
	FROM  tradeFactTable
	WHERE
		arrayExists(legId -> legId IN 'leg212',legIds)
	GROUP BY
		legCurrencies,
		legIds,
		legTypes
)
ARRAY JOIN
	legCurrency,
	legType
GROUP BY
	legCurrency,
	legType

