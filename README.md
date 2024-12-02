# Amazone prime Movies and Tv Showes Data analysis using SQL

![Amazon prime](https://github.com/vivekk00/Amazon_prime_SQL/blob/main/logo.webp)


## Overview
This project involves a comprehensive analysis of amazon prime movies and tv shows data using SQL.The goal is to 
exctract valuable insights and answer various business question based on the dataset. The following README
provides a detailes accounts of the project's objectives, business problems, solutions, findings, and conclusions.


## Objective

- Analyze the distribution of content types (movies vs TV shows) .
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

The data foe this project is sourced from the Keggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/amazon-prime-movies-and-tv-shows)

## Business Problems and Solutions

-- 1. Count the number of movies vs Tv Shows
```sql
SELECT 
    type, COUNT(*) AS total_content
FROM
    prime_videos
GROUP BY type;
```

**Objective:** Determine the distribution of content types on prime videos.

-- 2. Find the number commen rating for months and tv shows
```sql
SELECT type, ranking
from 
(
	SELECT 
		type, rating, COUNT(*),
		rank() over(partition by type order by count(*) desc) as ranking
	FROM
		prime_videos
		GROUP BY 1 , 2
) as t1
where 
ranking = 1;
```
**Objective:** Identify the most frequently occuring rating for each typw of content.

-- 3. List all movies released in a specific years (eg, 2020)
```sql
select * from prime_videos
where 
type = 'movie' and release_year = 2020;
```
**Objective:** Retriveve all movies released in a specific year.

-- 4. Find the top 5 countries with the most content on Prime videos
 ```sql
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(countries, ',', 1),
            ',',
            - 1) AS new_country,
    COUNT(show_id) AS total_content
FROM
    prime_videos
GROUP BY 1
order by 2 desc
limit 5;
```
**Objective:** Identify the top 5 countries with the highest number of content items.

-- 5. Identify the longest movie or Tv show duration 
```sql
SELECT 
    *
FROM
    prime_videos
WHERE
    type = 'movie'
        AND duration = (SELECT 
            MAX(duration)
        FROM
            prime_videos);
```
**Objective:** Identify the longest duration.

-- 6. Find content added in the last 5 years
```sql
SELECT * 
FROM prime_videos
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;
```
**Objective:** content added in last 5 years.

-- 7. Find all the movies/Tv shows by director 'Mark Knight'
```sql
select * from prime_videos
where director like '%Mark Knight%';
```
**Objective:** Find all the movies/tv shows directed by 'Mark Knight'

-- 8. List all movies that are Documentary
```sql
select * from prime_videos
where lower(listed_in) like '%Documentary%';
```
-- 9. Find all content without a director
```sql
select * from prime_videos
where
	director is null;
```
-- 10. Find how many movies actor 'salamn khan' appeared in last 10 years!
```sql
select *from prime_videos
where 
	cast like '%salman khan%'
    and 
    release_year > extract(year from current_date) - 10;
```
-- 11. Find the top 10 actors who have appered in the highest number of movies produced in india.
```sql
SELECT cast, COUNT(*) AS actors
FROM prime_videos
GROUP BY cast
HAVING COUNT(*) > 1;
```
-- 12. Categorize the content based on the presence of the keywords 'Kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all 
-- other content as 'Good'. Count how many items fall into each category.
```sql
with new_table
as
(
select 
*,
case
when
	description like '%like' or
    description like '%violence' then 'Bad_content'
    else 'Good_content'
    end category
 from prime_videos
)
select category,count(*) as total_content
from new_table
group by 1;
```
