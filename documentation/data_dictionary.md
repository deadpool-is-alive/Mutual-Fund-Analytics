# Database Tables and Columns

## dim_fund

Dimension table containing mutual fund scheme metadata. **Source:** `01_fund_master.csv`.

| Column            | Type   | Source             | Description                               |
|-------------------|--------|--------------------|-------------------------------------------|
| amfi_code         | TEXT   | 01_fund_master.csv | AMFI scheme code (primary key)            |
| fund_house        | TEXT   | 01_fund_master.csv | Name of the fund house (company)          |
| scheme_name       | TEXT   | 01_fund_master.csv | Name of the scheme                        |
| category          | TEXT   | 01_fund_master.csv | High-level category (e.g., Equity, Debt)  |
| sub_category      | TEXT   | 01_fund_master.csv | More specific category (e.g., Large Cap)  |
| benchmark         | TEXT   | 01_fund_master.csv | Benchmark index of the scheme             |
| expense_ratio_pct | REAL   | 01_fund_master.csv | Expense ratio percentage                  |

## dim_date

Calendar date dimension table (one row per unique date). **Source:** Generated (not from a CSV file).

| Column      | Type     | Source       | Description                                           |
|-------------|----------|--------------|-------------------------------------------------------|
| date_id     | INTEGER  | *Generated*  | Surrogate key (auto-incrementing ID for each date)    |
| date        | DATE     | *Generated*  | Actual date (unique, not null)                        |
| year        | INTEGER  | *Generated*  | Year component of the date (YYYY)                     |
| month       | INTEGER  | *Generated*  | Month component of the date (1-12)                    |
| quarter     | INTEGER  | *Generated*  | Quarter of the year (1-4)                             |
| day         | INTEGER  | *Generated*  | Day of month (1-31)                                   |
| weekday     | INTEGER  | *Generated*  | Weekday number (e.g., Monday=0, Sunday=6)             |
| is_weekday  | BOOLEAN  | *Generated*  | 1 if the date is a weekday (Mon–Fri), 0 if weekend    |

## fact_nav

Fact table of daily Net Asset Value (NAV) per scheme. **Source:** `02_nav_history.csv`.

| Column           | Type    | Source            | Description                                               |
|------------------|---------|-------------------|-----------------------------------------------------------|
| nav_id           | INTEGER | *Generated*       | Primary key (autoincrementing ID for each NAV record)     |
| amfi_code        | TEXT    | 02_nav_history.csv| Scheme code (foreign key to `dim_fund.amfi_code`)         |
| date             | DATE    | 02_nav_history.csv| NAV date (foreign key to `dim_date.date`)                 |
| nav              | REAL    | 02_nav_history.csv| Net Asset Value of the scheme on that date                |
| daily_return_pct | REAL    | *Calculated*      | Daily NAV change as a percentage (compared to previous day) |

## fact_transaction

Fact table of investor transactions. **Source:** `08_investor_transactions.csv`. (Only key fields are loaded; other fields like state/city are not included.)

| Column           | Type    | Source                    | Description                                      |
|------------------|---------|---------------------------|--------------------------------------------------|
| tx_id            | INTEGER | *Generated*               | Primary key (autoincrementing transaction ID)    |
| investor_id      | TEXT    | 08_investor_transactions.csv | Unique ID of the investor                         |
| amfi_code        | TEXT    | 08_investor_transactions.csv | Scheme code (foreign key to `dim_fund.amfi_code`) |
| transaction_date | DATE    | 08_investor_transactions.csv | Date of the transaction                            |
| amount_inr       | REAL    | 08_investor_transactions.csv | Transaction amount in INR                          |
| transaction_type | TEXT    | 08_investor_transactions.csv | Type of transaction (e.g., buy, sell)              |

## fact_performance

Fact table of scheme performance metrics. **Source:** `07_scheme_performance.csv`. (Only selected fields are stored.)

| Column           | Type    | Source                    | Description                                  |
|------------------|---------|---------------------------|----------------------------------------------|
| performance_id   | INTEGER | *Generated*               | Primary key (autoincrementing ID)            |
| amfi_code        | TEXT    | 07_scheme_performance.csv | Scheme code (foreign key to `dim_fund.amfi_code`) |
| as_of_date       | DATE    | *Assigned*                | Date of performance snapshot (e.g., current date) |
| return_1yr_pct   | REAL    | 07_scheme_performance.csv | 1-year return percentage                     |
| return_3yr_pct   | REAL    | 07_scheme_performance.csv | 3-year return percentage                     |
| return_5yr_pct   | REAL    | 07_scheme_performance.csv | 5-year return percentage                     |
| sharpe_ratio     | REAL    | 07_scheme_performance.csv | Sharpe ratio of the scheme                   |
| alpha            | REAL    | 07_scheme_performance.csv | Alpha of the scheme                          |
| beta             | REAL    | 07_scheme_performance.csv | Beta of the scheme                           |
| max_drawdown_pct | REAL    | 07_scheme_performance.csv | Maximum drawdown percentage                  |

## fact_portfolio

Fact table of scheme portfolio holdings. **Source:** `09_portfolio_holdings.csv`. (Fields like `market_value_cr` and `current_price_inr` are omitted.)

| Column        | Type    | Source                     | Description                                    |
|---------------|---------|----------------------------|------------------------------------------------|
| portfolio_id  | INTEGER | *Generated*                | Primary key (autoincrementing ID)              |
| amfi_code     | TEXT    | 09_portfolio_holdings.csv  | Scheme code (foreign key to `dim_fund.amfi_code`) |
| stock_symbol  | TEXT    | 09_portfolio_holdings.csv  | Stock ticker symbol                            |
| stock_name    | TEXT    | 09_portfolio_holdings.csv  | Name of the stock                              |
| sector        | TEXT    | 09_portfolio_holdings.csv  | Sector of the stock                            |
| weight_pct    | REAL    | 09_portfolio_holdings.csv  | Weight of the stock in the portfolio (percent) |
| portfolio_date| DATE    | 09_portfolio_holdings.csv  | Date of the portfolio snapshot                 |

## fact_aum

Fact table of Assets Under Management by fund house. **Source:** `03_aum_by_fund_house.csv`.

| Column     | Type    | Source                    | Description                                         |
|------------|---------|---------------------------|-----------------------------------------------------|
| aum_id     | INTEGER | *Generated*               | Primary key (autoincrementing ID)                   |
| fund_house | TEXT    | 03_aum_by_fund_house.csv  | Name of the fund house                              |
| aum_date   | DATE    | 03_aum_by_fund_house.csv  | Date of the AUM record (from source column `date`)  |
| aum_crore  | REAL    | 03_aum_by_fund_house.csv  | Assets Under Management (in crores)                 |
| num_schemes| INTEGER | 03_aum_by_fund_house.csv  | Number of schemes active in that fund house         |

## fact_sip_industry

Fact table of monthly SIP inflows. **Source:** `04_monthly_sip_inflows.csv`. (CSV column `active_sip_accounts_crore` is loaded as `sip_accounts_crore`.)

| Column             | Type   | Source                       | Description                                             |
|--------------------|--------|------------------------------|---------------------------------------------------------|
| month              | DATE   | 04_monthly_sip_inflows.csv   | Month (represented as first day of the month)           |
| sip_inflow_crore   | REAL   | 04_monthly_sip_inflows.csv   | SIP inflow amount (in crores)                           |
| sip_accounts_crore | REAL   | 04_monthly_sip_inflows.csv   | Active SIP accounts (in crores; from `active_sip_accounts_crore`) |
