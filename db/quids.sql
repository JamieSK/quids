DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS merchants CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS transaction_categories CASCADE;
DROP TABLE IF EXISTS budgets CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  picture VARCHAR(255)
);

CREATE TABLE budgets (
  id SERIAL4 PRIMARY KEY,
  user_id INT4 REFERENCES users(id),
  start_date DATE,
  end_date DATE,
  cash_spent INT4,
  cash_max INT4
);

CREATE TABLE categories (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE merchants (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  category_id INT4 REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE transactions (
  id SERIAL4 PRIMARY KEY,
  description VARCHAR(500),
  merchant_id INT4 REFERENCES merchants(id) ON DELETE CASCADE,
  user_id INT4 REFERENCES users(id) ON DELETE CASCADE,
  budget_id INT4 REFERENCES budgets(id) ON DELETE CASCADE,
  amount INT4,
  transaction_time TIMESTAMP
);

CREATE TABLE transaction_categories (
  id SERIAL4 PRIMARY KEY,
  transaction_id INT4 REFERENCES transactions(id) ON DELETE CASCADE,
  category_id INT4 REFERENCES categories(id) ON DELETE CASCADE
);
