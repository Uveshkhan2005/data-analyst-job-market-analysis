-- 01. Database and schema validation
SELECT current_database() AS current_database;

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'job_postings'
ORDER BY ordinal_position;

SELECT COUNT(*) AS total_job_postings
FROM public.job_postings;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT slug) AS unique_job_slugs,
       COUNT(*) - COUNT(DISTINCT slug) AS possible_duplicate_slug_rows
FROM public.job_postings;




-- 02. Data quality checks
SELECT
    COUNT(*) FILTER (WHERE slug IS NULL OR TRIM(slug) = '') AS missing_slugs,
    COUNT(*) FILTER (WHERE title IS NULL OR TRIM(title) = '') AS missing_titles,
    COUNT(*) FILTER (WHERE company_name IS NULL OR TRIM(company_name) = '') AS missing_companies,
    COUNT(*) FILTER (WHERE location IS NULL OR TRIM(location) = '') AS missing_locations,
    COUNT(*) FILTER (WHERE posted_date IS NULL) AS missing_posting_dates,
    COUNT(*) FILTER (WHERE description IS NULL OR TRIM(description) = '') AS missing_descriptions,
    COUNT(*) FILTER (WHERE tags IS NULL OR TRIM(tags) = '') AS missing_tags,
    COUNT(*) FILTER (WHERE job_types IS NULL OR TRIM(job_types) = '') AS missing_job_types
FROM public.job_postings;

-- List duplicate posting identifiers, if any.
SELECT slug, COUNT(*) AS row_count
FROM public.job_postings
WHERE slug IS NOT NULL
GROUP BY slug
HAVING COUNT(*) > 1
ORDER BY row_count DESC, slug;



-- 03. Overall dashboard KPIs
SELECT
    COUNT(*) AS total_job_postings,
    COUNT(DISTINCT slug) AS unique_job_postings,
    COUNT(DISTINCT company_name) AS unique_companies,
    COUNT(DISTINCT location) AS unique_location_strings,
    COUNT(*) FILTER (WHERE remote IS TRUE) AS remote_job_postings,
    COUNT(*) FILTER (WHERE remote IS FALSE) AS non_remote_job_postings,
    COUNT(*) FILTER (WHERE remote IS NULL) AS unknown_remote_status,
    ROUND(100.0 * COUNT(*) FILTER (WHERE remote IS TRUE)
          / NULLIF(COUNT(*), 0), 2) AS remote_job_percentage
FROM public.job_postings;

-- Posting date coverage.
SELECT MIN(posted_date) AS earliest_posting_date,
       MAX(posted_date) AS latest_posting_date,
       COUNT(DISTINCT posted_date) AS distinct_posting_dates
FROM public.job_postings;




-- 04. Posting trends
SELECT DATE_TRUNC('month', posted_date)::date AS posting_month,
       COUNT(*) AS job_postings
FROM public.job_postings
WHERE posted_date IS NOT NULL
GROUP BY DATE_TRUNC('month', posted_date)
ORDER BY posting_month;

SELECT posted_year, COUNT(*) AS job_postings
FROM public.job_postings
WHERE posted_year IS NOT NULL
GROUP BY posted_year
ORDER BY posted_year;


-- 05. Job title analysis
SELECT title, COUNT(*) AS job_count
FROM public.job_postings
WHERE title IS NOT NULL AND TRIM(title) <> ''
GROUP BY title
ORDER BY job_count DESC, title
LIMIT 20;

-- Approximate role grouping based on title keywords; not a perfect taxonomy.
SELECT
    CASE
        WHEN title ILIKE '%data analyst%' THEN 'Data Analyst'
        WHEN title ILIKE '%business analyst%' THEN 'Business Analyst'
        WHEN title ILIKE '%business intelligence%'
          OR title ILIKE '%BI analyst%'
          OR title ILIKE '%BI specialist%' THEN 'Business Intelligence'
        WHEN title ILIKE '%data analytics%' THEN 'Data Analytics'
        WHEN title ILIKE '%reporting analyst%' THEN 'Reporting Analyst'
        ELSE 'Other / Not Matched'
    END AS role_category,
    COUNT(*) AS job_count
FROM public.job_postings
GROUP BY 1
ORDER BY job_count DESC;


