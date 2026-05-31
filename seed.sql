-- =============================================
--  CryptoView — Seed Data
--  Тестовые данные для заполнения БД
-- =============================================

-- ─────────────────────────────────────────────
--  ПОЛЬЗОВАТЕЛИ
-- ─────────────────────────────────────────────
INSERT INTO users (username, email, password_hash) VALUES
                                                       ('alex_crypto',  'alex@example.com',  '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lfQs1234hashedpwd1'),
                                                       ('maria_trade',  'maria@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lfQs1234hashedpwd2'),
                                                       ('ivan_hodl',    'ivan@example.com',  '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lfQs1234hashedpwd3'),
                                                       ('danis_dev',    'danis@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lfQs1234hashedpwd4'),
                                                       ('guest_user',   'guest@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/lfQs1234hashedpwd5');

-- ─────────────────────────────────────────────
--  МОНЕТЫ (данные актуальны на момент создания БД)
-- ─────────────────────────────────────────────
INSERT INTO coins (coingecko_id, symbol, name, image_url, current_price, market_cap, market_cap_rank, price_change_24h, total_volume) VALUES
                                                                                                                                          ('bitcoin',    'BTC',  'Bitcoin',        'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',        67420.00,   1328000000000.00, 1,   2.34,  38000000000.00),
                                                                                                                                          ('ethereum',   'ETH',  'Ethereum',       'https://assets.coingecko.com/coins/images/279/large/ethereum.png',      3521.50,    423000000000.00,  2,   1.87,  18500000000.00),
                                                                                                                                          ('tether',     'USDT', 'Tether',         'https://assets.coingecko.com/coins/images/325/large/Tether.png',           1.00,    119000000000.00,  3,   0.01,  92000000000.00),
                                                                                                                                          ('binancecoin','BNB',  'BNB',            'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',   598.20,     87000000000.00,  4,  -0.54,   2100000000.00),
                                                                                                                                          ('solana',     'SOL',  'Solana',         'https://assets.coingecko.com/coins/images/4128/large/solana.png',        178.90,     83000000000.00,  5,   3.21,   4800000000.00),
                                                                                                                                          ('ripple',     'XRP',  'XRP',            'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png', 0.5923, 33000000000.00, 6, -1.12,   2300000000.00),
                                                                                                                                          ('dogecoin',   'DOGE', 'Dogecoin',       'https://assets.coingecko.com/coins/images/5/large/dogecoin.png',          0.1632,   23000000000.00,  7,   4.56,   1800000000.00),
                                                                                                                                          ('cardano',    'ADA',  'Cardano',        'https://assets.coingecko.com/coins/images/975/large/cardano.png',         0.4521,   16000000000.00,  8,  -0.89,    980000000.00),
                                                                                                                                          ('avalanche-2','AVAX', 'Avalanche',      'https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png', 38.72, 16000000000.00, 9, 1.45, 620000000.00),
                                                                                                                                          ('chainlink',  'LINK', 'Chainlink',      'https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png', 17.84, 10000000000.00, 10, 2.10, 780000000.00);

-- ─────────────────────────────────────────────
--  ИЗБРАННОЕ (WATCHLIST)
-- ─────────────────────────────────────────────
INSERT INTO watchlist (user_id, coin_id) VALUES
                                             (1, 1),  -- alex_crypto    → Bitcoin
                                             (1, 2),  -- alex_crypto    → Ethereum
                                             (1, 5),  -- alex_crypto    → Solana
                                             (2, 1),  -- maria_trade    → Bitcoin
                                             (2, 3),  -- maria_trade    → Tether
                                             (2, 6),  -- maria_trade    → XRP
                                             (3, 1),  -- ivan_hodl      → Bitcoin
                                             (3, 2),  -- ivan_hodl      → Ethereum
                                             (3, 4),  -- ivan_hodl      → BNB
                                             (4, 2),  -- danis_dev      → Ethereum
                                             (4, 5),  -- danis_dev      → Solana
                                             (4, 9);  -- danis_dev      → Avalanche

-- ─────────────────────────────────────────────
--  ПОРТФЕЛЬ
-- ─────────────────────────────────────────────
INSERT INTO portfolio (user_id, coin_id, quantity, buy_price, bought_at, notes) VALUES
                                                                                    (1, 1, 0.50000000, 58000.00, '2024-01-15 10:30:00', 'Долгосрочная инвестиция'),
                                                                                    (1, 2, 3.20000000, 2800.00,  '2024-02-01 14:00:00', 'DCA стратегия'),
                                                                                    (1, 5, 25.00000000, 120.00,  '2024-03-10 09:15:00', 'Высокий потенциал'),
                                                                                    (2, 1, 0.12500000, 62000.00, '2024-04-05 11:00:00', NULL),
                                                                                    (2, 6, 5000.00000000, 0.48,  '2024-04-20 16:45:00', 'Спекулятивная позиция'),
                                                                                    (3, 1, 1.00000000, 45000.00, '2023-10-01 08:00:00', 'Куплено на дне'),
                                                                                    (3, 2, 10.00000000, 1800.00, '2023-11-15 12:30:00', 'ETH merge ставка'),
                                                                                    (3, 4, 8.50000000, 310.00,   '2024-01-20 10:00:00', 'BNB экосистема'),
                                                                                    (4, 2, 2.00000000, 3100.00,  '2024-05-01 09:00:00', 'Тест портфеля'),
                                                                                    (4, 9, 15.00000000, 32.00,   '2024-03-25 15:20:00', 'AVAX L1');

-- ─────────────────────────────────────────────
--  ИСТОРИЯ ЦЕН (последние записи для каждой монеты)
-- ─────────────────────────────────────────────
INSERT INTO price_history (coin_id, price, volume, recorded_at) VALUES
                                                                    -- Bitcoin
                                                                    (1, 66100.00, 37200000000.00, NOW() - INTERVAL '6 hours'),
                                                                    (1, 66580.00, 37800000000.00, NOW() - INTERVAL '5 hours'),
                                                                    (1, 67020.00, 38100000000.00, NOW() - INTERVAL '4 hours'),
                                                                    (1, 66890.00, 37900000000.00, NOW() - INTERVAL '3 hours'),
                                                                    (1, 67210.00, 38200000000.00, NOW() - INTERVAL '2 hours'),
                                                                    (1, 67420.00, 38000000000.00, NOW() - INTERVAL '1 hour'),
                                                                    -- Ethereum
                                                                    (2, 3460.00,  18100000000.00, NOW() - INTERVAL '6 hours'),
                                                                    (2, 3490.00,  18300000000.00, NOW() - INTERVAL '4 hours'),
                                                                    (2, 3510.00,  18400000000.00, NOW() - INTERVAL '2 hours'),
                                                                    (2, 3521.50,  18500000000.00, NOW() - INTERVAL '1 hour'),
                                                                    -- Solana
                                                                    (5, 172.30,    4600000000.00, NOW() - INTERVAL '6 hours'),
                                                                    (5, 174.80,    4700000000.00, NOW() - INTERVAL '4 hours'),
                                                                    (5, 177.20,    4750000000.00, NOW() - INTERVAL '2 hours'),
                                                                    (5, 178.90,    4800000000.00, NOW() - INTERVAL '1 hour'),
                                                                    -- BNB
                                                                    (4, 592.10,    2050000000.00, NOW() - INTERVAL '6 hours'),
                                                                    (4, 595.40,    2080000000.00, NOW() - INTERVAL '3 hours'),
                                                                    (4, 598.20,    2100000000.00, NOW() - INTERVAL '1 hour');