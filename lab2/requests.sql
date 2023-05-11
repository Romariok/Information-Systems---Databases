-----------------------1---------------------

SELECT "Н_ЛЮДИ"."ИМЯ", "УЧГОД"
FROM "Н_ЛЮДИ"
         LEFT JOIN "Н_СЕССИЯ" ON "Н_ЛЮДИ"."ИМЯ" < 'Ярослав' AND "Н_СЕССИЯ"."ЧЛВК_ИД" < 100622;
----------------------2------------------------
SELECT "ИМЯ", "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД", "НАЧАЛО"
FROM "Н_ЛЮДИ"
         INNER JOIN "Н_ОБУЧЕНИЯ" ON "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" = 105590
         INNER JOIN "Н_УЧЕНИКИ" ON "ГРУППА" = '4100' AND "Н_ОБУЧЕНИЯ"
WHERE "Н_ЛЮДИ"."ИМЯ" > 'Александр';


------------------------3------------------
SELECT count("ИМЯ")
FROM "Н_ЛЮДИ"
WHERE "ИНН" IS NULL
  AND "ИД" IN (SELECT "ЧЛВК_ИД"
               FROM "Н_УЧЕНИКИ"
               WHERE "Н_УЧЕНИКИ"."ГРУППА" = '3102');

-----------------------4--------------------
SELECT DISTINCT "Н_УЧЕНИКИ"."ГРУППА"
FROM "Н_УЧЕНИКИ"
WHERE "ПЛАН_ИД" IN (SELECT "ИД"
                    FROM "Н_ПЛАНЫ"
                    WHERE "ОТД_ИД" IN (SELECT "ИД"
                                       FROM "Н_ОТДЕЛЫ"
                                       WHERE "Н_ОТДЕЛЫ"."КОРОТКОЕ_ИМЯ" = 'КТиУ'))
  AND "КОНЕЦ" >= '2011-01-01 00:00:00.000000'
  and "НАЧАЛО" <= '2011-12-31 00:00:00.000000'
GROUP BY "Н_УЧЕНИКИ"."ГРУППА"
HAVING count("Н_УЧЕНИКИ"."ГРУППА") > 10;
-----------------------5------------------------

WITH mm1 AS (SELECT id, avg(int_m) as avg_m1
             FROM (SELECT id, m::integer as int_m
                   FROM (SELECT "ЧЛВК_ИД" as id, "ОЦЕНКА" AS m
                         FROM "Н_ВЕДОМОСТИ"
                         WHERE "ЧЛВК_ИД" IN (SELECT "ЧЛВК_ИД"
                                             FROM "Н_УЧЕНИКИ"
                                             WHERE "ГРУППА" = '4100')
                           AND "ОЦЕНКА" IN ('2', '3', '4', '5')) as m1(id, m)) as m1
             GROUP BY id),
     mm2 AS (SELECT id, avg(int_m) as avg_m2
             FROM (SELECT id, m::integer as int_m
                   FROM (SELECT "ЧЛВК_ИД" as id, "ОЦЕНКА" AS m
                         FROM "Н_ВЕДОМОСТИ"
                         WHERE "ЧЛВК_ИД" IN (SELECT "ЧЛВК_ИД"
                                             FROM "Н_УЧЕНИКИ"
                                             WHERE "ГРУППА" = '3100')
                           AND "ОЦЕНКА" IN ('2', '3', '4', '5')) as m2(id, m)) as m2
             GROUP BY id)

SELECT id, "ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО", avg_m1
FROM mm1
         INNER JOIN "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" IN (SELECT "ЧЛВК_ИД" FROM "Н_УЧЕНИКИ" WHERE "ЧЛВК_ИД" = id)
WHERE EXISTS(SELECT 1 FROM mm2 WHERE avg_m1 = avg_m2);


-------------------------------6----------------------

SELECT "ЧЛВК_ИД", "ГРУППА", "ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО", "П_ПРКОК_ИД"
FROM "Н_УЧЕНИКИ"
         LEFT JOIN "Н_ЛЮДИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
WHERE "НАЧАЛО" = timestamp '2012-09-01'
  AND "ПРИЗНАК" = 'обучен'
  AND "ПЛАН_ИД" IN (SELECT "ИД" FROM "Н_ПЛАНЫ" WHERE "ФО_ИД" = '1' AND "КУРС" = '1');


------------------------------7---------------------------

With average AS (SELECT id, avg(int_m) as avg_m2
                 FROM (SELECT id, CAST(m AS INTEGER) as int_m
                       FROM (SELECT "ЧЛВК_ИД" as id, "ОЦЕНКА" AS m
                             FROM "Н_ВЕДОМОСТИ"
                             WHERE "ЧЛВК_ИД" IN (SELECT "ЧЛВК_ИД"
                                                 FROM "Н_УЧЕНИКИ"
                                                 WHERE "ГРУППА" = '3100')
                               AND "ОЦЕНКА" IN ('2', '3', '4', '5')) as m2(id, m)) as m2
                 GROUP BY id)

SELECT count(id)
FROM average
WHERE avg_m2 >= 3.5
  AND avg_m2 <= 4.5;

-------------------------------------------------------ДОП---------------------------------------------------------------
---Имена людей, у которых в имени первая буква согласная, вторая гласная , и которые имели 2 долга на момент отчисления--

WITH date AS (SELECT "ЧЛВК_ИД" as idd, "КОНЕЦ" as endd, "ДАТА_СМЕРТИ" as dead
              FROM "Н_УЧЕНИКИ"
              INNER JOIN "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
              WHERE "ПРИЗНАК" = 'отчисл'
                AND "СОСТОЯНИЕ" = 'утвержден')
        ,
     marks AS (SELECT "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" as id, "ОЦЕНКА" as m, "ДАТА", endd
               FROM "Н_ВЕДОМОСТИ"
                        LEFT JOIN date ON date.idd = "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
               WHERE "ОЦЕНКА" IN ('незач', '2') AND "СОСТОЯНИЕ" = 'актуальна'
                 AND "ДАТА" <= endd AND dead >= endd),
     count AS (SELECT id, count(m) as kol FROM marks GROUP BY id)

SELECT "ИМЯ"
FROM "Н_ЛЮДИ"
WHERE "ИД" IN (SELECT id FROM count WHERE kol = 2)
  AND "ИМЯ" SIMILAR TO '(В|Й|Ц|К|Н|Г|Ш|Щ|З|Х|Ф|П|Р|Л|Д|Ж|Ч|С|М|Т|Б)(a|у|е|ы|а|о|э|я|и|ю)%';
