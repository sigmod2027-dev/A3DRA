-- test("Query with a dimension, an array and, and a metric that are not optimizable and that have plus inside and outside")

SELECT 
        book,
        legType,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,avg_mtm00,avg_mtm01)),2)) / arrayReduce('sum',tupleElement(groupUniqArray((bid,avg_mtm00,avg_mtm01)),3)) + 2 AS avg_mtm,
        arrayReduce('sum',tupleElement(groupUniqArray((bid,_arrayGroupIdx0,avg_legNotional00,avg_legNotional01)),3)) / arrayReduce('sum',tupleElement(groupUniqArray((bid,_arrayGroupIdx0,avg_legNotional00,avg_legNotional01)),4)) + 2 AS avg_legNotional
FROM (
        SELECT 
                arrayMap(legNotional -> (legNotional + 3) * factor,legNotionals) AS avg_legNotional00,
                arrayMap(legNotional -> if(isNull(legNotional + 3),0,super.nb_aggregated) * factor,legNotionals) AS avg_legNotional01,
                (mtm + 3) * factor AS avg_mtm00,
                if(isNull(mtm + 3),0,super.nb_aggregated) * factor AS avg_mtm01,
                book,
                legTypes,
                rowNumberInAllBlocks() AS bid,
                if(notEmpty(legTypes),legTypes,[NULL]) AS legType,
                arrayEnumerate(avg_legNotional00) AS _arrayGroupIdx0
        FROM  tradeFactTable AS super
)
ARRAY JOIN 
        _arrayGroupIdx0,
        avg_legNotional00,
        avg_legNotional01,
        legType
GROUP BY 
        book,
        legType

