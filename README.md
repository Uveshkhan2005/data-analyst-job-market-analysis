# Data Analyst Job Market Analysis

### End-to-End Data Analytics Project | Python | API | SQL | PostgreSQL | Power BI

An end-to-end Job Market Analytics project focused on analyzing job postings to understand job demand, required technical skills, experience levels, locations, employment types, work arrangements, and hiring trends.

The project combines **Python, API-based data collection, data cleaning, exploratory data analysis (EDA), SQL, PostgreSQL, and Power BI** to transform raw job-posting data into actionable career and workforce insights.

---

## Project Overview

The data analyst job market changes continuously, with companies looking for professionals who possess a combination of technical, analytical, and business skills.

This project analyzes job-posting data to understand:

- Demand for data analyst and related analytics roles
- Most requested technical and analytical skills
- Popular job locations and geographic demand
- Remote versus non-remote opportunities
- Employment types and job requirements
- Companies with the highest number of job postings
- Demand for Python, SQL, Excel, Power BI, and Tableau
- Combinations of skills requested by employers
- Job-posting trends over time

The objective is to identify patterns in job postings and understand the skills and requirements that may help aspiring data analysts prepare for employment.

---

## Project Objectives

- Collect job-posting data using a public API.
- Store and preserve the original raw data.
- Clean and standardize job-posting information.
- Perform exploratory data analysis using Python.
- Extract and analyze technical skills from job descriptions and tags.
- Store structured job data in PostgreSQL.
- Write SQL queries to answer business questions.
- Build an interactive Power BI dashboard.
- Develop evidence-based insights into job demand and employer requirements.
- Present the complete workflow in a reproducible GitHub project.

---

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Python | Data collection, cleaning, and analysis |
| Requests | API data collection |
| Pandas | Data manipulation and transformation |
| NumPy | Numerical operations |
| Matplotlib | Data visualization |
| Seaborn | Statistical visualization |
| PostgreSQL | Relational database storage |
| SQL | Business analysis and data querying |
| Power BI | Interactive dashboard development |
| DAX | Dashboard measures and calculations |
| Power Query | Data transformation and preparation |
| Git | Version control |
| GitHub | Project documentation and code hosting |

---

## Dataset Overview

### Data Source

