-- Condensing the appleStore_description tables into one singular table
Create TABLE appleStore_description_complete as 

Select * from appleStore_description1

UNION ALL

Select * from appleStore_description2

UNION ALL

Select * from appleStore_description3

UNION ALL

Select * from appleStore_description4

** Conducting Exploratory Data Analysis (EDA) **

-- Checking for number of unique applications in both tables

Select Count(distinct id) as UniqueApplicationIDs
from AppleStore

Select Count(distinct id) as UniqueApplicationIDs
from appleStore_description_complete

-- Checking for any missing values in key variables

Select count(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

Select count(*) as MissingValues
from appleStore_description_complete
where app_desc is null 

-- Looking to see the number of applications per genreAppleStore

Select prime_genre, count(*) as NumberOfApps
from AppleStore
group by prime_genre
order by NumberOfApps desc 

-- Overview of the rating distribution of the applications

Select min(user_rating) as MinRating, max(user_rating) as MaxRating, avg(user_rating) as AvgRating
from AppleStore

** Finding Business Insights ** 

-- Looking to see if paid applications on average have a higher or lower user rating

Select case
			when price > 0 Then 'Paid'
            else 'Free'
	end as Application_Type, 
	avg(user_rating) as Average_Rating
from AppleStore
group by Application_Type

-- Looking to see if applications that support more languages on average 
-- have a higher or lower user rating

Select case 
		when lang_num < 10 then '<10 languages'
        when lang_num between 10 and 30 then '10-30 languages'
        else '>30 languages'
      end as LanguageAmount,
      avg(user_rating) as Average_Rating
from AppleStore
group by LanguageAmount
order by Average_Rating desc 

-- Which application genres are users not satisfied with 

Select prime_genre, 
	avg(user_rating) as Average_Rating
from AppleStore
group by prime_genre
order by Average_Rating ASC
limit 10

-- Does the length of the application description have an impact on average user ratings

Select CASE
		when length(b.app_desc) <500 Then 'Short'
        when length(b.app_desc) between 500 and 1000 then 'Medium'
        else 'Long'
     end as App_Description_Length, 
     avg(user_rating) as User_Rating 

from AppleStore as a

join appleStore_description_complete as b 

on a.id = b.id 

group by App_Description_Length
Order by User_Rating DESC 

-- Finding the highest rated application in each genreAppleStore

Select prime_genre, track_name, user_rating

from 
	(SELECT 
     	prime_genre,
     	track_name,
     	user_rating,
     	Rank() OVER(PARTITION BY prime_genre order by user_rating desc, 
                    rating_count_tot desc) as rank
     from AppleStore ) as a 
where a.rank = 1
                    

