-- testingArrays.shard_tradeFactTable definition

CREATE TABLE testingArrays.shard_tradeFactTable
(

    `Date` Date,

    `csaDictionary` UInt64,

    `tradeDate` Date,

    `tradeId` String,

    `book` String,

    `counterparty` String,

    `csaId` String,

    `productType` String,

    `mtfScenario` String,

    `notional` Float32,

    `mtm` Float32,

    `riskFactorSpots` Array(Float32),

    `deltaSpots` Array(Float32),

    `mtf` Array(Float32),

    `legalEntities` Array(String),

    `legIds` Array(String),

    `legCurrencies` Array(String),

    `legTypes` Array(String),

    `legNotionals` Array(Float32),

    `commit` Int64,

    `factor` Int8,

    `nb_aggregated` UInt64,

    `stream_id` Int64
)
ENGINE = MergeTree()
PARTITION BY tuple()
ORDER BY tuple()
SETTINGS index_granularity = 8192;
