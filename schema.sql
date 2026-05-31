-- =============================================
--  CryptoView — Database Schema
--  СУБД: PostgreSQL
--  Описание: база данных крипто-дашборда
-- =============================================

-- Удаление таблиц если существуют (для повторного запуска)
DROP TABLE IF EXISTS price_history CASCADE;
DROP TABLE IF EXISTS portfolio     CASCADE;
DROP TABLE IF EXISTS watchlist     CASCADE;
DROP TABLE IF EXISTS coins         CASCADE;
DROP TABLE IF EXISTS users         CASCADE;

-- ─────────────────────────────────────────────
--  ТАБЛИЦА: users
--  Пользователи приложения
-- ─────────────────────────────────────────────
CREATE TABLE users (
                       id            SERIAL          PRIMARY KEY,
                       username      VARCHAR(50)     NOT NULL UNIQUE,
                       email         VARCHAR(100)    NOT NULL UNIQUE,
                       password_hash VARCHAR(255)    NOT NULL,
                       created_at    TIMESTAMP       NOT NULL DEFAULT NOW(),
                       updated_at    TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ─────────────────────────────────────────────
--  ТАБЛИЦА: coins
--  Монеты (кэш данных с CoinGecko API)
-- ─────────────────────────────────────────────
CREATE TABLE coins (
                       id              SERIAL          PRIMARY KEY,
                       coingecko_id    VARCHAR(100)    NOT NULL UNIQUE,  -- напр. "bitcoin"
                       symbol          VARCHAR(20)     NOT NULL,          -- напр. "BTC"
                       name            VARCHAR(100)    NOT NULL,
                       image_url       TEXT,
                       current_price   NUMERIC(20, 8),
                       market_cap      NUMERIC(30, 2),
                       market_cap_rank INTEGER,
                       price_change_24h NUMERIC(10, 4),                  -- % изменение за 24ч
                       total_volume    NUMERIC(30, 2),
                       last_updated    TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ─────────────────────────────────────────────
--  ТАБЛИЦА: watchlist
--  Избранные монеты пользователя (M:N через связь)
--  Связи: users(1) → watchlist(M) ← coins(1)
-- ─────────────────────────────────────────────
CREATE TABLE watchlist (
                           id         SERIAL      PRIMARY KEY,
                           user_id    INTEGER     NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                           coin_id    INTEGER     NOT NULL REFERENCES coins(id) ON DELETE CASCADE,
                           added_at   TIMESTAMP   NOT NULL DEFAULT NOW(),
                           UNIQUE (user_id, coin_id)  -- один пользователь не может добавить монету дважды
);

-- ─────────────────────────────────────────────
--  ТАБЛИЦА: portfolio
--  Портфель пользователя — купленные монеты
--  Связи: users(1) → portfolio(M) ← coins(1)
-- ─────────────────────────────────────────────
CREATE TABLE portfolio (
                           id             SERIAL          PRIMARY KEY,
                           user_id        INTEGER         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                           coin_id        INTEGER         NOT NULL REFERENCES coins(id) ON DELETE CASCADE,
                           quantity       NUMERIC(20, 8)  NOT NULL CHECK (quantity > 0),
                           buy_price      NUMERIC(20, 8)  NOT NULL CHECK (buy_price > 0),  -- цена покупки в USD
                           bought_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
                           notes          TEXT
);

-- ─────────────────────────────────────────────
--  ТАБЛИЦА: price_history
--  История цен монет (снимки каждые N минут)
--  Связи: coins(1) → price_history(M)
-- ─────────────────────────────────────────────
CREATE TABLE price_history (
                               id          SERIAL          PRIMARY KEY,
                               coin_id     INTEGER         NOT NULL REFERENCES coins(id) ON DELETE CASCADE,
                               price       NUMERIC(20, 8)  NOT NULL,
                               volume      NUMERIC(30, 2),
                               recorded_at TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ─────────────────────────────────────────────
--  ИНДЕКСЫ для ускорения запросов
-- ─────────────────────────────────────────────
CREATE INDEX idx_watchlist_user_id    ON watchlist     (user_id);
CREATE INDEX idx_watchlist_coin_id    ON watchlist     (coin_id);
CREATE INDEX idx_portfolio_user_id    ON portfolio     (user_id);
CREATE INDEX idx_portfolio_coin_id    ON portfolio     (coin_id);
CREATE INDEX idx_price_history_coin   ON price_history (coin_id);
CREATE INDEX idx_price_history_time   ON price_history (recorded_at DESC);
CREATE INDEX idx_coins_rank           ON coins         (market_cap_rank ASC);