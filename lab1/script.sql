create table result
(
    id   int unique primary key,
    name text unique not null
);




create table feeling
(
    id   int unique primary key,
    name text unique not null
);
create table state
(
    id    int unique primary key,
    state text unique not null
);
create table objectConsistOf
(
    id          int unique primary key,
    description text unique not null
);
create table weather
(
    id          int unique primary key,
    name        text unique not null,
    description text        not null
);
create table object_visibility
(
    id         int unique primary key,
    weather    text unique not null,
    visibility text unique not null,
    FOREIGN KEY (weather) references weather (name)
);
create table surrounding_object
(
    id         int unique primary key,
    name       text not null,
    stateid    text  not null,
    consistid  text  not null,
    visibilityid text not null,
    FOREIGN KEY (stateid) references state (state),
    FOREIGN KEY (consistid) references objectConsistOf (description),
    FOREIGN KEY (visibilityid) references object_visibility (visibility)
);
create table logical_result
(
    id       int unique primary key,
    location int        not null,
    feeling  int        not null,
    result   int unique not null,
    foreign key (location) references surrounding_object (id),
    FOREIGN KEY (feeling) references feeling (id),
    FOREIGN KEY (result) references result (id)
);
create table human
(
    id      int unique primary key,
    name    text not null,
    stateid text  not null,
    FOREIGN KEY (stateid) references state (state)
);
create table human_result
(
    id       int unique primary key,
    humanId  int not null,
    resultId int not null,
    FOREIGN KEY (humanId) references human (id),
    FOREIGN KEY (resultId) references logical_result (result)
);



insert into objectConsistOf(id, description)
values (1, 'Гравий');
insert into objectConsistOf(id, description)
values (2, 'Лампочка');
insert into objectConsistOf(id, description)
values (3, 'Дерево');



insert into weather(id, name, description)
values (1, 'Туман', 'Состоит из воды');

insert into object_visibility(id, weather, visibility)
values (1, 'Туман', 'Еле проглядывается');


insert into state (id, state)
values (1, 'Проглядывались');
insert into state (id, state)
values (2, 'Хочет попасть в дверь');
insert into state (id, state)
values (3, 'Открылась');
insert into state (id, state)
values (4, 'Качались');
insert into state (id, state)
values (5, 'Содержит в себе дверь, которая ведёт на лестничную площадку');
insert into state (id, state)
values (6, 'Закрыта');
insert into state (id, state)
values (7, 'Радостное воодушевление');



insert into surrounding_object (id, name, stateid, consistid, visibilityid)
values (1, 'Крыша', 5, 1, 'Еле проглядывается');
insert into surrounding_object (id, name, stateid, consistid, visibilityid)
values (2, 'Стеклянные пирамиды световых фонарей', 1, 2, 'Еле проглядывается');
insert into surrounding_object (id, name, stateid, consistid, visibilityid)
values (3, 'Дверь', 6, 3, 'Еле проглядывается');
insert into surrounding_object (id, name, stateid, consistid, visibilityid)
    values (4, 'Ветки', 4, 3, 'Еле проглядывается');

insert into result (id, name)
values (1, 'Ничего не произошло');
insert into result (id, name)
values (2, 'Поцарапала лицо');

insert into feeling (id, name)
values (1, 'Напрягла все силы, ее тело взметнулось в воздух и покатилось по гравию');

insert into logical_result (id, location, feeling, result)
values (1, 3, 1, 2);
insert into logical_result (id, location, feeling, result)
values (2, 3, 1, 1);

insert into human (id, name, stateid)
values (1, 'Элли', 7);
insert into human (id, name, stateid)
values (2, 'Татошка', 7);


insert into human_result (id, humanId, resultId)
values (1, 1, 2);
insert into human_result (id, humanId, resultId)
values (2, 2, 1);
insert into human_result (id, humanId, resultId)
values (3, 2, 1);
insert into human_result (id, humanId, resultId)
values (4, 2, 1);



------------------ДОП---------------------------

WITH hr AS (SELECT humanId, COUNT(*) AS cnt
            FROM human_result
            GROUP BY humanId),
     hrf AS (SELECT humanId, cnt
             FROM hr
             WHERE cnt > 2
             GROUP BY humanId, cnt),
     h AS (SELECT id, name
           FROM human
           GROUP BY id)

SELECT id, name
FROM h
WHERE id IN (SELECT humanId FROM hrf)
;