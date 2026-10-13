
--- Q14 : compound filters :  Sel(AND) = 0  ---

--- original query ---------- 

SELECT 
    book, 
    csaId, 
    legId, 
    legCurrency,
    legType
FROM tradeFactTable AS fact 
ARRAY JOIN 
	legTypes as legType,
    	legIds AS legId, 
    	legCurrencies AS legCurrency
WHERE legType = 'call' and legId = 'leg6'
FORMAT Null

---optimized query -----

SELECT 
    book, 
    csaId, 
    legId, 
    legCurrency,
    legType
FROM 
(
    SELECT 
        book, 
        csaId, 
        arrayFilter((legType, legId, legCurrency) -> (legType = 'call') and (legId = 'leg6'), arrayZip(legTypes,legIds, legCurrencies)) AS legTypelegIdlegCurrency, 
        legTypelegIdlegCurrency.1 AS legType,
        legTypelegIdlegCurrency.2 AS legId, 
        legTypelegIdlegCurrency.3 AS legCurrency
    FROM tradeFactTable AS fact 
    WHERE legId!=[] and legCurrency!=[] and legType!=[]
) 
ARRAY JOIN 
    legId, 
    legCurrency,
    legType
FORMAT Null
