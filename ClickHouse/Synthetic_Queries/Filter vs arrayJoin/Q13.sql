
--- Q13 : non-selective filter : Sel(call) = 74M (74%),  corresponding arrays   ---

--- original query ---------- 

SELECT 
    book, 
    csaId, 
    legId, 
    legCurrency
FROM tradeFactTable AS fact 
ARRAY JOIN 
	legTypes as legType,
    	legIds AS legId, 
    	legCurrencies AS legCurrency
WHERE legType = 'call'
FORMAT Null

---optimized query -----

SELECT 
    book, 
    csaId, 
    legId, 
    legCurrency
FROM 
(
    SELECT 
        book, 
        csaId, 
        arrayFilter((legType, legId, legCurrency) -> (legType = 'call'), arrayZip(legTypes,legIds, legCurrencies)) AS legTypelegIdlegCurrency, 
        legTypelegIdlegCurrency.2 AS legId, 
        legTypelegIdlegCurrency.3 AS legCurrency
    FROM tradeFactTable AS fact 
    WHERE legId!=[] and legCurrency!=[]
) 
ARRAY JOIN 
    legId, 
    legCurrency
FORMAT Null

