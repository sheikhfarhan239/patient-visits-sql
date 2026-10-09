-- 03_diagnosis_analysis.sql
-- Task 2: Diagnosis analysis.
-- patient_visits already holds patient and diagnosis in one row, so no join is needed.

USE clinic;

-- 2a. How many times each ICD code appears (all codes)
SELECT icd_code,
       COUNT(*)                   AS times_appeared,
       COUNT(DISTINCT patient_id) AS distinct_patients
FROM patient_visits
GROUP BY icd_code
ORDER BY times_appeared DESC, icd_code;

-- 2b. Top 10 diagnoses overall
SELECT icd_code,
       COUNT(*) AS diagnosis_count
FROM patient_visits
GROUP BY icd_code
ORDER BY diagnosis_count DESC, icd_code
LIMIT 10;

-- 2c. Top 10 diagnoses by age band
WITH top10 AS (
    SELECT icd_code
    FROM patient_visits
    GROUP BY icd_code
    ORDER BY COUNT(*) DESC, icd_code
    LIMIT 10
),
banded AS (
    SELECT icd_code,
           CASE
               WHEN patient_age <= 17 THEN '0-17'
               WHEN patient_age BETWEEN 18 AND 39 THEN '18-39'
               WHEN patient_age BETWEEN 40 AND 64 THEN '40-64'
               ELSE '65+'
           END AS age_band
    FROM patient_visits
    WHERE icd_code IN (SELECT icd_code FROM top10)
)
SELECT icd_code, age_band, COUNT(*) AS diagnosis_count
FROM banded
GROUP BY icd_code, age_band
ORDER BY icd_code, age_band;

-- 2d. Top 10 diagnoses by sex
WITH top10 AS (
    SELECT icd_code
    FROM patient_visits
    GROUP BY icd_code
    ORDER BY COUNT(*) DESC, icd_code
    LIMIT 10
)
SELECT icd_code, patient_sex, COUNT(*) AS diagnosis_count
FROM patient_visits
WHERE icd_code IN (SELECT icd_code FROM top10)
GROUP BY icd_code, patient_sex
ORDER BY icd_code, patient_sex;