-- 06. Company analysis
SELECT company_name, COUNT(*) AS job_count
FROM public.job_postings
WHERE company_name IS NOT NULL AND TRIM(company_name) <> ''
GROUP BY company_name
ORDER BY job_count DESC, company_name
LIMIT 20;


-- 07. Location analysis
-- These are raw location strings; some may contain regions, multiple locations,
-- country names, or remote labels rather than a normalized city.
SELECT location, COUNT(*) AS job_count
FROM public.job_postings
WHERE location IS NOT NULL AND TRIM(location) <> ''
GROUP BY location
ORDER BY job_count DESC, location
LIMIT 25;

SELECT location, COUNT(*) AS job_count
FROM public.job_postings
WHERE location IS NOT NULL
  AND (title ILIKE '%data analyst%'
       OR title ILIKE '%business analyst%'
       OR title ILIKE '%business intelligence%'
       OR title ILIKE '%data analytics%'
       OR title ILIKE '%reporting analyst%')
GROUP BY location
ORDER BY job_count DESC, location
LIMIT 25;


-- 08. Remote work analysis
SELECT
    CASE WHEN remote IS TRUE THEN 'Remote'
         WHEN remote IS FALSE THEN 'Non-Remote'
         ELSE 'Not Specified' END AS work_arrangement,
    COUNT(*) AS job_count,
    ROUND(100.0 * COUNT(*) /
          NULLIF((SELECT COUNT(*) FROM public.job_postings), 0), 2)
          AS percentage_of_all_postings
FROM public.job_postings
GROUP BY 1
ORDER BY job_count DESC;

SELECT
    CASE
        WHEN title ILIKE '%data analyst%' THEN 'Data Analyst'
        WHEN title ILIKE '%business analyst%' THEN 'Business Analyst'
        WHEN title ILIKE '%business intelligence%'
          OR title ILIKE '%BI analyst%'
          OR title ILIKE '%BI specialist%' THEN 'Business Intelligence'
        WHEN title ILIKE '%data analytics%' THEN 'Data Analytics'
        WHEN title ILIKE '%reporting analyst%' THEN 'Reporting Analyst'
        ELSE 'Other / Not Matched'
    END AS role_category,
    CASE WHEN remote IS TRUE THEN 'Remote'
         WHEN remote IS FALSE THEN 'Non-Remote'
         ELSE 'Not Specified' END AS work_arrangement,
    COUNT(*) AS job_count
FROM public.job_postings
GROUP BY 1, 2
ORDER BY role_category, job_count DESC;


-- 09. Employment type analysis
-- Source values are inconsistent and may combine multiple labels.
SELECT COALESCE(NULLIF(TRIM(job_types), ''), 'Not Specified')
           AS employment_type_raw,
       COUNT(*) AS job_count,
       ROUND(100.0 * COUNT(*) /
             NULLIF((SELECT COUNT(*) FROM public.job_postings), 0), 2)
             AS percentage_of_all_postings
FROM public.job_postings
GROUP BY 1
ORDER BY job_count DESC
LIMIT 25;

-- Optional broad grouping. The first matching CASE condition is used.
SELECT
    CASE
        WHEN job_types IS NULL OR TRIM(job_types) = '' THEN 'Not Specified'
        WHEN job_types ILIKE '%intern%' THEN 'Internship'
        WHEN job_types ILIKE '%working student%' OR job_types ILIKE '%student%'
            THEN 'Working Student / Student'
        WHEN job_types ILIKE '%part time%' OR job_types ILIKE '%part-time%'
            THEN 'Part-Time'
        WHEN job_types ILIKE '%contract%' OR job_types ILIKE '%freelanc%'
            THEN 'Contract / Freelance'
        WHEN job_types ILIKE '%full time%' OR job_types ILIKE '%full-time%'
          OR job_types ILIKE '%fulltime%' THEN 'Full-Time'
        ELSE 'Other / Source-Specific Label'
    END AS employment_type_group,
    COUNT(*) AS job_count
FROM public.job_postings
GROUP BY 1
ORDER BY job_count DESC;


