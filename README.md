# A3D Optimizer — Experimental Repository

This repository accompanies the scientific paper:  
**_“Optimizing Array-Relational Analytical Queries”_**

It contains all the necessary materials to reproduce the experimental results presented in the paper, including the query workloads, data model, and execution setup.


## Backend-Independent Input Queries

The industrial workload is specified in a single declarative, backend-independent JSON format under `Input_Queries/`.
 These 18 queries come from an
industrial financial use case. Each JSON file
describes a logical analytical query using `metrics` (aggregations), `groupBy` dimensions,
and a `filter` tree, without embedding backend-specific SQL syntax.

To isolate A3D's contribution, we provide two SQL versions for each backend:
* **Original queries**: direct, non-optimized SQL translations of the input queries. These
  are submitted unchanged to the backend, which may still apply its own built-in optimizer.
* **A3D-optimized queries**: SQL queries generated after A3D has rewritten the logical plan.
  These are executed by the same backend engine as the corresponding original queries.

In both configurations, the execution engine is identical; the only difference is whether
A3D rewrites the logical plan before SQL generation.

The same query index `Qn` is used consistently across the repository:

* Input query: `Input_Queries/Qn.json`
* Baseline SQL query for `<backend>`:
  `<backend>/Industrial_Queries/Original_Queries/Qn.sql`
* A3D-optimized SQL query for `<backend>`:
  `<backend>/Industrial_Queries/A3D-Optimized_Queries/Qn.sql`

For example, `Input_Queries/Q5.json`,
`ClickHouse/Industrial_Queries/Original_Queries/Q5.sql`,
`Umbra/Industrial_Queries/Original_Queries/Q5.sql`, and
`Snowflake/Industrial_Queries/Original_Queries/Q5.sql` all correspond to the same logical
query, expressed in different backend dialects.

> **Backend coverage.** ClickHouse runs all 18 queries. Umbra and Snowflake cover the
> subset whose array features are expressible in their dialects. Queries `Q14`, `Q16`, and
> `Q18`, as well as the optimized forms of `Q13` and `Q15`, are intentionally absent for
> Umbra and Snowflake because they require unsupported language features.

---

## Benchmark & Dataset

The industrial workload comes from an industrial financial use case.
It is built around a single large, denormalized **fact table** (`tradeFactTable`)
of **over 100 million rows**, with **23 columns of heterogeneous types** (8 distinct
types), including **8 `Array`-typed columns** that encode repeated/hierarchical
attributes (trade legs, scenarios, risk factors) within a single row.

| Category | Columns | Type |
|---|---|---|
| Temporal | `Date`, `tradeDate` | `Date` |
| Identifiers / categorical | `tradeId`, `book`, `counterparty`, `csaId`, `productType`, `mtfScenario` | `String` |
| Scalar measures | `notional`, `mtm` | `Float32` |
| Array dimensions | `legalEntities`, `legIds`, `legCurrencies`, `legTypes` | `Array(String)` |
| Array measures | `riskFactorSpots`, `deltaSpots`, `mtf`, `legNotionals` | `Array(Float32)` |
| Versioning / technical | `csaDictionary`, `commit`, `factor`, `nb_aggregated`, `stream_id` | `UInt64`, `Int64`, `Int8` |

**Data heterogeneity.** The benchmark is challenging because it combines several sources of variability:
- **Varied cardinalities** across scalar and array columns.
- **Multiple value distributions**, including uniform, left-skewed, right-skewed, and normal distributions.
- **Two levels of array variability**: (i) *array-level* — diversity of distinct
  values within a row's array; (ii) *row-level* — frequency of repeated array
  values across rows.
- **Variable array sizes** across attributes.
- **Corresponding (index-aligned) vs. non-corresponding arrays**: some arrays are
  positionally aligned and zipped together (e.g. `legIds`, `legCurrencies`,
  `legTypes`, `legNotionals` describe the same legs), while others are independent —
  exercising both correlated and uncorrelated array flattening.

