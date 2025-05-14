/* AI Prompts and generated output */
-- 20250304 Claude 3.5 Sonnet
-- PROMPT: create a query that shows gaps in spriden_id sequences for ids that start with an A followed by 8 digits. Essencially I'm trying to view unused IDs that can be used for a manual creation of a record. Also, it would be helpful if the available IDs were listed in descending order.
-- OUTPUT:
  WITH sequence_numbers AS (
    SELECT 'A' || LPAD(LEVEL, 8, '0') AS id_sequence
    FROM dual 
    CONNECT BY LEVEL <= 99999999
  ),
  used_ids AS (
    SELECT spriden_id
    FROM spriden 
    WHERE spriden_id LIKE 'A%'
    AND LENGTH(spriden_id) = 9
    AND REGEXP_LIKE(spriden_id, '^A[0-9]{8}$')
  )
  SELECT id_sequence AS available_id
  FROM sequence_numbers
  WHERE id_sequence NOT IN (SELECT spriden_id FROM used_ids)
  ORDER BY id_sequence DESC;

-- FOLLOW-UP PROMPT: I'm getting an error, ORA-30009: Not enough memory for CONNECT BY operation. Could you rewrite this so that it only shows ids missing between the first and last used ids?
  WITH used_ids AS (
      SELECT spriden_id,
             TO_NUMBER(SUBSTR(spriden_id, 2)) AS id_num,
             LEAD(TO_NUMBER(SUBSTR(spriden_id, 2))) OVER (ORDER BY spriden_id) AS next_id
      FROM spriden 
      WHERE spriden_id LIKE 'A%'
      AND LENGTH(spriden_id) = 9
      AND REGEXP_LIKE(spriden_id, '^A[0-9]{8}$')
  )
  SELECT 'A' || LPAD(id_num + 1, 8, '0') AS available_id
  FROM used_ids
  WHERE next_id - id_num > 1
      AND ROWNUM <= 1000
  ORDER BY available_id DESC;
