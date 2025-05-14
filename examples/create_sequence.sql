-- 20250418 prompt: generate code to create an oracle sequence starting at one incremeting by 1, sequence should be in the baninst1 schema and named seq_ansi834
-- output:
CREATE SEQUENCE baninst1.seq_ansi834
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- follow-up prompt: is there a way to take the above sequence, and have it start over once it reaches 999999999?
  CREATE SEQUENCE baninst1.seq_ansi834
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 999999999
    CYCLE
    NOCACHE;

-- follow-up prompt: how would I get the current and next values from the z_ansi834_seq created above?
    SELECT seq_ansi834.CURRVAL AS current_value,
        seq_ansi834.NEXTVAL AS next_value
    FROM DUAL;
