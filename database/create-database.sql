CREATE DATABASE IF NOT EXISTS projeto_pi;
USE projeto_pi;

CREATE TABLE acumul_acelerate(
    acumul BIGINT,
    iterador INT,
    time_spent DECIMAL(11, 9),
    memory_usage DECIMAL(10,5)
);
