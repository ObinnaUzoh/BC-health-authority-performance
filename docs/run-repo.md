## 📁 Repository Structure

```text
BC-health-authority-performance/
├── README.md
├── data
│   ├── hospitals_bc_raw.csv
│   ├── pop_municipal_areas.csv
│   └── regional_health_indicators.csv
├── docs
│   ├── data-sources.md
│   └── run-repo.md
├── images
│   ├── dashboard-demo.gif
│   └── health-authority-dashboard.png
├── powerbi
│   ├── BC_Healthcare_dashboard.pbix
│   └── BC_Healthcare_dashboard.pdf
└── sql
    ├── city_health_authority_join.sql
    ├── city_mapping.sql
    ├── hospitals.sql
    ├── indicators.sql
    └── population.sql
```

---

## 🚀 Getting Started

### Prerequisites

To reproduce the project, you need:

* [MySQL Workbench](https://www.mysql.com/products/workbench/)
* [Power BI Desktop](https://powerbi.microsoft.com/desktop/)

The data files are in `data` directory. Learn more about the data sources here: [../docs/data-sources.md](../docs/data-sources.md)
---

### 1. Clone the Repository

```bash
git clone https://github.com/ObinnaUzoh/BC-health-authority-performance.git

cd BC-health-authority-performance
```

---

### 2. Create the MySQL Database

```sql
CREATE DATABASE bc_health;

USE bc_health;
```

---

### 3. Run the SQL Pipeline

The SQL scripts are in the `sql/` directory 

Before running the sql scripts, import the data using the IMPORT WIZARD on MySQL Workbench

A typical workflow is:

```text
city_health_authority_join.sql
        ↓
city_mapping.sql
        ↓
population.sql
        ↓
hospitals.sql
        ↓
indicators.sql
```

> **Note:** Some SQL import statements use local file paths. These paths need to be updated for your local MySQL installation.

---

### 4. Open the Power BI Dashboard

Open:

```text
powerbi/BC_Healthcare_dashboard.pbix
```

in Power BI Desktop.

If you recreate the MySQL database locally, update the Power BI data-source connection and refresh the report.
Power BI will get all tables created in MySQL database, but these tables are necessary to create the dashboard: 'hospitals_refine', 'city_population', 'health-indicators-refine'. 



## 🧮 Data Engineering

### 🗄️ MySQL Data Model

The main analytical tables include:

```text
hospitals_clean
      │
      │ city
      ▼
city_population


health_indicators_refine
```

The city-to-health-authority mapping is stored separately and used to connect municipal population data with the five regional health authorities.

---

A major component of the project was integrating datasets that use different geographic naming conventions.

For example, the hospital dataset may contain:

```text
Langley
```

while the population dataset contains:

```text
Langley, City of
Langley, District Municipality
```

A dedicated city-mapping table was therefore created to resolve these differences before joining the datasets.

The project also separates hospital-level information from city-level population information to avoid repeatedly counting the same population when multiple hospitals exist within a municipality.

---
