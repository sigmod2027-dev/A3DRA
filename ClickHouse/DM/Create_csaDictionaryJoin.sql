-- csaDictionaryJoin definition

CREATE TABLE csaDictionaryJoin
(

    `csaId` String,

    `Date` Date,

    `csaDictionary` UInt64,

    `insertDate` DateTime
)
ENGINE = MergeTree()
PARTITION BY Date
ORDER BY metroHash64(csaId,Date)
SETTINGS index_granularity = 8192;
