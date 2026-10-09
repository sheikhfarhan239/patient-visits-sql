-- 02_age_bands.sql
-- Task 1: Patient population overview.

USE clinic;

-- 1a. Calculate age at visit from date of birth and check it against the stored age.
--     Expect 0 mismatches in the cleaned data.
SELECT COUNT(*) AS age_mismatches
FROM patient_visits
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, visit_date) <> patient_age;

-- 1b. Group into age bands and count visits and distinct patients per band.
--     A patient is counted in each band in which they have a visit.
WITH agewise AS (
    SELECT patient_id,
           CASE
               WHEN patient_age <= 17 THEN '0-17'
               WHEN patient_age BETWEEN 18 AND 39 THEN '18-39'
               WHEN patient_age BETWEEN 40 AND 64 THEN '40-64'
               WHEN patient_age >= 65 THEN '65+'
           END AS age_band
    FROM patient_visits
)
SELECT age_band,
       COUNT(*)                   AS number_of_visits,
       COUNT(DISTINCT patient_id) AS number_of_patients
FROM agewise
GROUP BY age_band
ORDER BY MIN(CASE age_band WHEN '0-17'  THEN 1
                           WHEN '18-39' THEN 2
                           WHEN '40-64' THEN 3
                           ELSE 4 END);