This multi-level variability makes the workload an authentic, challenging benchmark
for evaluating algebraic transformations over array-valued data.

---

## Repository Structure

### **1. Input_Queries/**

The **18 backend-independent input queries** in declarative JSON form (`Q1.json`–`Q18.json`).
Each file specifies a query as `metrics` (aggregations), `groupBy` (dimensions), and a `filter` tree (`and`/`or`/`in`/`range`). This is the **single
entry point** from which every backend's SQL (both `Original_` and `A3D-Optimized_`) is
derived — see *Backend-Independent Input Queries* above.

### **2. ClickHouse/**

- **`DM/`**: Contains the **DDL scripts** for creating the three ClickHouse tables:
  - `Create_tradeFactTable.sql`
  - `Create_datePlotsZipTable.sql`
  - `Create_csaDictionaryJoin.sql`

- **`Industrial_Queries/`**: Contains the **18 analytical queries** (from `Input_Queries/`) in ClickHouse SQL.
  - `Original_Queries/`: Direct, non-optimized SQL translation of the input query (baseline), executed by ClickHouse's own built-in optimizer
  - `A3D-Optimized_Queries/`: The same query rewritten by our framework before execution

- **`Synthetic_Queries/`**: Synthetic workload that systematically explores various optimization scenarios (array joins, derive transformations, filters, aggregations, etc.).
  - Each subfolder represents a specific use case
  - Each query file provides the two versions (original and optimized)

---

### **3. Umbra/**

- **`DM.sql`**: DDL script for creating the Umbra table schema

- **`Industrial_Queries/`**: industrial queries adapted for Umbra
  - `Original_Queries/`: Original query versions
  - `A3D-Optimized_Queries/`: A3D-optimized query versions

---

### **4. Snowflake/**

- **`DM.sql`**: DDL script for creating the Snowflake table schema

- **`Industrial_Queries/`**: industrial queries adapted for Snowflake
  - `Original_Queries/`: Original query versions
  - `A3D-Optimized_Queries/`: A3D-optimized query versions

---

### **5. Data Files**

