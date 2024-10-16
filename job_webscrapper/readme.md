## Jobstreet Webscraper
In light of the recent tech layoffs and growing competition, It is time to get ahead by polishing up on older knowledge by knowing the trends in the market. Nothing better than a job webscrapping tool to understand the requirements of the markets by looking out job postings on Jobstreet. Separately, jobstreet webscraper also addresses the weak search relevancy for data analytic jobs, by filtering for only jobs that have programming language requirements, in order to determine nature of work and size of company.

This is a short guide on how to use the Jobstreet webscraper and what it extracts.
<br><br>
## Table of Contents
* [Requirements](#requirements)
* [Guide to Running the JobStreet Webscraper](#guide-to-running-the-jobstreet-webscraper)
* [Documentation Overview](#documentation-overview)
* [Webscraping Best Practices](#webscraping-best-practices)
<br><br>
## Requirements
To run this webscraper, you will need:
- Python 3.x
- The following Python libraries:
  - `requests`: To make HTTP requests and retrieve HTML content.
  - `BeautifulSoup` (from `bs4`): For parsing HTML content.
  - `re`: For regular expressions, specifically used for cleaning and formatting salary data.
  - `random` and `time`: To introduce delays between requests to avoid overloading the server.
  - `datetime`: For handling the current date and naming output files.
<br><br>
## Guide to Running the JobStreet Webscraper
``` 
start here >> webscraping_jobs.py >> data_cleaner.ipynb >> pull_job_info.py
```
<br><br>
## Documentation Overview
### Start here: run ```webscraping_jobs.py```
The scraper will process up to 5 pages of job listings from JobStreet, extract relevant job data, and save it in a text file. The file will be named ```job_info_ddmmyy.txt``` (where ```ddmmyy``` is the current date) and saved in the ```jobs/``` directory.

#### How to run
1. Run the webscraper by executing the following command in your terminal.
2. Users can customise the ```pages``` variable within ```web_scraper()``` function.

### Next step: Run ```data_cleaner.ipynb```
Once you have scraped job listings, the next step is to run pull_job_info.py, which performs further processing on the extracted job data. Data cleaner more accurately searches and cleans data for relevant analytic jobs based on job titles

### Run ```pull_job_info.py```
1. Performs searches for relevant degree requirements, languages, and skills based on the job descriptions available on each job's detailed page.
2. Outputs this additional data into separate CSV files: one for degree requirements, one for language requirements, and one for skill requirements.
<br><br>

## Webscraping Best Practices
The webscraper includes a timer function that introduces a random delay between requests. This ensures that the web server is not overwhelmed by continuous requests, which could result in IP blocking or server-side restrictions.

```python
sleep_time = random.uniform(1, 2)
time.sleep(sleep_time)
```


