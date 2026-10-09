-- 01_create_table.sql
-- Creates the database and the patient_visits table.
-- Requires MySQL 8.0+ for the analysis scripts (CTEs, window functions).

CREATE DATABASE IF NOT EXISTS clinic;
USE clinic;

DROP TABLE IF EXISTS patient_visits;

CREATE TABLE patient_visits (
    id            INT AUTO_INCREMENT PRIMARY KEY,   -- surrogate key (visit_id is not unique)
    visit_id      VARCHAR(10)  NOT NULL,
    patient_id    VARCHAR(10)  NOT NULL,
    visit_date    DATE         NOT NULL,
    date_of_birth DATE         NOT NULL,
    patient_age   TINYINT UNSIGNED,                 -- age at visit date
    patient_sex   ENUM('Male','Female') NOT NULL,
    icd_code      VARCHAR(10)  NOT NULL,            -- diagnosis (ICD-10)
    cpt_code      CHAR(5)      NOT NULL,            -- procedure (CPT), stored as text
    INDEX idx_visit   (visit_id),
    INDEX idx_patient (patient_id)
);

-- Load data/patient_visits_clean.csv, either with the Table Data Import Wizard
-- (MySQL Workbench) or with LOAD DATA (adjust the path):
--
-- LOAD DATA LOCAL INFILE '/path/to/patient_visits_clean.csv'
-- INTO TABLE patient_visits
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (visit_id, patient_id, visit_date, date_of_birth, patient_age,
--  patient_sex, icd_code, cpt_code);

-- Sanity check (expect 200 rows)
-- SELECT COUNT(*) FROM patient_visits;
