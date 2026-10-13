-- test("Query with dimension, two join array dimension, a scalar metric and a filter those two arrays dimension")

with arrayDistinct(arrayZip(tupleElement(arrayFilter(legCurrency,legId -> legCurrency IN 'USD' AND legId IN 'leg6',arrayZip(if(notEmpty(legCurrencies),legCurrencies,[NULL]),if(notEmpty(legIds),legIds,[NULL]))),1),tupleElement(arrayFilter(legCurrency,legId -> legCurrency IN 'USD' AND legId IN 'leg6',arrayZip(if(notEmpty(legCurrencies),legCurrencies,[NULL]),if(notEmpty(legIds),legIds,[NULL]))),2))) AS _legCurrencylegId
SELECT
	book,
	legCurrency,
	legId,
	sum(sum_mtm) AS sum_mtm
FROM (
	SELECT
		legCurrencies,
		sum(mtm * factor) AS sum_mtm,
		legIds,
		book
	FROM tradeFactTable
	WHERE
		arrayExists(legCurrency,legId -> legCurrency IN 'USD' AND legId IN 'leg6',legCurrencies,legIds) AND
		arrayExists(legId -> legId IN 'leg6',legIds)
	GROUP BY
		book,
		legCurrencies,
		legIds
)
ARRAY JOIN
	tupleElement(_legCurrencylegId,1) AS legCurrency,
	tupleElement(_legCurrencylegId,2) AS legId
GROUP BY
	book,
	legCurrency,
	legId

