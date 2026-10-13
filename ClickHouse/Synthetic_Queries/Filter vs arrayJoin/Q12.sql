
--- Q12 : selective filter : Sel(leg39) = 80k (0.08%),  corresponding arrays   ---

--- original query ---------- 

SELECT 
    book, 
    csaId, 
    legId, 
    legCurrency
FROM tradeFactTable AS fact 
ARRAY JOIN 
    legIds AS legId, 
    legCurrencies AS legCurrency
WHERE legId = 'leg39'
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
        arrayFilter((legId, legCurrency) -> (legId = 'leg39'), arrayZip(legIds, legCurrencies)) AS legIdlegCurrency, 
        legIdlegCurrency.1 AS legId, 
        legIdlegCurrency.2 AS legCurrency
    FROM tradeFactTable AS fact 
    WHERE legId!=[] and legCurrency!=[]
) 
ARRAY JOIN 
    legId, 
    legCurrency
FORMAT Null


