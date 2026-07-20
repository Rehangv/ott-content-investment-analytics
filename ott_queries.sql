
-- Query 1: Top Languages by Popularity and Vote Score

SELECT 
    l.language_name,
    COUNT(*) AS movie_count,
    ROUND(AVG(m.popularity), 2) AS avg_popularity,
    ROUND(AVG(m.vote_average), 2) AS avg_vote_score
FROM movies m
JOIN language_lookup l ON m.original_language = l.language_code
WHERE m.vote_count >= 10
GROUP BY l.language_name
ORDER BY avg_popularity DESC
LIMIT 10;

-- Insight: Hindi and Tamil lead avg popularity despite low volume - strong investment signal


-- Query 2: Top quality movies all score 8.0+ with 100+ votes

SELECT 
    title,
    original_language,
    ROUND(popularity, 2) AS popularity,
    ROUND(vote_average, 2) AS vote_average,
    vote_count,
    genres,
    release_date
FROM movies
WHERE popularity > 50
AND vote_average > 7
AND vote_count > 100
ORDER BY vote_average DESC, popularity DESC
LIMIT 15;

-- Shawshank, Matrix, Interstellar prove timeless content stays popular


-- Query 3: High Performing Individual TV Shows

SELECT 
    title,
    original_language,
    ROUND(popularity, 2) AS popularity,
    ROUND(vote_average, 2) AS vote_average,
    vote_count,
    genres,
    release_date
FROM tvshows
WHERE popularity > 50
AND vote_average > 7
AND vote_count > 100
ORDER BY vote_average DESC, popularity DESC
LIMIT 15;

-- Insight: Korean and Japanese content dominate TV quality rankings
-- Animation|Sci-Fi and Crime|Drama are strongest TV genres by vote score
-- Non-English content punches above weight significantly in TV space


-- Query 4: Best Release Month by Content Performance

SELECT 
    MONTH(release_date) AS month_num,
    CASE MONTH(release_date)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS release_month,
    COUNT(*) AS total_titles,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(vote_average), 2) AS avg_vote_score
FROM movies
WHERE release_date IS NOT NULL
AND vote_count >= 10
GROUP BY month_num, release_month
ORDER BY avg_popularity DESC;

-- Insight: June-April-May are peak popularity months (summer blockbuster window)
-- December leads quality scores - awards season prestige content strategy confirmed
-- OTT platforms should schedule mainstream content Apr-Jun, prestige content Nov-Dec


-- Query 5: Languages Punching Above Their Weight(High quality low volume languages = investment opportunity)

SELECT 
    l.language_name,
    COUNT(*) AS movie_count,
    ROUND(AVG(m.popularity), 2) AS avg_popularity,
    ROUND(AVG(m.vote_average), 2) AS avg_vote_score,
    ROUND(AVG(m.vote_count), 0) AS avg_votes
FROM movies m
JOIN language_lookup l ON (m.original_language) = (l.language_code)
WHERE m.vote_count >= 10
GROUP BY l.language_name
HAVING movie_count < 50
AND avg_vote_score > 6.5
ORDER BY avg_vote_score DESC
LIMIT 15;

-- Insight: Malayalam (ml) scores 7.13 quality with only 5 movies - biggest opportunity gap
-- Indonesian (id) has 3256 avg votes despite 2 movies - massive underserved audience
-- Turkish (tr) and Thai (th) also show high quality low volume signals
-- Strategy: Invest in Malayalam, Indonesian, Turkish originals before market saturates


-- Query 6: Indian Language Content Deep Dive- Which Indian language deserves priority OTT investment?

SELECT 
    l.language_name,
    COUNT(*) AS movie_count,
    ROUND(AVG(m.popularity), 2) AS avg_popularity,
    ROUND(AVG(m.vote_average), 2) AS avg_vote_score,
    ROUND(AVG(m.vote_count), 0) AS avg_votes,
    ROUND(MAX(m.popularity), 2) AS peak_popularity,
    ROUND(MAX(m.vote_average), 2) AS peak_vote
FROM movies m
JOIN language_lookup l ON (m.original_language) = (l.language_code)
WHERE m.original_language IN ('hi', 'ta', 'te', 'ml', 'kn', 'bn')
GROUP BY l.language_name
ORDER BY avg_popularity DESC;

-- Insight: Hindi leads popularity (45.35) but Malayalam (6.77) and Bengali (7.00) lead quality despite tiny volumes 
-- clear two-tier India strategy: Hindi for mass reach, Malayalam/Bengali for premium quality positioning


-- Query 7: Movies vs TV Shows Head to Head- Format-level comparison to guide content investment

SELECT 
    'Movies' AS content_type,
    COUNT(*) AS total_titles,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(vote_average), 2) AS avg_vote_score,
    ROUND(AVG(vote_count), 0) AS avg_votes,
    ROUND(MAX(popularity), 2) AS peak_popularity,
    ROUND(MIN(popularity), 2) AS min_popularity
FROM movies
WHERE vote_count >= 10

UNION ALL

SELECT 
    'TV Shows' AS content_type,
    COUNT(*) AS total_titles,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(vote_average), 2) AS avg_vote_score,
    ROUND(AVG(vote_count), 0) AS avg_votes,
    ROUND(MAX(popularity), 2) AS peak_popularity,
    ROUND(MIN(popularity), 2) AS min_popularity
FROM tvshows
WHERE vote_count >= 10;

-- Insight: TV Shows dominate on popularity (33.65 vs 16.04) and quality (7.46 vs 6.89)
-- But Movies get 7x more votes per title - larger individual audience per title
-- Strategy: TV Shows for platform buzz, Movies for deep audience engagement


-- Query 8: Top 10 Most Engaging Movies vs TV Shows - Highest audience engagement by vote count

(SELECT 
    'Movie' AS type,
    title,
    original_language,
    vote_count,
    ROUND(vote_average, 2) AS vote_average,
    ROUND(popularity, 2) AS popularity,
    genres
FROM movies
ORDER BY vote_count DESC
LIMIT 10)

UNION ALL

(SELECT 
    'TV Show' AS type,
    title,
    original_language,
    vote_count,
    ROUND(vote_average, 2) AS vote_average,
    ROUND(popularity, 2) AS popularity,
    genres
FROM tvshows
ORDER BY vote_count DESC
LIMIT 10)

ORDER BY type, vote_count DESC;

-- Insight: Interstellar leads movie engagement (40K votes, 8.48 rating)
-- Money Heist (Spanish) and Squid Game (Korean) in top TV engagement
-- confirms non-English content has genuine global audience appeal
-- Movies average 2-3x more votes than TV shows per title



























