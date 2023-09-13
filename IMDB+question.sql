USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';       



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Title_NULL,
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Year_NULL,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS DatePublished_NULL,
		SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS Duration_NULL,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Country_NULL,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS WorldWide_NULL,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Language_NULL,
		SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_NULL
FROM movie;

-- Column-  Country , Worlwide_Gross_Income, Language and Production_Company have null values.



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First Part Query:

SELECT year, COUNT(id) AS Number_of_Movies
     FROM movie
GROUP BY year;

-- Year 2017 Produced 3052, number of movies which the highest among all years.

-- Second Part Query:

SELECT MONTH(date_published) AS Month_num, COUNT(id) AS Number_of_Movies   
       FROM movie
GROUP BY MONTH(date_published)
ORDER BY month_num;

-- March month has the highest number of movies , 824.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS Number_of_Movies
	   FROM movie
WHERE (country LIKE '%usa%' or country LIKE '%india%') and year=2019;

-- Both the countries have produced in total 1059 movies.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT genre 
       from genre
GROUP BY genre;

-- There are total 13 unique genres.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, count(movie_id) AS number_of_movies
     FROM genre
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;

-- Drama genre has hightest movie count with total 4285.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_summary AS
(
	SELECT
	movie_id, COUNT(genre) AS Genre_count
	FROM genre
	GROUP BY movie_id
	HAVING Genre_count=1
 )
 Select count(*) AS One_Genre_Movie
 FROM genre_summary;

-- There are total 3289 movies which are produced in a single Genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, round(avg(duration),2) AS avg_duration
     FROM movie mov
     INNER JOIN genre gen
	 ON mov.id=gen.movie_id
GROUP BY genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_summary AS
(
	SELECT genre, count(movie_id) AS movie_count,
		   RANK() OVER (ORDER BY count(movie_id) DESC) AS genre_rank
	   FROM genre
	GROUP BY genre
) 
SELECT * FROM  genre_summary
   WHERE genre='thriller';

-- Thriller Genre movies are in 3rd place as per the number of movies produced in all Genres.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT  MIN(avg_rating) AS min_avg_rating, 
        MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes, 
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating, 
        MAX(median_rating) AS max_median_rating
FROM ratings;

-- AVG_ratings and  Median_rating lies between 1 to 10 And total_votes are between 100 to 725138.  


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rank_summary AS
(
	SELECT title, avg_rating,
		   RANK() OVER(order by avg_rating DESC) AS movie_rank
			  FROM ratings rat
			  LEFT JOIN movie mov
			  ON rat.movie_id=mov.id
)
   SELECT * FROM movie_rank_summary
   WHERE movie_rank <= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, count(movie_id) AS movie_count
       FROM ratings
GROUP BY median_rating
ORDER BY  median_rating;

-- Median_Rating of 7 has total 2257 movie_count which is hightest among all the median_rating.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Prod_summary AS
(
SELECT production_company, count(id) AS movie_count,
	   RANK() OVER( ORDER BY count(id) DESC) AS prod_company_rank       
			   FROM movie mov
			   INNER JOIN ratings rat
			   ON mov.id=rat.movie_id	 
WHERE avg_rating > 8 and production_company is NOT NULL
GROUP BY production_company
) 
SELECT * FROM Prod_summary 
       WHERE prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT GENRE, count(gen.movie_id) as movie_count
    FROM genre gen
    INNER JOIN movie mov
    ON gen.movie_id=mov.id
    INNER JOIN ratings rat
    ON rat.movie_id=mov.id    
WHERE year=2017 and month(date_published)= 3 and country LIKE '%USA%' and total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- With 24 movie_count Drama genre produced hightest movie.



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
		  FROM movie mov
		  INNER JOIN ratings rat
		  ON rat.movie_id=mov.id 
		  INNER JOIN genre gen
		  ON gen.movie_id=mov.id      
WHERE title like 'the%' and avg_rating > 8
ORDER BY Genre, avg_rating DESC;  



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(id) AS Movie_count
		FROM movie mov
		INNER JOIN ratings rat
		ON rat.movie_id=mov.id
WHERE median_rating =8 and date_published BETWEEN '2018-04-01' AND '2019-04-01'; 

-- There is total 361 movies that are released between 1 April 2018 and 1 April 2019 and having 8 as median_rating.



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT COUNTRY, sum(total_votes) AS vote
	   FROM ratings rat
       INNER JOIN movie mov
       ON mov.id=rat.movie_id
WHERE COUNTRY in ('germany','italy')   
GROUP BY COUNTRY
ORDER BY vote DESC;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	   SUM(CASE WHEN name is NULL THEN 1 ELSE 0 END) AS name_null,
	   SUM(CASE WHEN height is NULL THEN 1 ELSE 0 END) AS height_null,
	   SUM(CASE WHEN date_of_birth is NULL THEN 1 ELSE 0 END) AS date_of_birth_null,
	   SUM(CASE WHEN known_for_movies is NULL THEN 1 ELSE 0 END) AS known_for_movies_null
