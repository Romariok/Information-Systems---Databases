EXPLAIN ANALYZE
SELECT  "Н_ЛЮДИ"."ИД", "Н_ОБУЧЕНИЯ"."НЗК", "Н_УЧЕНИКИ"."ИД"
FROM "Н_ЛЮДИ"
INNER JOIN "Н_ОБУЧЕНИЯ" ON ("Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД")
INNER JOIN "Н_УЧЕНИКИ" ON ("Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД")
WHERE "Н_ЛЮДИ"."ОТЧЕСТВО" > 'Георгиевич' AND "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" = 163484;


-----------------------------------1-------------------------------------
CREATE CLUSTERED INDEX index_ОТЧЕСТВО ON "Н_ЛЮДИ" USING btree ("ОТЧЕСТВО");

-----------------------------------2-------------------------------------
CREATE INDEX index_ЧЛВК_ИД ON "Н_ОБУЧЕНИЯ" USING btree ("ЧЛВК_ИД");