- ⚠️ Due to size constraints (≈100M rows in the fact table), the **CSV data files** are hosted externally:
  👉 [Download from Google Drive — ClickHouse](https://drive.google.com/drive/folders/1R0zK2tCM0uaEN6nGqtu699ozlcreGILU) | [Umbra](https://drive.google.com/drive/folders/1c7ySOu9zbyP4k8SJqK1HPJq-yjif6MXM?usp=sharing) | [Snowflake](https://drive.google.com/drive/folders/1WM9GEyd0gkqv-B2iJSXPcOOpA9DMJ58n?usp=drive_link)

---

## ClickHouse

All ClickHouse experiments were conducted using:
- **ClickHouse Client**: `v25.12.1.605` (official build)
- **ClickHouse Server**: `v25.8.10`

---

### **Database Setup**

#### **1. Install ClickHouse**

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Add ClickHouse repository
curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | sudo gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | sudo tee /etc/apt/sources.list.d/clickhouse.list

sudo apt-get update

# Install specific versions
sudo apt-get install -y clickhouse-server=25.8.10 clickhouse-client=25.12.1.605
```

#### **2. Start and Verify the Server**

To start the ClickHouse server and make sure it is running properly:

```bash
# Start the ClickHouse server
sudo service clickhouse-server start

# Check the server status
sudo service clickhouse-server status

# Verify client installation and version
clickhouse-client --version
```

#### **3. Connect to ClickHouse**
```bash
clickhouse-client
```
Exit when needed:
```bash
exit
```

#### **4. Create Database and Tables**
```bash
# Navigate to ClickHouse DM folder
cd ClickHouse/DM

# Create database
clickhouse-client --query="CREATE DATABASE IF NOT EXISTS a3d_experiments;"

# Create tables
clickhouse-client --database=a3d_experiments < Create_tradeFactTable.sql
clickhouse-client --database=a3d_experiments < Create_datePlotsZipTable.sql
clickhouse-client --database=a3d_experiments < Create_csaDictionaryJoin.sql
```

#### **5. Load Data**
The CSV data files are **compressed in `.zip` format**. Download them from [Google Drive](https://drive.google.com/drive/folders/1R0zK2tCM0uaEN6nGqtu699ozlcreGILU) and **decompress them first** before loading into ClickHouse.

```bash
# Insert data into ClickHouse tables
# (Adapt the paths based on where you extracted the CSV files)
clickhouse-client --database=a3d_experiments --query="INSERT INTO tradeFactTable FORMAT CSV" < path/to/tradeFactTable.csv
clickhouse-client --database=a3d_experiments --query="INSERT INTO datePlotsZipTable FORMAT CSV" < path/to/datePlotsZipTable.csv
clickhouse-client --database=a3d_experiments --query="INSERT INTO csaDictionaryJoin FORMAT CSV" < path/to/csaDictionaryJoin.csv
```

---

### **Running the Experiments**

Once the database is set up and populated, you can execute the queries.

#### **Step 1: Connect to ClickHouse**

```bash
clickhouse-client --database=a3d_experiments
```

#### **Step 2: Run a query**

**Option 1:** Copy and paste a query directly
1. Open a query file from `ClickHouse/Industrial_Queries/` or `ClickHouse/Synthetic_Queries/`
2. Copy the SQL content
3. Paste it in the clickhouse-client prompt
4. Press Enter to execute

**Option 2:** Execute a query from a file
```bash
clickhouse-client --database=a3d_experiments < ClickHouse/Industrial_Queries/Original_Queries/Q1.sql
```

#### **Step 3: Check execution time**
- After executing a query, the client shows the result.
- Look at the bottom for **Elapsed:** — this is the **execution time** of the query.
- This allows you to **compare** the original vs optimized query performance.

---

## Umbra

Umbra is a high-performance relational database system. We run it using Docker.

---

### **Database Setup**

#### **1. Install Docker**

Make sure Docker is installed on your system. If not, follow the [official Docker installation guide](https://docs.docker.com/get-docker/).

#### **2. Pull Umbra Docker Image**

```bash
docker pull umbradb/umbra
```

#### **3. Run Umbra Container**

```bash
docker run -v umbra-db:/var/db -p 5432:5432 --ulimit nofile=1048576:1048576 --ulimit memlock=8388608:8388608 umbradb/umbra:latest
```

#### **4. Connect to Umbra**

```bash
psql -h 127.0.0.1 -p 5432 -U postgres
```

When prompted, enter the password: `postgres`

Exit when needed:
```bash
\q
```

#### **5. Create Database and Tables**

```sql
-- Create database
CREATE DATABASE a3d_experiments;

-- Connect to the database
\c a3d_experiments

-- Copy and paste the CREATE TABLE statement from Umbra/DM.sql
```

#### **6. Load Data**

The CSV data file is **compressed in `.zip` format**. Download it from [Google Drive](https://drive.google.com/drive/folders/1c7ySOu9zbyP4k8SJqK1HPJq-yjif6MXM?usp=sharing) and **decompress it first** before loading into Umbra.

```sql
\copy tradeFactTable ( \
    "Date", \
    csaDictionary, \
    tradeDate, \
    tradeId, \
    book, \
    counterparty, \
    csaId, \
    productType, \
    mtfScenario, \
    notional, \
    mtm, \
    riskFactorSpots, \
    deltaSpots, \
    mtf, \
    legalEntities, \
    legIds, \
    legCurrencies, \
    legTypes, \
    legNotionals, \
    commit, \
    factor, \
    nb_aggregated, \
    stream_id \
) \
FROM '/path/to/tradeFactTable-Umbra.csv' \
WITH ( \
    FORMAT csv, \
    HEADER false, \
    DELIMITER ',', \
    QUOTE '"', \
    ESCAPE '"', \
    NULL '' \
);
```

---

### **Running the Experiments**

Once the database is set up and populated, you can execute the queries.

#### **Step 1: Connect to Umbra**

```bash
psql -h 127.0.0.1 -p 5432 -U postgres -d a3d_experiments
```

When prompted, enter the password: `postgres`

#### **Step 2: Enable query timing**

```sql
\timing on
```

#### **Step 3: Run a query**

**Option 1:** Copy and paste a query directly
1. Open a query file from `Umbra/Industrial_Queries/`
2. Copy the SQL content
3. Paste it in the psql prompt
4. Press Enter to execute

**Option 2:** Execute a query from a file
```bash
psql -h 127.0.0.1 -p 5432 -U postgres -d a3d_experiments -f Umbra/Industrial_Queries/Original_Queries/Q1.sql
```

#### **Step 4: Check execution time**
- After executing a query, Umbra displays the execution time at the bottom of the result.
- This allows you to **compare** the original vs optimized query performance.

---

## Snowflake

Snowflake is a cloud-based data warehouse platform. We use the Snowflake web interface for setup and query execution.

---

### **Database Setup**

#### **1. Access Snowflake Cloud Platform**

Sign in to your Snowflake account at [https://app.snowflake.com/](https://app.snowflake.com/)

#### **2. Create Database and Schema**

If not already created, set up your database:
- Database: `snowflake_learning_db`
- Schema: `public` (default)

#### **3. Create Table**

1. In **My Workspace**, click **+ Add new SQL file**
2. Copy the `CREATE TABLE` statement from `Snowflake/DM.sql`
3. Paste it into the SQL editor
4. Click **Run** to create the table

#### **4. Load Data**

Download the data files from [Google Drive](https://drive.google.com/drive/folders/1WM9GEyd0gkqv-B2iJSXPcOOpA9DMJ58n?usp=drive_link) and **decompress them first**.

⚠️ **Note**: The `tradeFactTable` data is already split into **200 CSV files** of **500K rows each** to accommodate Snowflake's 250MB file size limit for web UI uploads.

**Steps to load data:**

1. Navigate to **Data** → **Add Data** → **Load Data into a Table**
2. Select your database: `snowflake_learning_db`
3. Select your schema: `public`
4. Select your table: `TRADEFACTTABLE`
5. **Drag and drop** the CSV files into the upload area (you can upload multiple files at once)
6. Click **Load** to import all the data

#### **5. Configure Warehouse**

Snowflake allows you to choose different warehouse sizes for query execution:

- **XS (Extra Small)**: Default warehouse `compute_wh`
- **L (Large)**: For performance comparison

**To create a Large warehouse:**
1. Go to **Compute** → **Warehouses**
2. Click **+ Warehouse**
3. Set the size to **Large**
4. Name it (e.g., `large_compute_wh`)
5. Click **Create Warehouse**

---

### **Running the Experiments**

Once the database is set up and data is loaded, you can execute queries.

#### **Step 1: Create a New SQL File**

1. In **My Workspace**, click **+ Add new SQL file**
2. Select your warehouse (XS or L) from the dropdown at the top right
3. Ensure your context is set to:
   - Database: `snowflake_learning_db`
   - Schema: `public`

#### **Step 2: Run a query**

1. Open a query file from `Snowflake/Industrial_Queries/Original_Queries/` or `Snowflake/Industrial_Queries/A3D-Optimized_Queries/`
2. Copy the SQL content
3. Paste it into the SQL editor
4. Click **Run** (or press `Ctrl+Enter`)

#### **Step 3: Check execution time**
- After executing a query, Snowflake displays the **execution time** in the **Query Details** panel at the bottom
- You can also view detailed performance metrics by clicking on the query in the **Query History**
- This allows you to **compare** the original vs optimized query performance across different warehouse sizes (XS vs L)
