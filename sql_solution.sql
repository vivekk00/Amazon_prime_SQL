-- Amazone prime

select * from prime_videos;

select count(*) as total_content
from prime_videos;

select distinct type
from prime_videos;

-- 12 Business Problems

-- 1. Count the number of movies vs Tv Shows
SELECT 
    type, COUNT(*) AS total_content
FROM
    prime_videos
GROUP BY type;

-- 2. Find the number commen rating for months and tv shows

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

-- 3. List all movies released in a specific years (eg, 2020)

select * from prime_videos
where 
type = 'movie' and release_year = 2020;

-- 4. Find the top 5 countries with the most content on Prime videos
 
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

-- 5. Identify the longest movie or Tv show duration 

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
            
-- 6. Find content added in the last 5 years

SELECT * 
FROM prime_videos
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

-- 7. Find all the movies/Tv shows by director 'Mark Knight'

select * from prime_videos
where director like '%Mark Knight%';

-- 8. List all movies that are Documentary

select * from prime_videos
where lower(listed_in) like '%Documentary%';

-- 9. Find all content without a director

select * from prime_videos
where
	director is null;
    
-- 10. Find how many movies actor 'salamn khan' appeared in last 10 years!

select *from prime_videos
where 
	cast like '%salman khan%'
    and 
    release_year > extract(year from current_date) - 10;
    
-- 11. Find the top 10 actors who have appered in the highest number of movies produced in india.

SELECT cast, COUNT(*) AS actors
FROM prime_videos
GROUP BY cast
HAVING COUNT(*) > 1;

-- 12. Categorize the content based on the presence of the keywords 'Kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all 
-- other content as 'Good'. Count how many items fall into each category.

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


