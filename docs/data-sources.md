## 🗂️ Data Sources
The project uses publicly available data from several Canadian and British Columbia sources.

### 1. Hospital Data
**[Government of Canada Open Data — Hospitals in British Columbia](https://open.canada.ca/data/en/dataset/383eaf98-afd7-436a-9556-67ecf14f64a7)** 

Contains hospital/service-location information including hospital names, cities, health organizations, coordinates, and other attributes.

### 2. Population Data
**[Government of British Columbia — Population Estimates](https://www2.gov.bc.ca/gov/content/data/statistics/people-population-community/population/population-estimates)**

Municipal population for year 2024. 

### 3. Health-System Indicators
**[Canadian Institute for Health Information (CIHI)](https://www.cihi.ca/en/access-data-and-reports/indicator-library/download-indicator-data)**

Selected indicators include;
* Adult Canadians With a Regular Health Provider
* All Patients Readmitted to Hospital
* Cost of a Standard Hospital Stay
* Family Medicine Physicians per 100,000 Population
* High Users of Hospital Beds per 100 Population

### 4. Health Authority Mapping
**[Doctors of BC](https://www.doctorsofbc.ca/about-us/who-we-are/governance/representative-assembly-districts-health-authorities)**

Used as a reference for mapping municipalities to regional health authorities in the sql script: `city_health_authority_join`

---
