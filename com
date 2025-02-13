create table genre(id serial primary key,
title varchar(30));


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


select ntitle, duration from track WHERE duration = (select max(duration) from track);
select title from track WHERE duration >= 210;
select title from collection WHERE year_of_release >= 2018 and year_of_release < 2021;
select name from performers WHERE name NOT LIKE '%% %%';
select title from track WHERE title iLIKE '%my%';

select genre_id, count(performers_id) from genre_performers
group by genre_id
order by count(performers_id) desc;

select count(track.title) from album
join track on track.album_id = album.id
where album.year_of_release between 2019 and 2020;


SELECT album.title, avg(track.duration) FROM album
JOIN track ON track.album_id = album.id 
GROUP BY album.title
ORDER BY avg(track.duration);


select DISTINCT performers.name from performers
where performers.name NOT IN
(select DISTINCT performers.name from performers
join performers_album on performers.id = performers_album.performers_id
join album on performers_album.album_id = album.id
where album.year_of_release = 2020)
order by performers.name;



SELECT collection.title , performers.name FROM collection
LEFT JOIN track_collection ON collection.id = track_collection.collection_id 
LEFT JOIN track ON track_collection.track_id = track.id 
LEFT JOIN album ON track.album_id = album.id 
LEFT JOIN performers_album ON album.id = performers_album.album_id 
LEFT JOIN performers ON performers_album.performers_id = performers.id
WHERE performers.id = 2
GROUP BY performers.name, collection.title;