FROM names;

-- All the columns except name have NULL values.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH genre_summary AS
(
   SELECT gen.Genre,count(rat.movie_id) AS Movie_count
		  FROM genre gen
		  INNER JOIN ratings rat
		  USING (movie_id)
	WHERE avg_rating > 8
	GROUP BY gen.genre
	ORDER BY Movie_count DESC
	LIMIT 3
)
SELECT name AS Director_Name, count(rat.movie_id) AS Movie_count
       FROM names nam
       INNER JOIN director_mapping dir
       ON nam.id=dir.name_id
       INNER JOIN ratings rat
       ON rat.movie_id=dir.movie_id
       INNER JOIN genre gen 
       ON gen.movie_id=dir.movie_id,
       genre_summary
WHERE avg_rating > 8 and gen.genre in (genre_summary.genre) -- Fetching top_3 genre from Genre_summary CTE.
GROUP BY Director_Name
ORDER BY Movie_count DESC
LIMIT 3;   

-- James Mangold, Anthony Russo and Soubin Shahir are the top- Directors.


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT nam.name AS Actor_Name, count(rat.movie_id) AS Movie_Count
		  FROM names nam
		  INNER JOIN role_mapping rol
		  ON nam.id=rol.name_id
		  INNER JOIN ratings rat
		  ON rat.movie_id=rol.movie_id
WHERE median_rating >=8 and rol.category='actor'
GROUP BY nam.name 
ORDER BY  Movie_Count DESC
LIMIT 2;

-- MAMMOOTHY and MOHANLAL is the answer.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Prod_Summary AS
(
	SELECT production_company, sum(total_votes) AS vote_count,
		   RANK() OVER ( ORDER BY sum(total_votes) DESC) AS Prod_Comp_Rank
		   FROM movie mov
		   INNER JOIN ratings rat
		   ON mov.id=rat.movie_id
	GROUP BY production_company   
)
 SELECT * FROM Prod_Summary
 WHERE Prod_Comp_Rank <=3;

-- Marvel Studios, Twentieth Century Fox and Warner Bros. are the top-three production House.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT nam.name AS Actor_Name, sum(total_votes) AS Total_Votes ,
       count(rol.movie_id) AS Movie_Count,
	   ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating, -- calculating avg_rating w.r.t total_votes.
	   RANK() OVER( ORDER BY  ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC, sum(total_votes) DESC) AS Actor_rank
              		   FROM movie mov
					   INNER JOIN ratings rat
					   ON rat.movie_id=mov.id
					   INNER JOIN role_mapping rol
					   ON mov.id=rol.movie_id
					   INNER JOIN names nam
					   ON nam.id=rol.name_id
WHERE country = 'india' and category = 'actor'
GROUP BY nam.name 
HAVING count(rol.movie_id) >= 5;  -- Filter the number of movie count atleast 5.


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH Actress_Summary AS
(
	SELECT nam.name AS Actress_Name, sum(total_votes) AS Total_Votes ,count(rol.movie_id) AS Movie_Count,
		   ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS Actress_avg_rating,
		   RANK() OVER( ORDER BY  ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC, sum(total_votes) DESC) AS Actress_rank
						   FROM movie mov
						   INNER JOIN ratings rat
						   ON rat.movie_id=mov.id
						   INNER JOIN role_mapping rol
						   ON mov.id=rol.movie_id
						   INNER JOIN names nam
						   ON nam.id=rol.name_id
	WHERE country = 'india' and category = 'actress' and languages like '%hindi%'
	GROUP BY nam.name 
	HAVING count(rol.movie_id) >= 3 -- Filter the number of movie count atleast 3.
) 
SELECT * 
   FROM Actress_Summary
WHERE Actress_rank <= 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH  movie_type_info AS
(
SELECT Title, Avg_Rating,
	  CASE
        WHEN avg_rating > 8 THEN 'Superhit Movies'
        WHEN avg_rating BETWEEN 7 and 8 THEN 'Hit Movies'
        WHEN avg_rating BETWEEN 5 and 7 THEN  'One-Time-Watch Movie'
        ELSE 'Flop Movies'
        END AS movie_type   -- Naming the categorical Avg_rating into new column as Film_Rating_category
			  FROM movie mov
			  INNER JOIN genre gen
			  ON mov.id=gen.movie_id
			  INNER JOIN ratings rat
			  ON mov.id=rat.movie_id
WHERE genre='thriller'
)
SELECT 
    movie_type, COUNT(*) AS total_movies
FROM
    movie_type_info
GROUP BY movie_type; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre, ROUND(AVG(duration)) AS Avg_Duration,
       sum(ROUND(AVG(duration),2)) OVER w AS running_total_duration,
       avg(ROUND(AVG(duration),2)) OVER w AS moving_avg_duration
			  FROM movie mov
			  INNER JOIN genre gen
			  ON mov.id=gen.movie_id