**API:** [Arbeitnow Job Board API](https://www.arbeitnow.com/blog/job-board-api)

The project uses publicly available job-posting data from the Arbeitnow Job Board API.

The API provides job listings from multiple sources in a consistent format. Available fields include job titles, company names, descriptions, locations, remote-work indicators, tags, employment types, and job URLs.

### Dataset Information

| Attribute | Details |
|---|---|
| Data source | Arbeitnow Job Board API |
| Data format | JSON |
| Data collection method | API-based |
| Analytical format | CSV and PostgreSQL |
| Primary unit of analysis | Job posting |
| Main focus | Job demand, skills, locations, and work arrangements |

### Main Dataset Fields

The collected dataset includes the following fields:

| Column | Description |
|---|---|
| `slug` | Job-posting identifier or slug |
| `company_name` | Hiring company |
| `title` | Job title |
| `description` | Job description |
| `remote` | Remote-work indicator supplied by the API |
| `url` | Job-posting or application URL |
| `tags` | Tags associated with the job |
| `job_types` | Employment type or job-type information |
| `location` | Location information provided in the listing |
| `created_at` | Original job creation timestamp |
| `posted_date` | Date derived for analysis |
| `posted_year` | Year derived from the posting date |
| `posted_month` | Month derived from the posting date |

Additional analytical fields are created during data preparation, including:

- `remote_status`
- `job_category`
- `experience_level`
- `city`
- `skills`
- `skill_count`

The exact availability and interpretation of these fields depend on the source data and the project's transformation logic.

### Important Dataset Limitations

- Job postings represent a collected snapshot, not the entire job market.
- The source has a strong European focus, so findings should not be generalized to every country.
- Job descriptions and tags may be incomplete or inconsistent.
- The API's remote-work flag may not capture every remote or hybrid arrangement.
- Salary information may be unavailable or insufficient for reliable salary comparisons.
- Job titles, locations, employment types, and experience requirements may require standardization.
- Skill frequency measures mention or detection frequency in the collected postings, not necessarily the importance of a skill to every employer.

---

## Project Workflow

```text
Public Job Board API
        |
        v
API Data Collection
        |
        v
Raw JSON Dataset
        |
        v
Python Data Cleaning
        |
        v
Feature Engineering
        |
        v
Exploratory Data Analysis
        |
        v
Skill Extraction and Analysis
        |
        v
PostgreSQL Database
        |
        v
SQL Business Analysis
        |
        v
Power BI Dashboard
        |
        v
Business Insights and Conclusions
```

---

## Repository Structure

```text
data-analyst-job-market-analysis/
│
├── dataset/
│   ├── raw_jobs.json
│   ├── job_market_clean.csv
│   ├── job_market_analysis.csv
│   ├── core_data_analytics_skills.csv
│   ├── data_analyst_skill_combinations.csv
│   ├── skill_combinations.csv
│   ├── skill_frequency.csv
│   ├── skills_by_category.csv
│   └── skills_by_experience.csv
│
├── notebooks/
│   ├── 01_api_data_collection.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_job_market_eda.ipynb
│   └── 05_skills_analysis.ipynb
│
├── sql/
│   └── job_market_analysis.sql
│
├── powerbi/
│   └── job_market_analysis.pbix
│
├── visuals/
│
├── report/
│
├── src/
│
├── .gitignore
└── README.md
```

*Note: The structure above documents the intended project organization. Keep only files and folders that actually exist in the repository, and update the list if their names change.*

---

## Data Collection and Preparation

The data preparation workflow includes the following steps:

1. Connect to the public job-board API.
2. Retrieve the available job postings.
3. Preserve the raw API response for traceability.
4. Convert the relevant fields into a structured dataset.
5. Inspect missing values and duplicate postings.
6. Standardize column names and data types.
7. Clean and prepare job titles, company names, and locations.
8. Convert posting timestamps into date-based analytical fields.
9. Create analytical categories where the source data supports them.
10. Extract and standardize relevant technical skills.
11. Export the prepared datasets for SQL analysis and visualization.

Raw data is retained separately from cleaned and analytical datasets to make the transformation process easier to review.

---

## Exploratory Data Analysis

Python is used to investigate patterns in the collected job postings.

### 1. Job Demand Analysis

- Count job postings by job category.
- Identify frequently appearing job titles.
- Compare the distribution of data analyst and related roles.
- Examine the number of postings by company.

### 2. Geographic Analysis

- Identify locations with the highest number of postings.
- Examine city-level job distribution where locations can be standardized.
- Identify listings with missing, ambiguous, or remote-only locations.
- Compare opportunities across locations represented in the dataset.

### 3. Work Arrangement Analysis

- Compare listings marked as remote and non-remote.
- Examine the distribution of work arrangements.
- Compare remote opportunities across job categories.

### 4. Employment and Experience Analysis

- Analyze employment types using the available job-type field.
- Examine experience levels when they can be reliably inferred.
- Identify common patterns in entry-level and experienced roles.

### 5. Technical Skills Analysis

- Measure the frequency of selected skills.
- Compare SQL, Python, Excel, Power BI, and Tableau mentions.
- Examine skills across job categories.
- Identify frequently occurring combinations of skills.

All findings are based on the collected dataset. They should not be interpreted as universal job-market statistics.

---

## Skills Analysis

Technical skills are an important part of preparing for a Data Analyst role.

The project investigates the presence of commonly requested skills, including:

- SQL
- Python
- Microsoft Excel
- Power BI
- Tableau

Additional skills are included when supported by the collected job descriptions and tags.

### Key Questions

- Which skills appear most frequently in the collected postings?
- How often are SQL and Python mentioned together?
- How frequently do employers mention Excel and SQL?
- How often are Power BI and Tableau mentioned?
- Which skills appear across multiple job categories?
- How do skill mentions vary by inferred experience level?

Skill extraction relies on the project's matching and standardization rules. Results may be affected by abbreviations, synonyms, context, and the quality of job descriptions.

---

## PostgreSQL and SQL Analysis

PostgreSQL is used to store the structured job-posting dataset and perform analytical queries.

**Database:** `job_market_db`

**Main table:** `job_postings`

The SQL analysis covers the following business questions:

1. What is the total number of job postings?
2. How many unique job postings are present?
3. Which job categories have the highest posting counts?
4. Which job titles appear most frequently?
5. Which companies have the highest number of postings?
6. Which locations have the greatest job demand?
7. What is the distribution of remote and non-remote listings?
8. Which employment types appear most frequently?
9. What is the distribution of experience levels?
10. Which technical skills are mentioned most frequently?
11. How often are Python, SQL, Excel, Power BI, and Tableau mentioned?
12. Which combinations of technical skills appear in the dataset?
13. Which skills are associated with specific job categories?
14. How do skill mentions vary across experience levels?
15. How are job postings distributed across posting dates and months?
16. Which remote opportunities appear in particular job categories?
17. Is salary analysis feasible using the available source data?

The complete, commented SQL analysis is maintained in:

`sql/job_market_analysis.sql`

---

## Power BI Dashboard

The Power BI dashboard is designed to present the results of the job-market analysis in an interactive and business-friendly format.

### Page 1 — Job Market Overview

**Purpose:** Present a high-level view of the collected job postings.

Planned components:

- Total job postings
- Unique companies
- Unique locations
- Remote and non-remote job distribution
- Job postings by category
- Job postings by location
- Job-posting trends over time
- Experience-level distribution, where supported

### Page 2 — Skills and Requirements

**Purpose:** Explore technical skills mentioned in job postings.

Planned components:

- Most frequently mentioned skills
- Skill frequency comparison
- Skills by job category
- Common skill combinations
- Skills by experience level, where supported
- SQL, Python, Excel, Power BI, and Tableau analysis

### Page 3 — Companies, Locations and Opportunities

**Purpose:** Examine where opportunities appear and which companies are hiring.

Planned components:

- Top companies by posting count
- Job distribution by location
- Job categories by location
- Remote opportunities by category or location
- Employment-type distribution
- Salary analysis only if the available data is sufficiently complete and comparable

The final visuals and KPIs will depend on data quality, field availability, and validation of the underlying calculations.

---

## Key Business Questions

This project is designed to answer practical questions for aspiring Data Analysts:

- Which analytics-related roles appear most often in the collected data?
- Which technical skills are mentioned most frequently?
- How often do job postings mention SQL and Python together?
- Which companies have the most postings in the snapshot?
- Which locations show the greatest number of collected opportunities?
- What proportion of listings are marked as remote?
- Which employment types are represented?
- How do skill requirements vary between job categories?
- What limitations should job seekers consider when interpreting these results?

---

## Business Value

The analysis can help job seekers:

- Prioritize technical skills for further study.
- Understand how SQL, Python, Excel, and BI tools appear in job descriptions.
- Explore differences between analytics-related roles.
- Identify locations and companies represented in the dataset.
- Compare remote and non-remote opportunities.
- Use observed skill combinations to guide portfolio development.

For recruiters and workforce analysts, the project demonstrates a structured approach to transforming job postings into measurable indicators of employer demand.

These findings support preparation and exploration; they do not guarantee employment outcomes or establish the full demand for any skill across the global market.

---

## Data Quality and Validation

The project includes validation checks to improve the reliability of the analysis.

- Check total rows and unique job-posting identifiers.
- Identify duplicate records.
- Review missing values in important fields.
- Validate posting-date conversions.
- Inspect inconsistent job titles and locations.
- Verify skill-extraction rules.
- Compare Python and SQL aggregate results.
- Validate Power BI measures against the prepared dataset.
- Avoid reporting unsupported salary statistics.
- Document source limitations and the collection date.

Where analytical categories are inferred from job titles or descriptions, they should be treated as derived classifications rather than source-provided facts.

---

## Results and Key Findings

This section will summarize the main findings after the analysis and dashboard have been finalized.

Planned reporting areas:

- Overall job-posting distribution
- Most frequent analytics-related roles
- Most frequently mentioned technical skills
- Common skill combinations
- Leading companies and locations in the collected snapshot
- Remote versus non-remote distribution
- Employment-type and experience-level patterns
- Data quality limitations and recommendations for job seekers

Only results verified against the final dataset will be reported here.

---

## Project Status

| Component | Status |
|---|---|
| API data collection | Completed |
| Raw data preservation | Completed |
| Data cleaning | Completed |
| Feature engineering | Completed |
| Python EDA | Completed |
| Skills analysis | Completed |
| PostgreSQL data import | Completed |
| SQL business analysis | Completed |
| SQL documentation | Completed |
| Power BI dashboard | In progress |
| Dashboard validation | Pending |
| Final project documentation review | Pending |

*Update these statuses as the remaining dashboard work and final validation are completed.*

---

## How to Run the Project

### 1. Clone the Repository

```bash
git clone https://github.com/Uveshkhan2005/data-analyst-job-market-analysis.git
```

### 2. Navigate to the Project Folder

```bash
cd data-analyst-job-market-analysis
```

### 3. Install the Python Dependencies

Install the libraries used by the notebooks:

```bash
pip install pandas numpy requests matplotlib seaborn jupyter
```

Additional packages may be required if the implementation uses other libraries.

### 4. Run the Notebooks

Open Jupyter Notebook:

```bash
jupyter notebook
```

Run the notebooks in the appropriate order, beginning with data collection and continuing through cleaning, EDA, and skills analysis.

### 5. Set Up PostgreSQL

Create the database:

```sql
CREATE DATABASE job_market_db;
```

Connect to the database and import the prepared dataset into the `job_postings` table using the documented import process.

Run the commented SQL queries in:

`sql/job_market_analysis.sql`

### 6. Open the Power BI Dashboard

Open the `.pbix` file from the `powerbi/` folder once the dashboard has been finalized.

If the dataset path differs on your computer, update the Power BI data source settings and refresh the data.

---

## Ethical Use and Source Attribution

The data is obtained from the public [Arbeitnow Job Board API](https://www.arbeitnow.com/blog/job-board-api).

The project should comply with the API's current terms and applicable source requirements. Include appropriate source attribution and a link to Arbeitnow when presenting results derived from its data.

Job postings may expire, be updated, or be removed. The analysis should be understood as a snapshot of the data collected at a particular time.

The project does not claim to represent all employers, job boards, industries, or geographic markets.

---

## Future Improvements

Potential improvements include:

- Automating periodic API data collection.
- Comparing snapshots to measure changes in job-posting counts.
- Improving job-title and location standardization.
- Refining skill extraction using synonyms and context-aware matching.
- Adding salary analysis if reliable salary data becomes available.
- Comparing job categories and experience requirements over time.
- Adding automated data-quality checks.
- Improving dashboard navigation and filtering.
- Documenting reproducible data refresh steps.

These improvements will be considered based on API availability, data quality, and project scope.

---

## Author

**Uveshkhan Lohani**

B.E. in Information Technology | Aspiring Data Analyst

### Technical Skills

Python | Pandas | NumPy | SQL | PostgreSQL | Power BI | DAX | Excel | Data Cleaning | Exploratory Data Analysis | Data Visualization | Git | GitHub

### GitHub Repository

[Data Analyst Job Market Analysis](https://github.com/Uveshkhan2005/data-analyst-job-market-analysis)

---

## Disclaimer

This project is for educational and portfolio purposes. The findings reflect the job postings collected from the selected API at the time of data collection. They should not be interpreted as a complete or statistically representative measure of the global job market.

Job availability, descriptions, and requirements can change over time. All conclusions should be interpreted in the context of the dataset's source, scope, and limitations.
