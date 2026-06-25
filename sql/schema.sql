PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS dim_fund (
    amfi_code TEXT PRIMARY KEY,
    fund_house TEXT NOT NULL,
    scheme_name TEXT NOT NULL,
    category TEXT,
    sub_category TEXT,
    benchmark TEXT,
    expense_ratio_pct REAL
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_id INTEGER PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    day INTEGER,
    weekday INTEGER,
    is_weekday BOOLEAN
);

CREATE TABLE IF NOT EXISTS fact_nav(
    nav_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amfi_code TEXT NOT NULL,
    date DATE NOT NULL,
    nav REAL NOT NULL,
    daily_return_pct REAL,

    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

CREATE TABLE IF NOT EXISTS fact_transaction(
    tx_id INTEGER PRIMARY KEY AUTOINCREMENT,
    investor_id TEXT,
    amfi_code TEXT NOT NULL,
    transaction_date DATE,
    amount_inr REAL,
    transaction_type TEXT,

    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

CREATE TABLE IF NOT EXISTS fact_performance(
    performance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amfi_code TEXT NOT NULL,
    as_of_date DATE,

    return_1yr_pct REAL,
    return_3yr_pct REAL,
    return_5yr_pct REAL,

    sharpe_ratio REAL,
    alpha REAL,
    beta REAL,
    max_drawdown_pct REAL,

    FOREIGN KEY (amfi_code) REFERENCES dim_fund(amfi_code)
);

CREATE TABLE IF NOT EXISTS fact_portfolio (
    portfolio_id INTEGER PRIMARY KEY AUTOINCREMENT,

    amfi_code TEXT NOT NULL,
    stock_symbol TEXT,
    stock_name TEXT,

    sector TEXT,
    weight_pct REAL,

    portfolio_date DATE,

    FOREIGN KEY(amfi_code)
        REFERENCES dim_fund(amfi_code)
);

CREATE TABLE IF NOT EXISTS fact_aum (

    aum_id INTEGER PRIMARY KEY AUTOINCREMENT,

    fund_house TEXT,

    aum_date DATE,

    aum_crore REAL,

    num_schemes INTEGER
);

CREATE TABLE IF NOT EXISTS fact_sip_industry (

    month DATE PRIMARY KEY,

    sip_inflow_crore REAL,

    sip_accounts_crore REAL
);