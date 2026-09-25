CREATE DATABASE bc_health;
USE bc_health;

SHOW TABLES;

-- Import 'hospitals_bc_raw.csv data' file contained in '\data' folder and create table using the IMPORT WIZARD
-- And then inpspect

SELECT * 
FROM hospitals_bc_raw
LIMIT 20;

SELECT COUNT(*)
FROM hospitals_bc_raw;


-- Create new table 

CREATE TABLE hospitals_clean (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT,
    hospital_name VARCHAR(200),
    city VARCHAR(100),
    health_authority VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);


SHOW CREATE TABLE hospitals_clean;

INSERT INTO hospitals_clean(hospital_id, hospital_name, city, health_authority, latitude, longitude)
SELECT SV_REFERENCE, SV_NAME, CITY, RG_NAME, LATITUDE, LONGITUDE FROM hospitals_bc_raw;

SELECT * 
FROM hospitals_clean
LIMIT 20;

SELECT DISTINCT health_authority FROM hospitals_clean;



SELECT COUNT(*)
FROM hospitals_clean;

SELECT COUNT(*) AS rows_to_delete
FROM hospitals_clean
WHERE health_authority IN (
	'BC Children''s Hospital',
    'BC Women''s Hospital & Health Centre', 
    'Providence Health Care Society'
    );
    
-- Disable safe update to allow DELETE
SET SQL_SAFE_UPDATES = 0; 
DELETE FROM hospitals_clean 
WHERE health_authority IN (
	'BC Children''s Hospital',
    'BC Women''s Hospital & Health Centre', 
    'Providence Health Care Society'
);
-- Enable safe update
SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM hospitals_clean
;

-- The following adds population data from 'pop_municipal_clean' table to 
-- the 'hospitals_clean' table by the city column.
-- There is a lookup table "city_mapping" to ensure that cities spelt differently are properly taking care of



-- First step is to add an empty population column
ALTER TABLE hospitals_clean
ADD COLUMN population INT;

-- 
SET SQL_SAFE_UPDATES = 0; 
UPDATE hospitals_clean h
JOIN pop_municipal_clean p
	ON h.city = p.city
	AND h.health_authority = p.health_authority
SET h.population = p.population
WHERE p.year = 2024;
SET SQL_SAFE_UPDATES = 1; 


-- See that some cities are NULL
SELECT city
FROM hospitals_clean
WHERE population IS NULL
ORDER BY city
;


-- Some cities did not match because they are spelt differently in 'pop_municipal_clean' table.
-- This is handles in the 'city_mapping.sql' query.
-- Although some cities like Bella Bella, Bella Coola, Whitehosrse are actually not present
-- in the 'pop_municipal_clean' table, i.e, they have no population record. 

-- See whats in the matching city
SELECT *
FROM city_mapping
;

-- See the population table that will be matched
SELECT
	cm.hospital_city,
    cm.population_city,
    p.population
FROM city_mapping cm
JOIN pop_municipal_clean p
    ON cm.population_city = p.city
WHERE p.year = 2024;

-- Sum the population of Langley, District and Langley North Vancouver (since they both share same hospital(s))
-- Also do the same for North Vancouver District and North Vancouver City

CREATE TEMPORARY TABLE mapped_population AS 
SELECT
    cm.hospital_city,
    SUM(p.population) AS total_population
FROM city_mapping cm
JOIN pop_municipal_clean p
    ON cm.population_city = p.city
WHERE p.year = 2024
GROUP BY cm.hospital_city;

-- Inspect
SELECT *
FROM mapped_population;

-- Now update 'hospitals_clean' with the mapped population
SET SQL_SAFE_UPDATES = 0; 
UPDATE hospitals_clean h
JOIN mapped_population mp
	ON h.city = mp.hospital_city
SET h.population = mp.total_population;
SET SQL_SAFE_UPDATES = 1; 

-- Inspect
SELECT city
FROM hospitals_clean
WHERE population is NULL;

-- From the output of the query above, notice that these 6 cities were not in the raw population data:
-- Sechelt, Bella Bella, Bella Coola, Salt Spring Island, Fort St James, and Whitehorse.
-- This is because there is no official data for their population

SELECT *
FROM hospitals_clean
;

CREATE TABLE hospitals_refine AS
SELECT *
FROM hospitals_clean
;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM hospitals_refine
WHERE population is NULL;
SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM hospitals_refine
;

SELECT *
FROM hospitals_clean
;

CREATE TABLE hospital_backup AS
SELECT *
FROM hospitals_clean;


-- I just realized that the hospitals_clean table has duplicated population entry for some cities. 
-- I will create a new table called city_population with distinct citites and their population (this will be useful in PowerBI)
-- I will delete the population column in hospitals_refine
-- So, hospitals info will be in 'hospitals_refine' table, and the population info will be in 'city_population'

ALTER TABLE hospitals_refine
DROP COLUMN population;



CREATE TABLE city_population AS
SELECT 
	city,
    health_authority,
    MAX(population) AS population
FROM hospitals_clean
WHERE population IS NOT NULL
GROUP BY city, health_authority;

SELECT *
FROM city_population
;


SELECT SUM(population)
FROM city_population
;


-- So, hospitals info will be in 'hospitals_refine' table, 
-- the population info will be in 'city_population'
-- with 'health-indicators-refine'
-- These tables will be used in PowerBI

