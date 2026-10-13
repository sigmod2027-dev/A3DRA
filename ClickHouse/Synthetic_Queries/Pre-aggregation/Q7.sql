---original query----
SELECT
	tradeId,
	legCurrencies,
	sum(sum_mtm) AS sum_mtm
FROM tradeFactTable
GROUP BY
	tradeId,
	legCurrencies
format Null

---optimized query -----
SELECT tradeId,
	legCurrencies,
	sum(sum_mtm) AS sum_mtm

	from(
	select 
	tradeId,
	legCurrencies,
	sum(mtm) AS sum_mtm
	FROM tradeFactTable
	GROUP BY tradeId,legCurrencies
	)
	
GROUP BY
	tradeId,
	legCurrencies
format Null

