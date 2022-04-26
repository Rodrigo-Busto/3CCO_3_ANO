CREATE DATABASE IF NOT EXISTS projeto_pi;
USE projeto_pi;

CREATE TABLE autism_screening(
    score INT,
    autism BOOLEAN,
    gender CHAR(1),
    birthday DATE,
    country CHAR(2),
    time_spent DECIMAL(12, 9),
    memory_usage DECIMAL(10,2)
);
