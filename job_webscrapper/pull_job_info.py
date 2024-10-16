import re
import datetime
from urllib.error import HTTPError
import pandas as pd
import requests
from bs4 import BeautifulSoup


# READ WEBSCRAPER DATA
def read_webscraper_data(date):
    jobs = []
    filename = f"./all/clean_jobs_{date}.csv"

    with open(filename, "r", encoding="utf-8") as f:
        for line in f.readlines():
            job_details = {}
            company, role, salary, website, sub_role = line.strip().split(sep=";")
            job_details["company"] = company
            job_details["role"] = role
            job_details["salary"] = salary
            job_details["website"] = website
            job_details["role_category"] = sub_role
            jobs.append(job_details)
    
    return jobs


# BUILD DEGREE SEARCH
def search_degree(soup):
    
    degree_keyword = {
        "data science": False, 
        "computer science": False, 
        "information technology": False,
        "data analytics": False,
        "mathematics": False,
        "economics": False,
        "statistics": False,
        "engineering": False
    }

    degree_pattern = "|".join(re.escape(degree) for degree in degree_keyword)
    compile_degree_pattern = re.compile(degree_pattern, flags=re.IGNORECASE)
    tags = soup.find_all("li")
    for tag in tags:
        degrees = re.findall(compile_degree_pattern, string=tag.get_text())
        for degree in degrees:
            degree_keyword[degree.lower()] = True

    return degree_keyword


# BUILD LANGUAGE SEARCH
def search_language(soup):
    
    language_keyword = {
        "sql": False,
        "mysql": False,
        "python": False,
        "java": False,
        "javascript": False,
        "c++": False,
        "spss": False,
        "stata": False,
        "power bi": False,
        "tableau": False
    }

    language_pattern = "|".join(re.escape(language) for language in language_keyword)
    compile_langugage_pattern = re.compile(language_pattern, flags=re.IGNORECASE)
    tags = soup.find_all("li")
    for tag in tags:
        languages = re.findall(compile_langugage_pattern, string=tag.get_text())
        for language in languages:
            language_keyword[language.lower()] = True
        
    return language_keyword


# BUILD SKILL SEARCH
def search_skill(soup):

    keyword_skills = {
        "data analysis": False,
        "statistical analysis": False,
        "statistics": False,
        "regression analysis": False,
        "time series analysis": False,
        "machine learning": False,
        "supervised learning": False,
        "unsupervised learning": False,
        "deep learning": False,
        "neural networks": False,
        "natural language processing": False,
        "sentiment analysis": False,
        "decision trees": False,
        "random forest": False,
        "k-nearest neighbors": False,
        "linear regression": False,
        "logistic regression": False,
        "clustering": False,
        "data mining": False,
        "data visualization": False,
        "data wrangling": False,
        "data cleaning": False,
        "data transformation": False,
        "data governance": False,
        "data warehousing": False,
        "exploratory data analysis": False,
        "big data analytics": False,
        "nosql database": False,
        "business intelligence": False
    }

    skill_pattern = "|".join(re.escape(skill) for skill in keyword_skills)
    compile_skill_pattern = re.compile(skill_pattern, flags=re.IGNORECASE)
    tags = soup.find_all("li")
    for tag in tags:
        skills = re.findall(compile_skill_pattern, string=tag.get_text())
        for skill in skills:
            keyword_skills[skill.lower()] = True
    
    return keyword_skills


def main():

    d = datetime.date.today().strftime("%d%m%y")
    counter = 0
    
    df_degree = pd.DataFrame()
    df_language = pd.DataFrame()
    df_skill = pd.DataFrame()
    headers = ({"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0"})
    # READ WEBSCRAPER DATA
    jobs = read_webscraper_data(d)
    max_len = len(jobs)
    # PULL WEBSITES FROM WEBSCRAPER DATA
    for no in range(1, max_len):

        # EXTRACT DATA FROM INDIVIDUAL SITES
        try:
            r = requests.get(jobs[no]["website"], headers, timeout=5)
        except HTTPError:
            print("Error: Invalid URL")
        except TimeoutError:
            print("Error: Timeout")

        soup = BeautifulSoup(r.content, "lxml")
        degree_dict = search_degree(soup)
        language_dict = search_language(soup)
        skill_dict = search_skill(soup)

        # FIND DEGREE REQUIREMENTS
        degree_requirements = jobs[no].copy()
        degree_requirements.update(degree_dict)
        df_degree = pd.concat([df_degree, pd.DataFrame([degree_requirements])], ignore_index=True)

        # FIND LANGAUGE REQUIREMENTS
        language_requirements = jobs[no].copy()
        language_requirements.update(language_dict)
        df_language = pd.concat([df_language, pd.DataFrame([language_requirements])], ignore_index=True)

        # FIND SKILL REQUIREMENTS
        skill_requirements = jobs[no].copy()
        skill_requirements.update(skill_dict)
        df_skill = pd.concat([df_skill, pd.DataFrame([skill_requirements])], ignore_index=True)

        counter += 1
        print(f"{(counter/max_len)*100:0.2f}%")

    df_degree.to_csv(f"./all/job_info_degrees_{d}.csv", index=False, sep=";")
    df_language.to_csv(f"./all/job_info_languages_{d}.csv", index=False, sep=";")
    df_skill.to_csv(f"./all/job_info_skills_{d}.csv", index=False, sep=";")


if __name__ == "__main__":
    main()