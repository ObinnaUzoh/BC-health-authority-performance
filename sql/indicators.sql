USE bc_health;

CREATE TABLE health_indicators (
    region VARCHAR(100),
    indicator VARCHAR(255),
    measure_type VARCHAR(100),
    indicator_segment VARCHAR(100),
    segment_value VARCHAR(100),
    time_scale VARCHAR(50),
    time_frame VARCHAR(50),
    metric VARCHAR(100),
    main_metric VARCHAR(50),
    metric_value VARCHAR(50),
    unit_of_measure VARCHAR(100),
    confidence_interval_lower_limit VARCHAR(100) NULL,
    confidence_interval_upper_limit VARCHAR(100) NULL,
    refresh_date DATE
);

-- rather than using import wizard, the csv file can be first uploaded to 
-- 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads' (copy paste into the folder) 
-- and then loaded here 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/regional_health_indicators.csv'
INTO TABLE health_indicators
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- duplicate so we leave the original data intact
CREATE TABLE health_indicators_refine AS
SELECT *
FROM health_indicators;


SELECT *
FROM health_indicators_refine;

-- for this table, the metric_value column are numbers, clean up to get rid of the commas

-- check that there are rows that are not numbers using regex
SELECT DISTINCT metric_value
FROM health_indicators_refine
WHERE metric_value NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

-- replace , between numbers with empty spaces
SET SQL_SAFE_UPDATES = 0;
UPDATE health_indicators_refine
SET metric_value = REPLACE(metric_value, ',', '');
SET SQL_SAFE_UPDATES = 1;

-- modify the column to be a DECIMAL
ALTER TABLE health_indicators_refine
MODIFY COLUMN metric_value DECIMAL(15,4);

-- inspect, zero rows will be returned
SELECT metric_value
FROM health_indicators_refine
WHERE metric_value LIKE '%,%';


DESCRIBE health_indicators_refine;

SELECT *
FROM health_indicators_refine
;

-- 'health_indicators_refine' table will be needed by PowerBI


