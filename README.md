# Patient Visits Analysis (MySQL + Tableau)

SQL analysis of outpatient visit data: who the patients are, which diagnoses and procedures are most common, and which patients use care most often. Results are presented in a Tableau dashboard.

**Tools:** MySQL 8.0 (CTEs, window functions, aggregation), Tableau Public

**Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/mohammed.farhan.sheikh/viz/PortfolioProject_17915467733200/Dashboard1)

![Dashboard](images/dashboard.png)

## Dataset

`patient_visits` has 200 rows, 42 patients, 55 distinct ICD-10 codes and 129 distinct CPT codes.

| Column | Type | Description |
|---|---|---|
| id | INT (auto) | Surrogate primary key |
| visit_id | VARCHAR(10) | Visit identifier (not unique, see data quality) |
| patient_id | VARCHAR(10) | Patient identifier |
| visit_date | DATE | Date of visit |
| date_of_birth | DATE | Patient date of birth |
| patient_age | TINYINT | Age at time of visit |
| patient_sex | ENUM('Male','Female') | Sex |
| icd_code | VARCHAR(10) | Diagnosis code (ICD-10) |
| cpt_code | CHAR(5) | Procedure code (CPT) |

> **Data note:** This is a synthetic dataset. It contains no real patient information.

## Data quality notes

Checked before analysis:

- **`visit_id` is not unique.** 42 distinct values across 200 rows, with some IDs repeated up to 7 times with different details. A surrogate `id` is the primary key.
- **Conflicting patient details.** 20 of 42 patients have more than one date of birth and more than one sex across their rows.
- **Age mismatches.** 68 rows had `patient_age` inconsistent with date of birth and visit date. Age was recalculated as age at the visit date.
- **CPT codes** are stored as text (5 characters) so leading zeros are preserved.
- **Dates** were converted from `M/D/YYYY` to `YYYY-MM-DD` for MySQL.
- Some rows look like repeated test entries (for example, one patient with 9 rows on the same date and the same diagnosis).

**Counting rule:** each row is treated as one visit/diagnosis event, using the age and sex recorded on that row. A patient can therefore appear in more than one age band or sex group.

## Analysis and findings

### 1. Patient population overview (`sql/02_age_bands.sql`)

| Age band | Visits | Distinct patients |
|---|---|---|
| 0-17 | 1 | 1 |
| 18-39 | 68 | 26 |
| 40-64 | 102 | 31 |
| 65+ | 29 | 16 |

Half of all visits (102 of 200) come from patients aged 40-64. Distinct patients add up to more than 42 because a patient is counted in each band where they have a visit.

### 2. Diagnosis analysis (`sql/03_diagnosis_analysis.sql`)

Top diagnoses: I10 (19), J45.909 (11), N39.0 (11), E11.9 (10), M54.5 (10), E78.5 (10), F32.9 (9), K21.9 (9), I25.10 (9), G43.909 (8).

- I10 (hypertension) is the most common diagnosis and is concentrated in patients 65+ (10 of 19).
- J45.909, E11.9 and E78.5 are concentrated in the 40-64 group.
- N39.0 and E11.9 skew toward female patients; K21.9 skews toward male.

### 3. Visit utilization (`sql/04_visit_utilization.sql`)

- Average visits (rows) per patient: **4.76**
- High utilizers (4+ visits): **20 patients**, saved in the `high_utilizers` table.
- The distribution is lopsided: 22 patients have 1 event and 20 have 8 or 9. This partly reflects repeated entries in the data.

### 4. Procedure (CPT) insights (`sql/05_cpt_ranking.sql`)

Most frequent: 99213 (7), 99214 (6), 99204 (6), 99215 (4). 96 of 129 CPT codes appear only once. Several sequential codes (12345, 23456, ...) appear to be placeholder values.

## Repository structure

```
patient-visits-sql/
├── README.md
├── data/
│   ├── patient_visits_clean.csv      # cleaned data to load into MySQL
│   └── tableau_tables/               # result tables used for the dashboard
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_age_bands.sql
│   ├── 03_diagnosis_analysis.sql
│   ├── 04_visit_utilization.sql
│   └── 05_cpt_ranking.sql
└── images/
    ├── dashboard.png
    └── age_band_chart.png
```

## How to run

1. Run `sql/01_create_table.sql` to create the database and table.
2. Load `data/patient_visits_clean.csv` into `patient_visits` (MySQL Workbench: Table Data Import Wizard, existing table). Avoid opening the CSV in Excel first, because Excel can change the date format.
3. Check `SELECT COUNT(*) FROM patient_visits;` returns 200.
4. Run the remaining scripts in order.