-- 10. Tags / source category analysis
-- Tags are not a reliable individual technical-skills field.
SELECT tags, COUNT(*) AS job_count
FROM public.job_postings
WHERE tags IS NOT NULL AND TRIM(tags) <> ''
GROUP BY tags
ORDER BY job_count DESC, tags
LIMIT 20;


-- 11. Keyword-based skill mentions in job descriptions
-- A match means the description contains the keyword; it does not mean required.
SELECT
    COUNT(*) FILTER (WHERE description ILIKE '%python%') AS python_jobs,
    COUNT(*) FILTER (WHERE description ILIKE '%sql%') AS sql_jobs,
    COUNT(*) FILTER (WHERE description ILIKE '%excel%') AS excel_jobs,
    COUNT(*) FILTER (WHERE description ILIKE '%power bi%') AS power_bi_jobs,
    COUNT(*) FILTER (WHERE description ILIKE '%tableau%') AS tableau_jobs
FROM public.job_postings;

-- Row-based format, useful for exporting a chart dataset.
SELECT skill_keyword,
       COUNT(*) AS job_count,
       ROUND(100.0 * COUNT(*) /
             NULLIF((SELECT COUNT(*) FROM public.job_postings), 0), 2)
             AS percentage_of_all_postings
FROM public.job_postings
CROSS JOIN LATERAL (
    VALUES
        ('Python', description ILIKE '%python%'),
        ('SQL', description ILIKE '%sql%'),
        ('Excel', description ILIKE '%excel%'),
        ('Power BI', description ILIKE '%power bi%'),
        ('Tableau', description ILIKE '%tableau%')
) AS keyword_matches(skill_keyword, is_match)
WHERE is_match
GROUP BY skill_keyword
ORDER BY job_count DESC;

-- Keyword mentions split by approximate role category.
SELECT
    CASE
        WHEN title ILIKE '%data analyst%' THEN 'Data Analyst'
        WHEN title ILIKE '%business analyst%' THEN 'Business Analyst'
        WHEN title ILIKE '%business intelligence%'
          OR title ILIKE '%BI analyst%'
          OR title ILIKE '%BI specialist%' THEN 'Business Intelligence'
        WHEN title ILIKE '%data analytics%' THEN 'Data Analytics'
        WHEN title ILIKE '%reporting analyst%' THEN 'Reporting Analyst'
        ELSE 'Other / Not Matched'
    END AS role_category,
    COUNT(*) AS total_jobs,
    COUNT(*) FILTER (WHERE description ILIKE '%python%') AS python_mentions,
    COUNT(*) FILTER (WHERE description ILIKE '%sql%') AS sql_mentions,
    COUNT(*) FILTER (WHERE description ILIKE '%excel%') AS excel_mentions,
    COUNT(*) FILTER (WHERE description ILIKE '%power bi%') AS power_bi_mentions,
    COUNT(*) FILTER (WHERE description ILIKE '%tableau%') AS tableau_mentions
FROM public.job_postings
GROUP BY 1
ORDER BY total_jobs DESC;


-- 12. Inspect job posting examples
SELECT title, company_name, location, remote, job_types,
       posted_date, tags, url
FROM public.job_postings
WHERE title ILIKE '%data analyst%'
   OR title ILIKE '%business analyst%'
   OR title ILIKE '%business intelligence%'
   OR title ILIKE '%data analytics%'
   OR title ILIKE '%reporting analyst%'
ORDER BY posted_date DESC NULLS LAST
LIMIT 50;

-- Change the keyword below to inspect other descriptions.
SELECT title, company_name, location, posted_date, url
FROM public.job_postings
WHERE description ILIKE '%power bi%'
ORDER BY posted_date DESC NULLS LAST
LIMIT 50;


-- 13. Final reconciliation for Python / PostgreSQL / Power BI
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT slug) AS distinct_slugs,
    COUNT(DISTINCT company_name) AS distinct_companies,
    COUNT(DISTINCT location) AS distinct_location_strings,
    MIN(posted_date) AS earliest_posting_date,
    MAX(posted_date) AS latest_posting_date,
    COUNT(*) FILTER (WHERE remote IS TRUE) AS remote_rows,
    COUNT(*) FILTER (WHERE remote IS FALSE) AS non_remote_rows,
    COUNT(*) FILTER (WHERE remote IS NULL) AS unspecified_remote_rows
FROM public.job_postings;
