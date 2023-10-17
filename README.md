# Data Analytics: Bellabeat Fitness Company

#### Author: Rakha Wisnu Bagaskara
#### Date: 23 Sept, 2023
#### [Tableau Dashboard](https://public.tableau.com/shared/W4YXW3HJ8?:display_count=n&:origin=viz_share_link)

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
### 🔑 Key tasks
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
![Daily Activity Record During a Weeks](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/0629fca7-74d3-4c71-a841-c4b8af2f7e4b)
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
![dailyAnalysis_summary](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/f69c0dbe-2ce6-4f48-8c0a-b9382a34ae24)<br>
Total Steps and Calories burn in a weekday shows in below fig. Bar chart shows that total step and calories tends to go down on Tuesday until saturday. 
```
ggplot(data = dailyActivity, aes(x = Weekday, y = TotalSteps)) + 
  geom_bar(fill="#16213D", stat = "identity") +
  labs(title = "Total Steps on a Weekday")

ggplot(data = dailyActivity, aes(x = Weekday, y = Calories)) +
  geom_bar(fill = "#3D989B", stat = "identity") +
  labs(title = "Weekday vs Calories")
```
![TS+C](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/9e9836a0-05ff-46ee-b9db-732c8b8f5328)
Percentation of user activity minutes seperate into Very Active, Fairly Active, Lightly Active, and Sedentary. Sedentary minutes give the most higher percentage in total activity minutes with 79.41%.
```
ActMinPer <- data.frame(
  Level = c("Very Active", "Fairly", "Light", "Sedentary"),
  Value = c(veryMinPer, fairMinPer, lightMinPer, sedenMinPer))

plot_ly(ActMinPer, labels = ~Level, values = ~Value, type = "pie", 
        textposition = "outside", textinfo = "label+percent", 
        marker=list(colors=c("#4ADEDE", "#797EF6", "#1AA7EC","#1E2F97"),
                    line = list(color = '#FFFFFF', width = 2))) %>%
  layout(title = "Activity Level Minutes Percentage",
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
```
![actPer](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/db95dcc8-4f41-443b-931e-e32266cd4369)

### Analysis on Sleep Day and Weight Log
Analysis on sleep record and total minutes asleep. The bar chart shows total minutes asleep have a directly proportional to total sleep record.<br>
![sleepDay_summary](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/8e951e76-2337-49e8-afba-b809adb5cc77)
```
TSR <- ggplot(data = sleepDay, aes(x = Weekday, y= TotalSleepRecords)) +
  geom_bar(fill = "orange", stat = "identity") +
  labs(title = "Sleep Records in a Week")

TMA <- ggplot(data = sleepDay, aes(x = Weekday, y= TotalMinutesAsleep)) +
  geom_bar(fill = "magenta", stat = "identity") +
  labs(title = "Sleep Minutes in a Week")

ggarrange(TSR, TMA)
```
![TSR+TMA](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/a6810199-8c3d-48c2-95d2-c1ea483eeb9d)
Based on Kasper Salin,, et al research about Changes in Daily Steps and Body Mass Index and Waist to Height Ratio during Four Year Follow-Up in Adults: Cardiovascular Risk in Young Finns Study, Recent studies using objective measurements of PA have found that short term changes in daily steps do not influence body mass index (BMI)[1]. The chart below shows fairly constant values for BMI at all calorie levels and total steps performed by the user.
```
ggplot(dataMerged, aes(x = TotalSteps, y = BMI, color = Calories)) +
  geom_point() +
  geom_smooth(method = "loess", formula = "y ~ x", stat = "smooth") +
  scale_color_gradient(low = "blue", high = "green")
```
![TS~BMI](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/ff8709da-7189-4ab9-8709-b50a8a221972)
### Hourly Analysis
The bar chart below shows user total step hourly in a day. User take more step at 8 AM until 10 PM.
```
hourlyStep$Time <- format(as.POSIXct(hourlyStep$Time,format='%I:%M:%S %p'),format="%H")

ggplot(data = hourlyStep, aes(x = Time, y = StepTotal, fill=Time)) + 
  geom_bar(stat="identity") +
  labs(title = "Step in a day", x = "Hour", y = "Total Step")
```
![HourlyStep](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/b190ba22-4842-4173-a9f2-8120ab3e82dd)
### Interesting Insight
Total Steps as independent variable and Calories as dependent variable produce a fairly linear graph. It means that total step from user in a daily directly proportional to calories burned. However, total minutes of activity showed no relationship with calories burned. This could be due to the total minutes used representing 79% sedentary activity.
```
ggplot(data = dailyActivity, aes(x = TotalSteps, y = Calories, color = TotalActivityMinutes)) + 
  stat_smooth(method = lm) +
  geom_point() +
  scale_color_gradient(low = "red", high = "blue") +
  labs(title = "Total Steps vs Calories", x = "Total Step", y = "Calories")
```
![TotalStepsVSCalories](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/c8b365d9-35a4-4c95-b3ef-001767cfe963)
lm is used to fit linear models. It can be used to carry out regression, single stratum analysis of variance and analysis of covariance[2]. We want to know the relationship between 2 variable. In this case, we looking for R-Squared value from calories and activity minutes. The result shown below with R-Squared value is 0.0164. it can be said, the two variables do not have a linear relationship. In the figure it can also be seen that the distribution of data at each point where activity minutes vary does not show a linear relationship with calories, but rather the total steps taken by the user.
```
calories_vs_actMin <- lm(Calories ~ TotalActivityMinutes, data = dailyActivity)
summary(calories_vs_actMin)
```
![lm(Cal~ActMin)](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/262c9f30-f726-4700-941a-b26bbe0482ba)

