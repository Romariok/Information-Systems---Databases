--Тригер, что при добавлении нового набора feeling и result в logical_result и этот новый result
--соотноситься с человеком в human_result, то я вывожу название result

CREATE OR REPLACE FUNCTION print_result_name()
RETURNS TRIGGER AS $$
DECLARE
  result_name VARCHAR(255);
  assoc_exists BOOLEAN;
BEGIN
  SELECT COUNT(*) INTO assoc_exists FROM human_result WHERE humanid = NEW.humanid AND resultid = NEW.resultid;

  IF assoc_exists THEN
    RAISE NOTICE 'Association already exists for Human ID: % and Result ID: %', NEW.humanid, NEW.resultid;
  ELSE
    SELECT name INTO result_name FROM result WHERE id = NEW.resultid;
    RAISE NOTICE 'Result Name: %', result_name;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER print_result_name
BEFORE INSERT ON human_result
FOR EACH ROW
EXECUTE FUNCTION print_result_name();
