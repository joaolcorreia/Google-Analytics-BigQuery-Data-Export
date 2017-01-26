# Google Analytics BigQuery data export 
This repository contains SQL code to export data from Google Analytics in BigQuery, using standard or legacy SQL.

# Data Extract
### Google Analytics Data BigQuery Export
Both SQL queries below transform Google Analytics BigQuery nested data into flat hit level data with a timestamp making data easy to analyze using  tools like Tableau, SAS, R, etc.

- google-analytics-bigquery-legacy-export.sql
- google-analytics-bigquery-standard-export.sql

##### Instructions:
1. Open the SQL and configure the table(s) to export
3. Output the results to another table and export to Google Storage
4. Download the CSVs, done!