The graph below shows the relationship of calories burned in various activity minutes. Majority the data obtained is from users with calories used in the range of 1500 cal to 3500 cal. According to the article by NHS UK, an ideal daily intake of calories varies depending on age, metabolism and levels of physical activity, among other things. Generally, the recommended daily calorie intake is 2,000 calories a day for women and 2,500 for men [3]. Users in the dataset also spend activity time in the range of 7 to 15 hours. At calories over 3500, the graph shows an increase in fairly active and very active, while a decrease in sedentary minutes. This shows that more calories are used or burned in users who do more activities in fairly active or very active and less in sedentary minutes.
![CaloriesVSActivityAll](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/fa17216b-4dfd-4dc2-b630-208c719e83b0)

This graph shows the relationship between the total steps taken by the user and the total activity minutes at each activity level. The graph covers total steps taken from 0 to ±17000. The data is spread across total steps for activity minutes. Users spent a total of 600 to 1200 minutes in sedentary minutes. In addition, users also spent 1 to 2 hours on fairly active or very active minutes.
![TotalStepsVSActivityMinAll](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/7e4b3b54-a634-40c4-8731-339a797329aa)

```
ggplot(data = sleepDay, aes(x = TotalTimeInBed, y =TotalMinutesAsleep)) + 
  geom_point(alpha = 0.50) +
  geom_smooth(method = "loess", formula = "y ~ x", stat = "smooth") +
  labs(title = "Time in Bed vs Minute Asleep", x = "Total Time in Bed", y = "Total Minutes Asleep")
```
![TimeInBedVSMinutesAsleep](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/b6eb2fac-68cb-47bd-a987-4e58d51f3944)
```
minSleep_vs_minBed <- lm(TotalMinutesAsleep ~ TotalTimeInBed, data = dataMerged)
summary(minSleep_vs_minBed)
```
![lm(TMA~TIB)](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/274fd20c-5c8b-45bb-95ef-bb75ef80e512)

## [5] Share
### Tableau Dashboard 
![image](https://github.com/BagaskaraRW/Data_Analytics_Bellabeat_Fitness_Company/assets/126551095/86f2068b-3cd1-46e3-9f0e-70fa6dc6a700)
Link: [Tableau Dashboard](https://public.tableau.com/shared/W4YXW3HJ8?:display_count=n&:origin=viz_share_link).
## [6] Act



