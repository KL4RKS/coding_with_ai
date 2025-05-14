-- 20250324 Claude 3.5 Sonnet
-- PROMPT: prepare a query that will show all hours for phrmtim_id = 'A00000184' on phrmtim as well as perhour. You can use queries in temp_steven_it.sql as a reference.
SELECT phrmtim.*, perhour.*
FROM phrmtim
LEFT JOIN perhour
  ON phrmtim_pidm = perhour_pidm
  AND phrmtim_year = perhour_year
  AND phrmtim_pict_code = perhour_pict_code
  AND phrmtim_payno = perhour_payno
  AND phrmtim_seq_no = perhour_seq_no
WHERE phrmtim_pidm = (SELECT spriden_pidm 
                      FROM spriden 
                      WHERE spriden_id = 'A00000184'
                      AND spriden_change_ind IS NULL)
ORDER BY phrmtim_year DESC, phrmtim_pict_code, phrmtim_payno, phrmtim_seq_no
;

-- Follow-up prompt: please make those two separate queries. and limit the  timeframe on perhour to last year.
-- Query 1: PHRMTIM data
SELECT phrmtim.*
FROM phrmtim
WHERE phrmtim_pidm = (SELECT spriden_pidm 
            FROM spriden 
            WHERE spriden_id = 'A00000184'
            AND spriden_change_ind IS NULL)
ORDER BY phrmtim_year DESC, phrmtim_pict_code, phrmtim_payno, phrmtim_seq_no;

-- Query 2: PERHOUR data for last year
SELECT perhour.*
FROM perhour
WHERE perhour_pidm = (SELECT spriden_pidm 
            FROM spriden 
            WHERE spriden_id = 'A00000184'
            AND spriden_change_ind IS NULL)
AND perhour_year = EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY perhour_year DESC, perhour_pict_code, perhour_payno, perhour_seq_no;

-- Manually adjusted:
-- Query 1: PHRMTIM data
SELECT phrmtim.*
FROM phrmtim
WHERE phrmtim_id = 'A00000184' -- removed unnecessary correlated subquery to spriden and fixed phrmtim column name
ORDER BY phrmtim_year DESC, phrmtim_pict_code, phrmtim_payno;

-- Query 2: PERHOUR data for last year
-- PROMPT: in the following query, please join perjobs to perhour for payroll year, pict_code, and payno as well as to filter for last year's data.
SELECT perhour.*, perjobs.*
FROM perhour
JOIN perjobs
  ON perhour_pidm = perjobs_pidm
  AND perhour_year = perjobs_year 
  AND perhour_pict_code = perjobs_pict_code
  AND perhour_payno = perjobs_payno
WHERE perhour_pidm = (SELECT spriden_pidm 
            FROM spriden 
            WHERE spriden_id = 'A00000184'
            AND spriden_change_ind IS NULL)
AND perhour_year = EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY perhour_year DESC, perhour_pict_code, perhour_payno
;
-- Folluw-up promt: perhour does not have a year, pict_code, and payno columns. Those are on perjobs, which joins on perhour_jobs_seqno and perjobs_seqno. Please adjust the query accordingly.
SELECT perhour.*, perjobs.*
FROM perhour
JOIN perjobs
  ON perhour_jobs_seqno = perjobs_seqno
WHERE perhour_pidm = (SELECT spriden_pidm 
            FROM spriden 
            WHERE spriden_id = 'A00000184'
            AND spriden_change_ind IS NULL)
AND perjobs_year = EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY perjobs_year DESC, perjobs_pict_code, perjobs_payno
;

-- manual rewrite
SELECT perhour.*, perjobs.*
FROM perhour
JOIN perjobs
  ON perhour_jobs_seqno = perjobs_seqno
WHERE perjobs_pidm = (SELECT spriden_pidm 
            FROM spriden 
            WHERE spriden_id = 'A00000184'
            AND spriden_change_ind IS NULL)
AND perjobs_year = EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY perjobs_year DESC, perjobs_pict_code, perjobs_payno
;

SELECT phrhour.*
FROM phrhour
WHERE phrhour_pidm = (SELECT spriden_pidm 
            FROM spriden 
            WHERE spriden_id = 'A00000184'
            AND spriden_change_ind IS NULL)
AND phrhour_year = EXTRACT(YEAR FROM SYSDATE) - 1
;

SELECT phrearn.*
FROM phrearn
WHERE phrearn_pidm = 1000115
AND phrearn_year = EXTRACT(YEAR FROM SYSDATE) - 1
order by phrearn_year desc, phrearn_pict_code, phrearn_payno desc, phrearn_earn_code;
;
