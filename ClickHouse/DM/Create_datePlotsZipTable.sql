-- datePlotsZipTable definition

CREATE TABLE datePlotsZipTable
(

    `mtfScenario` String,

    `datePlots` Array(String)
)
ENGINE = MergeTree()
PARTITION BY tuple()
ORDER BY mtfScenario
SETTINGS index_granularity = 8192;
