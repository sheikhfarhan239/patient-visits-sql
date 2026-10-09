-- 04_visit_utilization.sql
-- Task 3: Visit utilization.
-- A "visit" here is one diagnosis event (one row).

USE clinic;

-- 3a. Total diagnosis events per patient
SELECT patient_id,
       COUNT(*) AS total_events
FROM patient_visits
GROUP BY patient_id
ORDER BY total_events DESC, patient_id;

-- 3b. Average visits per patient
SELECT ROUND(AVG(total_events), 2) AS avg_visits_per_patient
FROM (
    SELECT patient_id, COUNT(*) AS total_events
    FROM patient_visits
    GROUP BY patient_id
) AS per_patient;

-- 3c. High utilizers (4+ visits), saved as a table for the dashboard
DROP TABLE IF EXISTS high_utilizers;

CREATE TABLE high_utilizers AS
SELECT patient_id,
       COUNT(*)                 AS total_events,
       COUNT(DISTINCT icd_code) AS distinct_diagnoses,
       MIN(visit_date)          AS first_visit,
       MAX(visit_date)          AS last_visit
FROM patient_visits
GROUP BY patient_id
HAVING COUNT(*) >= 4
ORDER BY total_events DESC, patient_id;

SELECT * FROM high_utilizers;
