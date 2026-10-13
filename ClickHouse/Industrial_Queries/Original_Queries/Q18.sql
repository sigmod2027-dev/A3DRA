--test("Query with array dimension, zip array metric without zip label")

SELECT 
        datePlots,
        legType,
        sum(sum_legNotional) AS sum_legNotional,
        sum(sum_mtf) AS sum_mtf
FROM (
        SELECT 
                legType,
                mtfScenariojoinmtfScenario,
                sum_legNotional,
                sum_mtf,
                tradeFactTable_datePlotsZipTable
        FROM (
                SELECT 
                        legType,
                        mtfScenariojoinmtfScenario,
                        arrayReduce('sumForEach',tupleElement(groupUniqArray((bid,sum_mtf)),2)) AS sum_mtf,
                        arrayReduce('sum',tupleElement(groupUniqArray((bid,_arrayGroupIdx0,sum_legNotional)),3)) AS sum_legNotional,
                        arrayEnumerate(sum_mtf) AS tradeFactTable_datePlotsZipTable
                FROM (
                        SELECT 
                                _arrayGroupIdx0,
                                legType,
                                sum_legNotional,
                                legTypes,
                                mtfScenariojoinmtfScenario,
                                sum_mtf,
                                bid
                        FROM (
                                SELECT 
                                        legTypes,
                                        mtfScenario AS mtfScenariojoinmtfScenario,
                                        arrayMap(x -> x * factor,legNotionals) AS sum_legNotional,
                                        arrayMap(x -> x * factor,mtf) AS sum_mtf,
                                        rowNumberInAllBlocks() AS bid,
                                        if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
                                        arrayEnumerate(legType) AS _arrayGroupIdx0
                                FROM  tradeFactTable
                        )
                        ARRAY JOIN 
                                _arrayGroupIdx0,
                                legType,
                                sum_legNotional
                )
                GROUP BY 
                        legType,
                        mtfScenariojoinmtfScenario
        )
        ARRAY JOIN 
                sum_mtf,
                tradeFactTable_datePlotsZipTable
) AS left
ALL INNER JOIN 
        (
                SELECT 
                        datePlots,
                        mtfScenario AS mtfScenariojoinmtfScenario,
                        tradeFactTable_datePlotsZipTable
                FROM  datePlotsZipTable
                ARRAY JOIN 
                        datePlots,
                        arrayEnumerate(datePlots) AS tradeFactTable_datePlotsZipTable
                WHERE
                        datePlots IN '2021-11-04'
        ) AS right
USING
        mtfScenariojoinmtfScenario,
        tradeFactTable_datePlotsZipTable
GROUP BY 
        datePlots,
        legType

