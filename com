create table genre(id serial primary key,
title varchar(30));
insert into genre (title)
values
('Rap'),('Rock');

create table performers(id serial primary key,
name varchar(20));

create table album(id serial primary key,
title varchar(20),
year_of_release integer CHECK(year_of_release > 1990 AND year_of_release  < 2024));

create table track(id serial primary key,
title varchar(15),
duration integer,
album_id integer references album(id));

create table collection(id serial primary key,
title varchar(15),
year_of_release integer CHECK(year_of_release > 1990 AND year_of_release  < 2024));

create table genre_performers(id serial primary key,
genre_id integer references genre(id),
performers_id integer references performers(id));

create table performers_album(id serial primary key,
album_id integer references album(id),
performers_id integer references performers(id));

create table track_collection(id serial primary key,
track_id integer references track(id),
collection_id integer references collection(id));
