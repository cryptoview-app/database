-- =============================================
--  CryptoView — SQL Queries
--  Демонстрационные запросы к базе данных
-- =============================================


-- ─────────────────────────────────────────────
--  1. SELECT с условием (WHERE)
-- ─────────────────────────────────────────────

-- 1.1 Монеты с ростом цены за 24ч больше 2%
SELECT name, symbol, current_price, price_change_24h
FROM coins
WHERE price_change_24h > 2
ORDER BY price_change_24h DESC;

-- 1.2 Топ-5 монет по рыночной капитализации
SELECT market_cap_rank, name, symbol, current_price, market_cap
FROM coins
WHERE market_cap_rank <= 5
ORDER BY market_cap_rank ASC;

-- 1.3 Пользователи, зарегистрированные за последний месяц
SELECT username, email, created_at
FROM users
WHERE created_at >= NOW() - INTERVAL '30 days'
ORDER BY created_at DESC;

-- 1.4 Позиции портфеля с прибылью (текущая цена выше цены покупки)
SELECT
    p.id,
    c.name          AS coin,
    c.symbol,
    p.quantity,
    p.buy_price,
    c.current_price,
    ROUND((c.current_price - p.buy_price) / p.buy_price * 100, 2) AS profit_pct
FROM portfolio p
         JOIN coins c ON c.id = p.coin_id
WHERE c.current_price > p.buy_price
ORDER BY profit_pct DESC;

-- 1.5 История цен Bitcoin за последние 3 часа
SELECT
    c.name,
    ph.price,
    ph.volume,
    ph.recorded_at
FROM price_history ph
         JOIN coins c ON c.id = ph.coin_id
WHERE c.coingecko_id = 'bitcoin'
  AND ph.recorded_at >= NOW() - INTERVAL '3 hours'
ORDER BY ph.recorded_at ASC;


-- ─────────────────────────────────────────────
--  2. INSERT — добавление новых записей
-- ─────────────────────────────────────────────

-- 2.1 Новый пользователь
INSERT INTO users (username, email, password_hash)
VALUES ('new_trader', 'trader@example.com', '$2b$12$newhashedpasswordexample123456789');

-- 2.2 Новая монета
INSERT INTO coins (coingecko_id, symbol, name, image_url, current_price, market_cap, market_cap_rank, price_change_24h, total_volume)
VALUES ('polkadot', 'DOT', 'Polkadot',
        'https://assets.coingecko.com/coins/images/12171/large/polkadot.png',
        8.45, 11000000000.00, 11, 1.23, 420000000.00);

-- 2.3 Добавить монету в избранное пользователю с id=4
INSERT INTO watchlist (user_id, coin_id)
VALUES (4, 1);  -- danis_dev добавляет Bitcoin

-- 2.4 Новая позиция в портфеле
INSERT INTO portfolio (user_id, coin_id, quantity, buy_price, notes)
VALUES (4, 1, 0.05, 67000.00, 'Первая покупка BTC');

-- 2.5 Снимок цены для истории
INSERT INTO price_history (coin_id, price, volume)
VALUES (1, 67500.00, 38500000000.00);


-- ─────────────────────────────────────────────
--  3. UPDATE — обновление данных
-- ─────────────────────────────────────────────

-- 3.1 Обновить текущую цену Bitcoin
UPDATE coins
SET current_price    = 67500.00,
    price_change_24h = 2.51,
    last_updated     = NOW()
WHERE coingecko_id = 'bitcoin';

-- 3.2 Обновить email пользователя
UPDATE users
SET email      = 'alex.new@example.com',
    updated_at = NOW()
WHERE username = 'alex_crypto';

-- 3.3 Обновить заметку к позиции в портфеле
UPDATE portfolio
SET notes = 'Обновлено: долгосрочный холд до 2026'
WHERE user_id = 1
  AND coin_id = 1;

-- 3.4 Массовое обновление — сбросить rank у всех монет (перед пересчётом)
UPDATE coins
SET market_cap_rank = NULL
WHERE market_cap IS NULL;


