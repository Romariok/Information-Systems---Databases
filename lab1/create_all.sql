create table mood
(
    id   int unique primary key,
    mood text unique not null
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
    description text unique not null,
    consistId   int         not null,
    FOREIGN KEY (consistId) references objectConsistOf (id)
);
create table human
(
    id        int unique primary key,
    name      text not null,
    stateId   int  not null,
    consistId int  not null,
    moodId    int  not null,
    FOREIGN KEY (stateId) references state (id),
    FOREIGN KEY (consistId) references objectConsistOf (id),
    FOREIGN KEY (moodId) references mood (id)
);
create table object
(
    id        int unique primary key,
    name      text not null,
    stateId   int  not null,
    consistId int  not null,
    FOREIGN KEY (stateId) references state (id),
    FOREIGN KEY (consistId) references objectConsistOf (id)
);