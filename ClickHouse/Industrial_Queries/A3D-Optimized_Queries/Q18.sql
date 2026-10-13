--test("Query with array dimension, zip array metric without zip label")

SELECT
	datePlotsfiltered,
	legType,
	sum(sum_legNotional) AS sum_legNotional,
	sum(sum_mtf) AS sum_mtf

FROM (

		SELECT
			legType,
			datePlotsfiltered,
			tradeFactTable_datePlotsZipTable,
			mtfScenariojoinmtfScenario,
			arrayElement(arrayReduce('sumForEach',tupleElement(groupUniqArray((bid,sum_mtf)),2)),tradeFactTable_datePlotsZipTable) AS sum_mtf,
			arrayReduce('sum',tupleElement(groupUniqArray((bid,_arrayGroupIdx0,sum_legNotional)),3)) AS sum_legNotional
		FROM (
			SELECT
				_arrayGroupIdx0,
				legType,
				sum_legNotional,
				mtfScenariojoinmtfScenario,
				tradeFactTable_datePlotsZipTable,
				sum_mtf,
				bid,
				datePlotsfiltered
				
			FROM (
	
			  select * from (SELECT
					sumForEach(arrayMap(x -> x * factor,legNotionals)) AS sum_legNotional,
					legTypes,
					mtfScenario AS mtfScenariojoinmtfScenario,
					sumForEach(arrayMap(x -> x * factor,mtf)) AS sum_mtf,
					if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
					arrayEnumerate(legType) AS _arrayGroupIdx0,
					rowNumberInAllBlocks() AS bid
				FROM tradeFactTable
				GROUP BY
					legTypes,
					mtfScenariojoinmtfScenario
				
		
	
) AS left
ALL INNER JOIN
	(
		SELECT
			mtfScenariojoinmtfScenario,
			datePlotsfiltered,
			tradeFactTable_datePlotsZipTable
		FROM (
			SELECT
				mtfScenario AS mtfScenariojoinmtfScenario,
				arrayEnumerate(datePlots) AS datePlotsArrayEnumerate,
				arrayFilter(datePlots,datePlotsArrayEnumerate -> datePlots IN '2021-11-04',arrayZip(datePlots,datePlotsArrayEnumerate)) AS
				_datePlotstradeFactTable_datePlotsZipTable,
				tupleElement(_datePlotstradeFactTable_datePlotsZipTable,1) AS datePlotsfiltered,
				tupleElement(_datePlotstradeFactTable_datePlotsZipTable,2) AS tradeFactTable_datePlotsZipTable
			FROM datePlotsZipTable
			WHERE
				arrayExists(datePlots -> datePlots IN '2021-11-04',datePlots)
		)
		ARRAY JOIN
			 datePlotsfiltered,
			 tradeFactTable_datePlotsZipTable
			 
	) AS right
USING
	mtfScenariojoinmtfScenario
)
ARRAY JOIN
				_arrayGroupIdx0,
				legType,
				sum_legNotional
		)
		GROUP BY
			legType,
			mtfScenariojoinmtfScenario,
			datePlotsfiltered,
			tradeFactTable_datePlotsZipTable
	)
	
GROUP BY
	datePlotsfiltered,
	legType

