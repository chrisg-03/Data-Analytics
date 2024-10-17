# Cyclistic - A Google Case Study

### Brief Summary
>Cyclistic, a bike-share company based in Chicago, operates a bike sharing initiative with over 5,800 bicycles and 600 docking stations. The bikes can be unlocked from one station and returned to any other station within the system at any time.<br>
To build general awareness and appeal to a broad range of consumers, Cyclistic employed a marketing strategy that focused on flexible pricing plans, including single-ride passes, full-day passes, and annual memberships. Casual riders are those who purchase single-ride or full-day passes. They constitute a significant portion of Cyclistic users, who predominantly use the bikes for leisure rides. While customers opting for annual memberships are referred to as Cyclistic members. Interestingly, around 30% of users utilize the bikes for daily commutes to work.<br>
The director of marketing at Cyclistic emphasizes that the company's future success hinges on maximizing the number of annual memberships. Thus, we are tasked with finding out how we can achieve greater membership subscriptions
>* Three questions will guide the future marketing program:
>* 1. How do annual members and casual riders use Cyclistic bikes differently?
>* 2. Why would casual riders buy Cyclistic annual memberships?
>* 3. How can Cyclistic use digital media to influence casual riders to become members?

### Suggestions
> #### Targeted Promotional Campaigns
>- **Leverage Peak Times:** Casual riders are most active on weekends and during the late afternoon, between 3 pm and 6 pm. Cyclistic can capitalize on this by running targeted promotions during these times, offering discounts or incentives for signing up for >annual memberships.
>- **Seasonal Campaigns:** Casual riders are more active during the summer and fall seasons. Cyclistic can introduce limited-time membership offers during this period, focusing on the convenience and cost benefits of an annual subscription compared to frequent >single-ride purchases.
>
> #### Promotions at Key Locations
>- **Location based campaigns**: Cyclistic should concentrate its marketing efforts at popular tourist and leisure spots where casual riders frequent, such as parks and landmarks. On-site promotions, such as QR codes for special discounts on memberships, >could encourage spontaneous sign-ups.
>
> #### Personalized Offers via Digital Media
>- **Social Media Advertising**: Utilize geotargeted ads on platforms like Instagram, Facebook, and Google, focusing on areas with high casual rider activity. Personalized ads promoting the benefits of an annual membership can be shown to users who have >previously purchased single-ride or day passes, highlighting the long-term savings and added convenience.
> ### Gamification and Rewards Programs
>- **Gamification:** Introduce a points or rewards system for casual riders, where frequent riders can earn credits or discounts towards an annual membership based on the number of rides taken. This gamification strategy can motivate casual riders to consider long-term >membership.

### Data Cleaning
> Tasks Performed in Jupyter Notebooks:
>* 1. Remove duplicated primary key `ride_id`
>* 2. Convert object/str datatypes to datetime and add column `total_seconds` for easier analysis
>* 3. Remove `ride_length` outliers to improve the mean and skewness of the data; information provided in jupyter notebook file <br><br>
> [Dataset dimensions too large to put into tabels, refer to jupyter notebook file]


### Data Analysis
#### Q1. How do annual members and casual riders use Cyclistic bikes differently?
##### Trends of Cyclistic users <br>

|Members|Trends|Casual|
|:----:|:----:|:----:|
|Weekdays|Day of Travel|Weekend|
|4pm - 6pm|Peak Travel Time|3pm - 6pm|
|Electric bikes, Classic bikes|Rideable Type| Electric bikes, Docked bikes, Classic bikes|
---
#### Q2. Why would casual riders buy Cyclistic annual memberships?
> Once we have spotted why they choose cyclistic bike rentals, we can launch targetted marketing campaigns towards casual riders e.g.
> 1. Timing - Promotions during weekends, more campaigns between May and September to coincide with summer and fall seasons
> 2. Place - Better pricing/Better convenience/Promotions around popular areas for casual rides i.e. popular landmarks/ parks
---
#### Q3. How can Cyclistic use digital media to influence casual riders to become members?
> We have already established who our target audience are and their bike rental trends. Launching ads targeted to that demographic would improve visibility to the general public as well <br> 
---
<p>&copy; 2023 Chris G </p>