-- ─────────────────────────────────────────────
--  4. DELETE — удаление данных
-- ─────────────────────────────────────────────

-- 4.1 Удалить монету из избранного
DELETE FROM watchlist
WHERE user_id = 2
  AND coin_id = 3;  -- maria_trade убирает Tether из избранного

-- 4.2 Удалить устаревшую историю цен (старше 30 дней)
DELETE FROM price_history
WHERE recorded_at < NOW() - INTERVAL '30 days';

-- 4.3 Удалить позицию из портфеля
DELETE FROM portfolio
WHERE user_id = 2
  AND coin_id = 6;  -- maria_trade закрывает позицию по XRP

-- 4.4 Удалить неактивного пользователя (каскадно удалит watchlist и portfolio)
DELETE FROM users
WHERE username = 'guest_user';


-- ─────────────────────────────────────────────
--  5. SELECT с JOIN
-- ─────────────────────────────────────────────

-- 5.1 Полный портфель пользователя с расчётом прибыли/убытка
SELECT
    u.username,
    c.name                                                        AS coin,
    c.symbol,
    p.quantity,
    p.buy_price                                                   AS цена_покупки,
    c.current_price                                               AS текущая_цена,
    ROUND(p.quantity * p.buy_price, 2)                            AS вложено_usd,
    ROUND(p.quantity * c.current_price, 2)                        AS текущая_стоимость,
    ROUND((c.current_price - p.buy_price) / p.buy_price * 100, 2) AS прибыль_процент,
    p.bought_at
FROM portfolio p
         JOIN users u ON u.id = p.user_id
         JOIN coins c ON c.id = p.coin_id
WHERE u.username = 'alex_crypto'
ORDER BY текущая_стоимость DESC;

-- 5.2 Самые популярные монеты в избранном (топ по количеству добавлений)
SELECT
    c.name,
    c.symbol,
    c.current_price,
    COUNT(w.id) AS в_избранном_у_пользователей
FROM watchlist w
         JOIN coins c ON c.id = w.coin_id
GROUP BY c.id, c.name, c.symbol, c.current_price
ORDER BY в_избранном_у_пользователей DESC;

-- 5.3 Пользователи и суммарная стоимость их портфеля
SELECT
    u.username,
    COUNT(DISTINCT p.coin_id)                AS кол_во_монет,
    ROUND(SUM(p.quantity * c.current_price), 2) AS стоимость_портфеля_usd,
    ROUND(SUM(p.quantity * p.buy_price), 2)     AS вложено_usd,
    ROUND(SUM(p.quantity * c.current_price)
              - SUM(p.quantity * p.buy_price), 2)     AS прибыль_usd
FROM users u
         JOIN portfolio p ON p.user_id = u.id
         JOIN coins c     ON c.id = p.coin_id
GROUP BY u.id, u.username
ORDER BY стоимость_портфеля_usd DESC;

-- 5.4 Избранные монеты конкретного пользователя с текущими ценами
SELECT
    u.username,
    c.name,
    c.symbol,
    c.current_price,
    c.price_change_24h,
    c.market_cap_rank,
    w.added_at
FROM watchlist w
         JOIN users u ON u.id = w.user_id
         JOIN coins c ON c.id = w.coin_id
WHERE u.username = 'danis_dev'
ORDER BY c.market_cap_rank ASC;

-- 5.5 Динамика цены монеты — min, max, avg за всё время
SELECT
    c.name,
    c.symbol,
    MIN(ph.price)                    AS мин_цена,
    MAX(ph.price)                    AS макс_цена,
    ROUND(AVG(ph.price), 2)          AS средняя_цена,
    COUNT(ph.id)                     AS кол_во_записей,
    MIN(ph.recorded_at)              AS первая_запись,
    MAX(ph.recorded_at)              AS последняя_запись
FROM price_history ph
         JOIN coins c ON c.id = ph.coin_id
GROUP BY c.id, c.name, c.symbol
ORDER BY c.market_cap_rank ASC;