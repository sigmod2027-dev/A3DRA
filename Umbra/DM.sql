
CREATE TABLE tradeFactTable (
    Date                DATE,
    csaDictionary       NUMERIC,         -- UInt64
    tradeDate           DATE,
    tradeId             TEXT,
    book                TEXT,
    counterparty        TEXT,
    csaId               TEXT,
    productType         TEXT,
    mtfScenario         TEXT,
    notional            REAL,           -- Float32
    mtm                 REAL,           -- Float32
    riskFactorSpots     REAL[],         -- Array(Float32)
    deltaSpots          REAL[],         -- Array(Float32)
    mtf                 REAL[],         -- Array(Float32)
    legalEntities       TEXT[],         -- Array(String)
    legIds              TEXT[],         -- Array(String)
    legCurrencies       TEXT[],         -- Array(String)
    legTypes            TEXT[],         -- Array(String)
    legNotionals        REAL[],         -- Array(Float32)
    commit              BIGINT,         -- Int64
    factor              SMALLINT,       -- Int8
    nb_aggregated       NUMERIC,        -- UInt64
    stream_id           BIGINT          -- Int64
);




