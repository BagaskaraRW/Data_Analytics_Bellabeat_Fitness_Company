# Data Analytics: Bellabeat Fitness Company
Capstone Project from Google Data Analytics Course

#### Author: Rakha Wisnu Bagaskara
#### Date: 23 Sept, 2023
#### [Tableau Dashboard]
#### [Presentation]

The analysis of this case study follow by six steps based on Google Data Analytics:
- 💡 [Ask](#1-ask)
- 📝 [Prepare](#2-prepare)
- ⚙️ [Process](#3-process)
- 🔎 [Analyze](#4-analyze)
- 📊 [Share](#5-share)
- ⬆️ [Act](#6-act)
  
## Introduction 
Bellabeat is a High – tech manufacturer of health – focused product for women. Collecting data on activity, sleep, stress, and reproductive health has allowed Bellabeat to empower women with knowledge about their own health and habits. Since it was founded in 2013, Bellabeat has grown rapidly and quickly positioned itself as a tech – driven wellness company for women. Bellabeat has 5 product i.e. Bellabeat App, Leaf, Time, Spring, and Bellabeat Membership. Bellabeat is a successful small company, but they have the potential to become a larger player in the global smart device market. Marketing analyst team have been asked to focus one of Bellabeat’s products and analyze smart device data to gain insight into how consumers are using their smart devices. The insights that we discover will then help guide marketing strategy for the company.

## [1] Ask
### 🔑 Key tasks
1.	Identify the business task
2.	Consider key stakeholders <br>

### Deliverable
A Clear statement of the business task <br>
📃**Business task**: Analyze consumer data for gain insight and recommendations to reveal more opportunities for Bellabeat become a large player in the global smart device market. <br>
Stakeholders: <br>
- Primary: Urska Srsen and Sando Mur as executive members
- Secondary: Bellabeat marketing analytics team

## [2] Prepare
### 🔑 Key tasks
1.	Download data and store it appropriately
2.	Identify how it’s organized
3.	Sort and filter the data
4.	Determine the credibility of the data <br>

### Deliverable
📁**Data Source:** https://www.kaggle.com/arashnic/fitbit. <br> 
The primary stakeholder encourages to use public data that explores smart device users’s daily habits. Fitbit Fitness Tracker Data is a dataset that contains s personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.
The dataset has 18 file in CSV format. Here’s the ROCCC of the data: <br>
- **Reliable** <br>
This data can’t categorize to reliable because there’s no information about the accuracy of the data, margin of error, etc. Dataset contain 30 participants which is the sample size is small and can limit the amount of analysis.
- **Original** <br>
This is not an original dataset. This data contains 30 eligible Fitbit users consented to the submission of personal tracker data via Amazon Mechanical Turk.
- **Comprehensive** <br>
This data have minute-level output for physical activity, heart rate, and sleep monitoring. But, it is not comperehensive because there is no information about the participants demographic, such as age, gender, disease history, etc. It doesn’t showing that data was randomized. If the data is biased, then the analysis will be unfair to all types of people.
- **Current** <br>
The data was collected from 12, March 2016 to 12, May 2016. It means the data currently outdated.
- **Cited** <br>
Unknown.

## [3] Process
### 🔑 Key tasks
1.	Check the data for errors.
2.	Choose your tools
3.	Transform the data so you can work it effectively
4.	Document the cleaning process <br>

### Deliverable
📷**Documentation:** any cleaning or manipulation of data <br>
Prepare the environment (install) and load all library for data analysis.
```
#Install All Packages for analysis requirement
install.packages("tidyverse")
install.packages("skimr")
install.packages("cowplot")
install.packages("plotly")

#Load all packages for analysis
library(tidyverse)
library(dplyr)
library(lubridate)
library(readr)
library(ggplot2)
library(skimr)
library(cowplot)
library(plotly)
```
Set path dataset, and load all main dataset for analysis and check header.
```
#Set path data
setwd("E:/Universitas Gadjah Mada/Course/Coursera/Google Data Analyst/Course 8/CapstoneDataFromQuery/MsExcel")

#Load dataset for preparing data
#In this analysis, 4 dataset has choosen i.e. Daily Activity, Sleep Day, Weight Log, Hourly Step
dailyActivity <- read.csv("Bellabeat Company - dailyActivity_merged.csv")
sleepDay <- read.csv("Bellabeat Company - sleepDay_merged.csv")
weightLog <- read.csv("Bellabeat Company - weightLogInfo_merged.csv")
hourlyStep <- read.csv("Bellabeat Company - hourlySteps_merged.csv")

#Check the header of data
head(dailyActivity)
head(sleepDay)
head(weightLog)
head(hourlyStep)
```
Checking NA value and duplicat row. Remove duplicated values from dataset for 4 table i.e. dailyActivity, sleepDay, weightLog, and hourlyStep.
```
#Check the missing value
sum(is.na(dailyActivity))
sum(is.na(sleepDay))
sum(is.na(weightLog))
sum(is.na(hourlyStep))

#Check and remove the the duplicate value
sum(duplicated(dailyActivity))
sum(duplicated(sleepDay))
sum(duplicated(weightLog))
sleepDay <- sleepDay[!duplicated(sleepDay), ]
sum(duplicated(sleepDay))
```
## [4] Analyze
### Key tasks
1.	Aggregate your data so it’s useful and accessible
2.	Organize and format your data
3.	Perform calculations
4.	Identify trends and relationship <br>

### Deliverable
💹**Summary of Analysis** <br>
- [Weekly Record](#weekly-record)
- [Analysis on Daily Activity](#analysis-on-daily-activity)
- [Analysis on Sleep Day and Weight Log](#analysis-on-sleep-day-and-weight-log)
- [Hourly Analysis](#hourly-analysis)
- [Interesting Insight](#interesting-insight)

### Weekly Record
Preparing for merging dataframe. Mergered dataframe contain 3 tables: dailyActivity, sleepDay, and weightLog. The dataframe mergered based on 2 column i.e. Id, and ActivityDate. For checking final dimension of dataframe using ```dim()```. Final dimension of dataframe is 863 row and 27 column. 
```
#Prepared for mergering dataframe

#cek unique ID 
n_distinct(dailyActivity$Id)
n_distinct(sleepDay$Id)
n_distinct(weightLog$Id)

#Changing name of date column in sleep day dataframe
sleepDay <- sleepDay %>%
  rename("ActivityDate" = "Date")

#Changing name of date column in weight log info dataframe
weightLog <- weightLog %>%
  rename("ActivityDate" = "Date")

#Data Merger
dataMerged1 <- merge(dailyActivity, sleepDay, by = c("Id","ActivityDate"), all=TRUE)
dataMerged <- merge(dataMerged1, weightLog, by= c("Id", "ActivityDate"), all=TRUE)
dim(dataMerged)
head(dataMerged)

dataMerged <- dataMerged %>%
  mutate(Weekday = weekdays(as.Date(ActivityDate, "%m/%d/%Y")))

dataMerged$Weekday <- factor(dataMerged$Weekday, 
                                levels= c("Monday", "Tuesday", 
                                          "Wednesday", "Thursday", 
                                          "Friday", "Saturday", "Sunday"))
```
The dataset has 33 user data from dailyActivity, 24 user from sleepDay and only 8 user from weightLog. From using ```ggplot()``` bar graph, we can see how ofter the user record their data in a weeks. <br>
![Daily Activity Record During a Weeks](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/42705e73-5e4a-455f-9228-44392ad6043c)
### Analysis on Daily Activity
Summary on daily activity. We can see the min, mean, max value of each column in Daily Activity dataset. The summary shows that average steps is 8310 step with the max step is more than 4 times avg i.e. 36000> step. Almost 21 hour activity minutes in one day and burn calories with avg 2360 Cal.
```
## Daily Activity Statistic Summary ##
dailyActivity %>%
  dplyr::select(Weekday, TotalSteps,
                TotalDistance, VeryActiveMinutes,
                FairlyActiveMinutes, LightlyActiveMinutes,
                SedentaryMinutes, TotalActivityMinutes, Calories) %>%
  summary()
```
![dailyAnalysis_summary](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/00c807d7-775e-46ac-8b34-a4de0358ec22)
Total Steps and Calories burn in a weekday shows in below fig. 
```
ggplot(data = dailyActivity, aes(x = Weekday, y = TotalSteps)) + 
  geom_bar(fill="#16213D", stat = "identity") +
  labs(title = "Total Steps on a Weekday")

ggplot(data = dailyActivity, aes(x = Weekday, y = Calories)) +
  geom_bar(fill = "#3D989B", stat = "identity") +
  labs(title = "Weekday vs Calories")
```
### Analysis on Sleep Day and Weight Log
### Hourly Analysis
### Interesting Insight
## [5] Share

## [6] Act



