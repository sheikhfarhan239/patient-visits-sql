-- 05_cpt_ranking.sql
-- Task 4: Procedure (CPT) insights.
-- RANK() gives tied codes the same rank, so no tied code is dropped arbitrarily.

USE clinic;

SELECT cpt_code,
       COUNT(*)                   AS procedure_count,
       COUNT(DISTINCT patient_id) AS distinct_patients,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS frequency_rank
FROM patient_visits
GROUP BY cpt_code
ORDER BY frequency_rank, cpt_code;
