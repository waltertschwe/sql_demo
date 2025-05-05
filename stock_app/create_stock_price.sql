-- Drop tables if they exist.
drop table stock_prices;
drop table stocks;

-- Table to store stock metadata
CREATE TABLE stocks (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) UNIQUE NOT NULL,
    company_name TEXT NOT NULL,
    exchange VARCHAR(20),
    sector TEXT,
    industry TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table to store daily stock price data
CREATE TABLE stock_prices (
    id SERIAL PRIMARY KEY,
    stock_id INTEGER NOT NULL REFERENCES stocks(id) ON DELETE CASCADE,  -- foreign key
    date DATE NOT NULL,
    open_price NUMERIC(12, 4),
    high_price NUMERIC(12, 4),
    low_price NUMERIC(12, 4),
    close_price  NUMERIC(12, 4),
    adjusted_close NUMERIC(12, 4),
    volume BIGINT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT fk_stock FOREIGN KEY (stock_id) REFERENCES stocks(id) ON DELETE CASCADE,
    CONSTRAINT unique_stock_date UNIQUE (stock_id, date)
);

-- For quickly joining stock_prices with stocks
CREATE INDEX idx_stock_prices_stock_id ON stock_prices(stock_id);

-- For retrieving prices by stock and date (descending for most recent first)
CREATE INDEX idx_stock_prices_stock_id_date ON stock_prices(stock_id, date DESC);

-- Optional: if you often query by date range alone (e.g., for all stocks on a specific day)
CREATE INDEX idx_stock_prices_date ON stock_prices(date);

-- Indexes for performance
-- Add indexes on WHERE conditions and Order By columns
-- WHERE conditions will speed up filtering
-- ORDER BY to avoid costly sorting operations.
-- FOREIGN KEY columns should be indexed to speed up joins.

