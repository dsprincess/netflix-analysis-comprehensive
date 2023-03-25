SELECT * From titles;

/*1 How many titles are on the list?*/
SELECT COUNT(title) AS total_titles
 FROM titles;
 
 SELECT COUNT(DISTINCT title) AS distinct_total_titles
 FROM titles;
 /*Go to last part to check which titles have duplicates*/
 
 /*2 How many movie or shows on the list?*/
SELECT COUNT(title) AS total_titles, type
FROM titles
GROUP BY type;

 /*3 How many movie or shows were released per year?*/
SELECT type, release_year, COUNT(title) AS title_count
FROM titles
GROUP BY type, release_year
ORDER BY type, release_year DESC;

 /*4 a.Top 10 oldest movie or shows released? b.Top 3 oldest title per type*/
SELECT title, type, release_year
FROM titles
ORDER BY type, release_year
LIMIT 10;

SELECT *
FROM (SELECT title, type, release_year, RANK() OVER (PARTITION BY type ORDER BY release_year) AS rnk
		FROM titles)x
WHERE rnk < 4
ORDER BY type;
 
 /*5 How many movie or shows per certification?*/
SELECT type, age_certification, COUNT(title) AS title_count
FROM titles
GROUP BY type, age_certification
ORDER BY type, age_certification DESC;

 /*6 Longest movie show*/
SELECT title, type, runtime
FROM titles
WHERE type = 'MOVIE'
ORDER BY runtime DESC
LIMIT 1;

 /*7 Shortest movie show*/
SELECT title, type, runtime
FROM titles
WHERE type = 'MOVIE'
ORDER BY runtime
LIMIT 3;

 /*8 Average runtime for movies*/
SELECT type, avg(runtime)
FROM titles
GROUP BY type;

 /*9 Highest number of seasons*/
SELECT title, type, seasons
FROM titles
ORDER BY seasons DESC
LIMIT 5;

    /*10 What is the top 3 titles based on imdb_score.*/
SELECT *, RANK() OVER(ORDER BY imdb_score DESC) AS RNK
 FROM titles
 ORDER BY rnk
 LIMIT 3;
 
     /*11 What is the top 3 titles based on tmdb_score.*/
SELECT *, ROW_NUMBER() OVER(ORDER BY tmdb_score DESC) AS RNK
 FROM titles
 ORDER BY rnk
 LIMIT 3;
 
      /*12 What is the highest imdb score per release year.*/ 
SELECT *
FROM (SELECT title, release_year, imdb_score AS highest_score, ROW_NUMBER() OVER(PARTITION BY release_year ORDER BY imdb_score DESC) AS rnk_score
 FROM titles
 ORDER BY rnk_score)x
WHERE  rnk_score = 1
ORDER BY release_year;
		/*Created a ranking first based on imbd score and partition by year, then by using where filter only those highest per year*/

       /*13 Check titles that have same name*/
/*CTEs use the WITH clause at the beginning of the query, followed by the definition of the CTE. The CTE is then referred to by name in the main query.*/
WITH ranking AS
		(SELECT *, ROW_NUMBER() OVER(PARTITION BY title order by id) as rnk
		FROM titles)
SELECT title, type, release_year, genres, rnk
FROM ranking
WHERE rnk <> 1
ORDER BY id;

/*Derived tables are created using a subquery in the FROM clause of the main query. The subquery creates the temporary table, which is then used in the main query.*/
	
SELECT title, type, release_year, genres, rnk
FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY title order by id) as rnk
		FROM titles) x
WHERE rnk <> 1
ORDER BY id;