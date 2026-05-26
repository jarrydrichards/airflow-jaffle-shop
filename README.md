# Airflow Jaffle Shop

An [Astronomer](https://www.astronomer.io/) Airflow project that orchestrates a [dbt](https://www.getdbt.com/) pipeline for the classic Jaffle Shop demo dataset, using DuckDB as the data warehouse.

## Overview

This project runs a daily dbt pipeline with the following stages:

```
dbt_seed → dbt_run_staging → dbt_run_intermediate → dbt_run_marts
```

1. **seed** — loads raw CSV data into DuckDB
2. **staging** — cleans and standardises raw source data
3. **intermediate** — applies business logic transformations
4. **marts** — produces final analytical models

The dbt project is sourced from [jarrydrichards/dbt-jaffle-shop](https://github.com/jarrydrichards/dbt-jaffle-shop) and mounted at `/usr/local/airflow/include/dbt` inside the container.

## Prerequisites

- [Astro CLI](https://docs.astronomer.io/astro/cli/install-cli)
- Docker Desktop

## Getting Started

```bash
# Start the local Airflow environment
astro dev start
```

The Airflow UI will be available at [http://localhost:8080](http://localhost:8080) (default credentials: `admin` / `admin`).

To stop the environment:

```bash
astro dev stop
```

## Project Structure

```
airflow-jaffle-shop/
├── dags/
│   └── jaffle-shop-pipeline.py   # Main pipeline DAG
├── tests/
│   └── dags/                     # DAG integrity tests
├── Dockerfile                    # Astro Runtime image + dbt setup
├── requirements.txt              # Python dependencies (dbt-duckdb)
├── packages.txt                  # OS-level packages
└── airflow_settings.yaml         # Local connections, pools, and variables
```

## Stack

| Tool | Purpose |
|------|---------|
| Astro Runtime 3.2-4 | Airflow base image |
| Apache Airflow | Workflow orchestration |
| dbt | Data transformation |
| DuckDB | Embedded analytical database |
