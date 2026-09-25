USE bc_health;
   
   -- A created table to map cities that are slightly different (since a mere JOIN will not match this
   -- cities properly. 
   
   
-- the cities in the 'population_city' are true data coming from the pop_municipal_clean table
-- the cities in the 'hospital_city' are from 'hospitals_clean' table
-- Note: The respective mappings of 'Fort Nelson', 'Saanichton', 'Saanichton', 'Saanichton'  with the population_cities
-- is assumed. 

  
CREATE TABLE city_mapping (
    hospital_city VARCHAR(100) NOT NULL,
    population_city VARCHAR(100) NOT NULL,
    PRIMARY KEY (hospital_city, population_city)
);

INSERT INTO city_mapping (hospital_city, population_city) VALUES
('Langley', 'Langley, City of'),
('Langley', 'Langley, District Municipality'),
('North Vancouver', 'North Vancouver, City of'),
('North Vancouver', 'North Vancouver, District Municipality'),
('Fort St John', 'Fort St. John'),
('Fort Nelson', 'Northern Rockies Regional Municipality'),
('Saanichton', 'Central Saanich'),
('Saanichton', 'North Saanich'),
('Saanichton', 'Sidney');

SELECT *
FROM city_mapping
;
   


