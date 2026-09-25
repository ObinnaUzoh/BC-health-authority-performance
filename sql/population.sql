USE bc_health;

SHOW TABLES;

SELECT *
FROM pop_municipal_raw;

SELECT COUNT(DISTINCT `Name`) AS unique_count 
FROM pop_municipal_raw;

-- TRUNCATE pop_municipal_clean;

CREATE TABLE pop_municipal_clean (
	id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(200),
    health_authority VARCHAR(200),
    year INT,
    population INT
);

SELECT *
FROM pop_municipal_clean;

INSERT INTO pop_municipal_clean(
	city, 
    year,
	population
)
SELECT 
	`Name`, 
	2024 AS year,
    CAST(REPLACE(`2024`, ',', '') AS UNSIGNED) AS population
 FROM pop_municipal_raw
;

SELECT *
FROM pop_municipal_clean;

SET SQL_SAFE_UPDATES = 0; 
UPDATE pop_municipal_clean p
JOIN health_authority_lookup h
  ON p.city = h.city
SET p.health_authority = h.health_authority;
SET SQL_SAFE_UPDATES = 1;

SELECT SUM(population)
FROM pop_municipal_clean
;

-- confirm whether mapping worked
SELECT *
FROM pop_municipal_clean
WHERE health_authority IS NULL;


SELECT SUM(population)
FROM pop_municipal_clean
;