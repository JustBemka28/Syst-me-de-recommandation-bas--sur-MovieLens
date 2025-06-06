/*Utiliser des op� erations OLAP (Slice,
 Dice, Drill-down, Roll-up) pour extraire des insights sur les tendances d��evaluation
 et les pr�ef� erences par groupes d�utilisateurs.*/

 -- Operation SLICE

 /*1-Obtenir les �valuations des utilisateurs pour un film sp�cifique "Grumpier Old Men (1995)").*/

 SELECT u.userId, r.rating
FROM ratings_fact r
JOIN table_Utilisateur u ON r.userId = u.userId
JOIN table_movies m ON r.movieId = m.movieId
WHERE m.title = 'Grumpier Old Men (1995)';

/*2-Pour obtenir les �valuations des films de genre "Drama" uniquement :*/

SELECT rf.userId, rf.movieId, rf.rating, rf.timestamp
FROM ratings_fact rf
JOIN table_movies tm ON rf.movieId = tm.movieId
WHERE tm.genres LIKE '%Drama%';


-- Operation Dice 

/*1-Obtenir les �valuations des films du genre "Comedy" pour les utilisateurs avec une �valuation sup�rieure � 3.*/

SELECT u.userId, m.title, r.rating
FROM ratings_fact r
JOIN table_Utilisateur u ON r.userId = u.userId
JOIN table_movies m ON r.movieId = m.movieId
WHERE m.genres LIKE '%Comedy%'
AND r.rating > 3;


/*2-les �valuations des films de genre "Drama" ou "Comedy" par les utilisateurs ayant �valu� plus de 3 films*/

SELECT rf.userId, rf.movieId, rf.rating, rf.timestamp
FROM ratings_fact rf
JOIN table_movies tm ON rf.movieId = tm.movieId
WHERE (tm.genres LIKE '%Drama%' OR tm.genres LIKE '%Comedy%')
AND rf.userId IN (
    SELECT userId
    FROM ratings_fact
    GROUP BY userId
    HAVING COUNT(movieId) > 3
);

-- Operation Drill-down

/*1-Obtenir les �valuations d�taill�es pour un film sp�cifique dans le genre "Drama"*/

SELECT u.userId, r.rating, r.timestamp
FROM ratings_fact r
JOIN table_Utilisateur u ON r.userId = u.userId
JOIN table_movies m ON r.movieId = m.movieId
WHERE m.genres LIKE '%Drama%'
AND m.title = 'Grumpier Old Men (1995)';


/*2-Pour obtenir les �valuations des films par ann�e*/

SELECT YEAR(rf.timestamp) AS year, COUNT(rf.rating) AS total_ratings
FROM ratings_fact rf
GROUP BY YEAR(rf.timestamp)
ORDER BY year;


-- Operation Roll-up

/*1-Obtenir le nombre total d'�valuations par genre*/

SELECT tm.genres, COUNT(rf.rating) AS total_ratings
FROM ratings_fact rf
JOIN table_movies tm ON rf.movieId = tm.movieId
GROUP BY tm.genres
WITH ROLLUP;


/*2-la moyenne des �valuations pour chaque film en regroupant par le titre du film*/

SELECT 
    m.title, 
    AVG(r.rating) AS avg_rating
FROM ratings_fact r
JOIN table_movies m ON r.movieId = m.movieId
GROUP BY m.title
ORDER BY avg_rating DESC;

