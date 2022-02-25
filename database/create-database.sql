CREATE DATABASE projeto_pi;
USE projeto_pi;

CREATE TABLE acumul_acelerate(
    acumul BIGINT,
    iterador INT,
    time_spent DECIMAL(11, 9)
);

select * from acumul_acelerate order by time_spent desc;