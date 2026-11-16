CREATE DATABASE IF NOT EXISTS loan_risk;
USE loan_risk;

DROP TABLE IF EXISTS loans_clean;
DROP TABLE IF EXISTS loans_raw;

CREATE TABLE loans_raw (
    person_age                  INT,
    person_income               INT,
    person_home_ownership       VARCHAR(20),
    person_emp_length           VARCHAR(10),
    loan_intent                 VARCHAR(30),
    loan_grade                  CHAR(1),
    loan_amnt                   INT,
    loan_int_rate               VARCHAR(10),
    loan_status                 TINYINT,
    loan_percent_income         DECIMAL(4,2),
    cb_person_default_on_file   CHAR(1),
    cb_person_cred_hist_length  INT
);

SELECT COUNT(*) FROM loans_raw;

SET SQL_SAFE_UPDATES = 0;

UPDATE loans_raw SET person_emp_length = NULL WHERE person_emp_length = '';
UPDATE loans_raw SET loan_int_rate     = NULL WHERE loan_int_rate = '';

ALTER TABLE loans_raw
    MODIFY person_emp_length DECIMAL(5,1) NULL,
    MODIFY loan_int_rate     DECIMAL(5,2) NULL;

CREATE TABLE loans_clean AS
SELECT *,
    CASE WHEN person_income < 25000  THEN '1. <25K'
         WHEN person_income < 50000  THEN '2. 25K-50K'
         WHEN person_income < 75000  THEN '3. 50K-75K'
         WHEN person_income < 100000 THEN '4. 75K-100K'
         ELSE '5. 100K+' END AS income_band,
    CASE WHEN loan_percent_income < 0.10 THEN '1. <10%'
         WHEN loan_percent_income < 0.20 THEN '2. 10-20%'
         WHEN loan_percent_income < 0.30 THEN '3. 20-30%'
         ELSE '4. 30%+' END AS burden_band
FROM (
    SELECT DISTINCT * FROM loans_raw
    WHERE person_age <= 100
      AND (person_emp_length IS NULL OR person_emp_length <= 60)
) t;

SELECT COUNT(*) AS total_loans,
       ROUND(AVG(person_age),1)      AS avg_age,
       ROUND(AVG(person_income),0)   AS avg_income,
       ROUND(AVG(loan_amnt),0)       AS avg_loan,
       ROUND(100*AVG(loan_status),2) AS default_rate_pct
FROM loans_clean;

SELECT person_home_ownership,
       COUNT(*) AS applicants,
       ROUND(AVG(person_income),0)   AS avg_income,
       ROUND(100*AVG(loan_status),2) AS default_rate_pct
FROM loans_clean
GROUP BY person_home_ownership
ORDER BY default_rate_pct DESC;

SELECT CASE loan_status WHEN 1 THEN 'Default' ELSE 'Non-Default' END AS status,
       COUNT(*) AS loans,
       ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM loans_clean
GROUP BY loan_status;

SELECT loan_grade,
       COUNT(*) AS loans,
       ROUND(100*AVG(loan_status),2) AS default_rate_pct
FROM loans_clean
GROUP BY loan_grade
ORDER BY loan_grade;

SELECT income_band,
       COUNT(*) AS applicants,
       ROUND(100*AVG(loan_status),2) AS default_rate_pct
FROM loans_clean
GROUP BY income_band
ORDER BY income_band;

SELECT burden_band,
       COUNT(*) AS loans,
       ROUND(100*AVG(loan_status),2) AS default_rate_pct
FROM loans_clean
GROUP BY burden_band
ORDER BY burden_band;

SELECT * FROM loans_clean;