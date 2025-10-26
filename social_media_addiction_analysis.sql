-- Initial Sanity Check

-- View the table structure (column names, data types, and keys)
DESCRIBE social_media;

-- Preview the first 10 rows to ensure data imported correctly
SELECT * 
FROM social_media
LIMIT 10;

-- Count the total number of rows in the dataset
SELECT COUNT(*) AS total_rows
FROM social_media;

-- Check if any Student_ID values are NULL (there shouldn’t be any)
SELECT COUNT(*) AS null_student_id_count
FROM social_media
WHERE Student_ID IS NULL;

-- Check if there are any duplicate Student_ID values (each student should appear once)
SELECT Student_ID, COUNT(*) AS duplicate_count
FROM social_media
GROUP BY Student_ID
HAVING duplicate_count > 1;

-- Check for Missing or Inconsistent Data

-- Check if any records have missing Age
SELECT COUNT(*) AS missing_age
FROM social_media
WHERE Age IS NULL OR Age = '';

-- Check for missing Gender values
SELECT COUNT(*) AS missing_gender
FROM social_media
WHERE Gender IS NULL OR Gender = '';

-- Check for missing Country values
SELECT COUNT(*) AS missing_country
FROM social_media
WHERE Country IS NULL OR Country = '';

-- Check for missing Avg_Daily_Usage_Hours (main metric)
SELECT COUNT(*) AS missing_avg_usage
FROM social_media
WHERE Avg_Daily_Usage_Hours IS NULL OR Avg_Daily_Usage_Hours = '';

-- Check for missing Addicted_Score values
SELECT COUNT(*) AS missing_addicted_score
FROM social_media
WHERE Addicted_Score IS NULL OR Addicted_Score = '';

-- Descriptive Statistics (Basic Data Exploration)

-- Total number of students (sanity check)
SELECT COUNT(*) AS total_students
FROM social_media;

-- Average, minimum, and maximum age of students
SELECT 
    ROUND(AVG(Age), 2) AS avg_age,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age
FROM social_media;

-- Average daily social media usage (in hours)
SELECT 
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_daily_usage,
    MIN(Avg_Daily_Usage_Hours) AS min_usage,
    MAX(Avg_Daily_Usage_Hours) AS max_usage
FROM social_media;

-- Average sleep hours per night
SELECT 
    ROUND(AVG(Sleep_Hours_Per_Night), 2) AS avg_sleep,
    MIN(Sleep_Hours_Per_Night) AS min_sleep,
    MAX(Sleep_Hours_Per_Night) AS max_sleep
FROM social_media;

-- Average addicted score and mental health score
SELECT 
    ROUND(AVG(Addicted_Score), 2) AS avg_addicted_score,
    ROUND(AVG(Mental_Health_Score), 2) AS avg_mental_health
FROM social_media;

-- Analytical Queries (Find Key Insights)

-- Find which platforms are most addictive on average
SELECT 
    Most_Used_Platform,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_usage_hours,
    COUNT(*) AS user_count
FROM social_media
GROUP BY Most_Used_Platform
ORDER BY avg_addiction DESC;

-- Compare social media usage between countries
SELECT 
    Country,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_daily_usage,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction
FROM social_media
GROUP BY Country
ORDER BY avg_daily_usage DESC;

-- Find addiction differences between high school, undergraduate, and graduate students
SELECT 
    Academic_Level,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_daily_usage,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction
FROM social_media
GROUP BY Academic_Level
ORDER BY avg_addiction DESC;

-- Compare addiction score and usage between male and female students
SELECT 
    Gender,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_daily_usage,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction
FROM social_media
GROUP BY Gender;

-- Relationship & Correlation Analysis

-- Check if higher addiction leads to less sleep
SELECT 
    ROUND(AVG(Sleep_Hours_Per_Night), 2) AS avg_sleep,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    CASE 
        WHEN Addicted_Score <= 3 THEN 'Low Addiction'
        WHEN Addicted_Score BETWEEN 4 AND 7 THEN 'Moderate Addiction'
        ELSE 'High Addiction'
    END AS addiction_level_group
FROM social_media
GROUP BY addiction_level_group
ORDER BY avg_addiction DESC;

-- Compare addicted scores between students who said "Yes" or "No"
SELECT 
    Affects_Academic_Performance,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_usage,
    COUNT(*) AS student_count
FROM social_media
GROUP BY Affects_Academic_Performance;

-- Group students by mental health score level and compare average addiction
SELECT 
    CASE 
        WHEN Mental_Health_Score <= 3 THEN 'Low Mental Health'
        WHEN Mental_Health_Score BETWEEN 4 AND 7 THEN 'Moderate Mental Health'
        ELSE 'High Mental Health'
    END AS mental_health_group,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_usage,
    ROUND(AVG(Sleep_Hours_Per_Night), 2) AS avg_sleep
FROM social_media
GROUP BY mental_health_group
ORDER BY avg_addiction DESC;

-- Create Summary Tables for Later Visualization

-- Create a summary table for social media platforms
CREATE TABLE platform_summary AS
SELECT 
    Most_Used_Platform,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_usage_hours,
    ROUND(AVG(Sleep_Hours_Per_Night), 2) AS avg_sleep,
    COUNT(*) AS total_students
FROM social_media
GROUP BY Most_Used_Platform
ORDER BY avg_addiction DESC;

-- Create a summary table for countries
CREATE TABLE country_summary AS
SELECT 
    Country,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_usage,
    ROUND(AVG(Mental_Health_Score), 2) AS avg_mental_health,
    COUNT(*) AS total_students
FROM social_media
GROUP BY Country
ORDER BY avg_addiction DESC;

-- Create a summary table by academic level
CREATE TABLE academic_summary AS
SELECT 
    Academic_Level,
    ROUND(AVG(Addicted_Score), 2) AS avg_addiction,
    ROUND(AVG(Avg_Daily_Usage_Hours), 2) AS avg_usage,
    ROUND(AVG(Mental_Health_Score), 2) AS avg_mental_health,
    ROUND(AVG(Sleep_Hours_Per_Night), 2) AS avg_sleep
FROM social_media
GROUP BY Academic_Level
ORDER BY avg_addiction DESC;

SHOW TABLES;

SELECT * FROM platform_summary;
SELECT * FROM country_summary;
SELECT * FROM academic_summary;

