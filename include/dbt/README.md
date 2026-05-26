# dbt Jaffle Shop

A dbt learning project modelling a fictional food truck business — Jaffle Shop. Built on DuckDB with a layered architecture covering staging, intermediate, and mart models. Mart tables are designed with the intention of being modelled in a BI layer (e.g. Power BI).

## Project structure

```
dbt-jaffle-shop/
├── seeds/jaffle-data/       # Raw CSV source data
├── models/
│   ├── staging/             # Light transforms from raw sources (views)
│   ├── intermediate/        # Reusable building blocks (ephemeral)
│   └── mart/sales/          # Business-facing tables (tables)
└── tests/                   # Custom data tests
```

## Data sources

Six raw tables loaded via seeds:

| Table | Description |
|---|---|
| `raw_customers` | One row per customer |
| `raw_orders` | One row per order |
| `raw_items` | One row per item per order |
| `raw_products` | One row per product |
| `raw_stores` | One row per store |
| `raw_supplies` | One row per supply item per product |

## Model layers

**Staging** — thin views over raw sources, renaming, casting and small cleaning only.

**Intermediate** — `int_cost_per_product` aggregates supply costs per product to calculate unit cost. 

**Mart** — five tables exposed to BI tools:

| Model | Description |
|---|---|
| `orders` | Orders fact table with date, product, customer, store, pricing, cost, and profit per order line |
| `customers` | Customer dimension |
| `products` | Product dimension |
| `stores` | Store dimension |
| `supplies` | Supplies dimension |

## Setup

**Prerequisites:** Python 3.x

```bash
# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dbt with DuckDB adapter
pip install dbt-duckdb

# Navigate to the project
cd jaffle_shop_v2

# Load seed data, run models, and test
dbt seed
dbt run
dbt test
```

The DuckDB database file is written to `jaffle_shop_v2/dev.duckdb`.

## Tests

- **Schema tests** — `not_null` checks on all mart model columns
- **Custom test** — `order_totals_match.sql` validates that calculated order amounts in the mart match the totals from the staging layer (catches floating-point drift)

```bash
dbt test
```

## Generate docs

```bash
dbt docs generate
dbt docs serve
```
