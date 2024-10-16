import re
import random
import time
from datetime import date
from urllib.error import HTTPError
from bs4 import BeautifulSoup
import requests


def clean_salary(salary_range):
    salary_range = str(salary_range).replace(",", "").replace("RM", "").replace("$", "").replace("rm", "").replace("–", "-").strip()
    if re.search(r"(p.a.)", salary_range):
        multiplier = 12
    else:
        multiplier = 1

    salary_range = salary_range.split("-")
    salaries = []

    for salary in salary_range:
        salary = salary.replace("\xa0","")
        
        match_1 = re.search(r"\d+k", salary)
        if match_1:
            group_1 = match_1.group()
            salary = group_1.replace("k", "000")
        
        match_2 = re.search(r"\d+", salary)
        if match_2:
            group_2 = match_2.group()
            salary = group_2
        
        try:
            salary = int(salary)
        except ValueError:
            return "undisclosed"

        salaries.append(salary)
    
    if len(salaries) == 2:
        base = salaries[0]
        upper = salaries[1]
        average_salary = (base + upper) // (2 * multiplier)
        return average_salary

    return salaries[0]
        

def web_scraper():
    job_list = []
    pages = 5
    baseurl = "https://www.jobstreet.com.my"
    headers = ({"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0"})

    for page_num in range(1, pages):
        url = f"https://www.jobstreet.com.my/data-analyst-jobs?page={page_num}&sortmode=KeywordRelevance"

        try:
            r = requests.get(url, headers, timeout=5)
            r.raise_for_status()
        except HTTPError:  
            print("Error: Invalid URL")
        except TimeoutError:
            print("Error: Timeout")

        soup = BeautifulSoup(r.content, "lxml")
        job_card = soup.find_all("article", {"data-card-type":"JobCard"})

        for jobs in job_card:
            job = jobs.find("a", {"data-automation": "jobTitle"})
            company = jobs.find("a", {"data-automation": "jobCompany"})
            salary = jobs.find("span", class_="y735df0 _153p76c1 _1iz8dgs4y _1iz8dgs0 _1iz8dgsr _153p76c3")

            if job and company:
                job_dict = {}
                job_dict["job"] = job.text.strip()
                job_dict["company"] = company.text.strip()

                if salary is None or salary.text.isalpha():
                    job_dict["salary"] = "undisclosed"
                else:
                    job_dict["salary"] = clean_salary(salary.text)

                job_dict["website"] = f"{baseurl}{job['href']}"
                job_list.append(job_dict)

        # SLEEP TIME
        sleep_time = random.uniform(1, 2)
        timer = round(sleep_time, 2) 
        time.sleep(timer)
    
    # CREATE DAILY FILE UPDATES
    d = date.today().strftime("%d%m%y")
    with open(f"./jobs/job_info_{d}.txt", "w", encoding="utf-8") as f:
        for item in job_list:
            f.write(f'{item["company"]};{item["job"]};{item["salary"]};{item["website"]}\n')


if __name__ == "__main__":
    web_scraper()