GROUP BY genre
WINDOW w AS (ORDER BY genre); 


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- cleaning worlwide_gross_income column

SELECT  worlwide_gross_income
        FROM movie
ORDER BY worlwide_gross_income DESC;

-- As Few values are in INR and rest are in $, hence converting the INR into $ during select statement, so that will get the correct data.


WITH Gross_Income AS
(
SELECT id, worlwide_gross_income,
			CASE
				-- Since 1 INR = 0.012 USD, applying the formula for conversion rate 
				WHEN worlwide_gross_income LIKE 'INR%' THEN ROUND(CONVERT(SUBSTRING(worlwide_gross_income, 5) , UNSIGNED) * 0.012)
				ELSE CONVERT( SUBSTRING(worlwide_gross_income, 3) , UNSIGNED)
			END AS gross_income_$
FROM movie
ORDER BY worlwide_gross_income DESC
),
top_genres AS
(
	SELECT genre, Count(*)
           FROM genre gen
           INNER JOIN movie mov
           ON gen.movie_id = mov.id
	GROUP BY  genre
	ORDER BY  Count(*) DESC limit 3
), 
           
Top_gross_Movie AS
(
	SELECT gen.genre, mov.year, mov.title AS movie_name,
		   gross.gross_income_$,
		   Dense_rank() OVER (partition BY mov.year ORDER BY gross.gross_income_$ DESC) AS movie_rank
				   FROM  movie mov
				   INNER JOIN Gross_Income gross
				   using (id)
				   INNER JOIN genre gen
                   ON gen.movie_id = mov.id,
				   top_genres
	WHERE gen.genre IN (top_genres.genre)
)

SELECT *
    FROM Top_gross_Movie
WHERE  movie_rank <= 5 ;








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Prod_Summary AS
(
	SELECT production_company, count(id) AS movie_count,
		   RANK() OVER( ORDER BY count(id) DESC) AS prod_comp_rank
			   FROM movie mov
			   INNER JOIN ratings rat
			   ON mov.id=rat.movie_id
	WHERE median_rating >= 8  and  POSITION(',' IN languages)>0 and  production_company IS NOT NULL
	GROUP BY production_company
)
SELECT * FROM Prod_Summary
   WHERE  prod_comp_rank <=2;

-- Star Cinema, Twentieth Century Fox are the top two Production Houses.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH Actress_Summary AS
(
		SELECT name AS Actress_Name ,sum(total_votes) AS Total_votes, 
			   count(rol.movie_id) AS Movie_count,
			   avg(Avg_rating) AS Actress_Avg_Rating, -- As there is no mentioned of calculating avg_rating based on votes, hence calculating the average of avg_rating.
			   RANK() OVER ( ORDER BY count(rol.movie_id) DESC) AS Actress_rank	-- We are ordering based on number of movies.
						   FROM role_mapping rol
						   INNER JOIN names nam
						   ON nam.id=rol.name_id
						   INNER JOIN ratings rat
						   ON rat.movie_id=rol.movie_id
                           INNER JOIN genre gen
                           ON gen.movie_id=rat.movie_id
		WHERE avg_rating > 8 and category ='actress' and genre ='drama'
		GROUP BY name
)        
SELECT * FROM Actress_Summary
     WHERE Actress_rank<=3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH Director_Summary AS
(
	SELECT dir.name_id, nam.name, mov.id, rat.avg_rating, rat.total_votes, mov.duration,
		   mov.date_published,
		   LEAD(mov.date_published,1) OVER( PARTITION BY dir.name_id ORDER BY mov.date_published) AS Next_date -- Calculating the next published date using LEAD for each Director.
				   FROM names nam
				   INNER JOIN director_mapping dir
				   ON nam.id=dir.name_id
				   INNER JOIN movie mov
				   ON mov.id=dir.movie_id
				   INNER JOIN ratings rat
				   ON dir.movie_id=rat.movie_id
 ),
 Final_Summary AS
 (
     SELECT *,
           DATEDIFF(Next_date,date_published) AS Date_Interval -- Calutaing the date difference to find an average of the same.
     FROM  Director_Summary
 )    
	SELECT name_id AS Director_ID, name as Director_Name, 
	       count(id) AS Number_Of_movies,
           ROUND(avg(Date_Interval)) AS avg_inter_movie_days,
	       ROUND(avg(avg_rating),2) AS Avg_Rating , 
           sum(total_votes) AS Total_Votes,
           min(avg_rating) AS Min_Rating,
           max(avg_rating) AS Max_Rating,
           sum(duration) AS Total_Duration   
FROM Final_Summary 
GROUP BY name_id
ORDER BY Number_Of_movies DESC
LIMIT 9 ;    
	





