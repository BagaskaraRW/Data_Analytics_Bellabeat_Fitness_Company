#Install All Packages for analysis requirement
install.packages("tidyverse")
install.packages("skimr")
install.packages("cowplot")
install.packages("ggpubr")
install.packages("plotly")

#Load all packages for analysis
library(tidyverse)
library(dplyr)
library(lubridate)
library(readr)
library(ggplot2)
library(ggpubr)
library(skimr)
library(cowplot)
library(plotly)

                          ### Preparing and Clearing ###
#================================================================================
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

#=========================================================================
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

#==========================================================================
#Get summary of dailyActivity, sleepDay, and WeightLog
summary(dailyActivity)
summary(sleepDay)
summary(weightLog)
summary(hourlyStep)

#==========================================================================
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
summary(dataMerged)

write_csv(dataMerged, "E:/Universitas Gadjah Mada/Course/Coursera/Google Data Analyst/Course 8/dataMerged.csv")
print("CSV file written Successfully :)")

#Record during a weeks
ggplot(data = dataMerged, aes(x = Weekday)) + 
  geom_bar(fill = "#3D989B") +
  labs(title = "Daily Activity Record During a Weeks", y = "Record Count")

ggplot(data = dataMerged, aes(x = Weekday, y = TotalSleepRecords)) +
  geom_bar(fill = "#16213D", stat = "identity") +
  labs(title = "Record of Total Sleep in a Week")

ggplot(data = dataMerged, aes(x = Weekday, y = TotalMinutesAsleep)) +
  geom_bar(fill = "#FFD335", stat = "identity") +
  labs(title = "Record of Total Sleep Minutes in a Week")


                            ### Analysis ###
#==========================================================================
## Analysis Daily Activity ##
#Add new column for the weekdays
dailyActivity <- dailyActivity %>%
  mutate(Weekday = weekdays(as.Date(ActivityDate, "%m/%d/%Y")))%>%
  mutate(TotalActivityMinutes = dailyActivity$VeryActiveMinutes +
           dailyActivity$FairlyActiveMinutes +
           dailyActivity$LightlyActiveMinutes +
           dailyActivity$SedentaryMinutes)
head(dailyActivity)

dailyActivity$Weekday <- factor(dailyActivity$Weekday, 
                                levels= c("Monday", "Tuesday", 
                                          "Wednesday", "Thursday", 
                                          "Friday", "Saturday", "Sunday"))

## Daily Activity Statistic Summary ##
dailyActivity %>%
  dplyr::select(Weekday, TotalSteps,
                TotalDistance, VeryActiveMinutes,
                FairlyActiveMinutes, LightlyActiveMinutes,
                SedentaryMinutes, TotalActivityMinutes, Calories) %>%
  summary()

TSPlot <- ggplot(data = dailyActivity, aes(x = Weekday, y = TotalSteps)) + 
  geom_bar(fill="#16213D", stat = "identity") +
  labs(title = "Total Steps on a Weekday")

CPlot <- ggplot(data = dailyActivity, aes(x = Weekday, y = Calories)) +
  geom_bar(fill = "#3D989B", stat = "identity") +
  labs(title = "Weekday vs Calories")

ggarrange(TSPlot, CPlot)

ggplot(data = dailyActivity, aes(x = Weekday, y = TotalActivityMinutes)) +
  geom_bar(fill = "#FFD335", stat = "identity") +
  labs(title = "Weekday vs Activity Minutes")

ggplot(data = dailyActivity, aes(x = TotalSteps, y = Calories, color = TotalActivityMinutes)) + 
  stat_smooth(method = lm) +
  geom_point() +
  scale_color_gradient(low = "red", high = "blue") +
  labs(title = "Total Steps vs Calories", x = "Total Step", y = "Calories")

totalActMin <- sum(dailyActivity$TotalActivityMinutes)
veryActMin <- sum(dailyActivity$VeryActiveMinutes)
fairActMin <- sum(dailyActivity$FairlyActiveMinutes)
lightActMin <- sum(dailyActivity$LightlyActiveMinutes)
sedenActMin <- sum(dailyActivity$SedentaryMinutes)

veryMinPer <- (veryActMin/totalActMin)*100
fairMinPer <- (fairActMin/totalActMin)*100
lightMinPer <- (lightActMin/totalActMin)*100
sedenMinPer <- (sedenActMin/totalActMin)*100

vP <- formatC(veryMinPer, digits = 2, format = "f")
fP <- formatC(fairMinPer, digits = 2, format = "f")
lP <- formatC(lightMinPer, digits = 2, format = "f")
sP <- formatC(sedenMinPer, digits = 2, format = "f")

print(paste("Very Active Minutes Percentage:",vP,"%"))
print(paste("Fairly Active Minutes Percentage:",fP,"%"))
print(paste("Light Active Minutes Percentage:",lP,"%"))
print(paste("Sedentary Active Minutes Percentage:",sP,"%"))

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

## Analysis Sleep Day ##
#Add new column for the weekdays
sleepDay <- sleepDay %>%
  mutate(Weekday = weekdays(as.Date(ActivityDate, "%m/%d/%Y")))

sleepDay$Weekday <- factor(sleepDay$Weekday, 
                                levels= c("Monday", "Tuesday", 
                                          "Wednesday", "Thursday", 
                                          "Friday", "Saturday", "Sunday"))

#Sleep Day Statistic Summary
sleepDay %>%
  dplyr::select(TotalSleepRecords,
                TotalMinutesAsleep,
                TotalTimeInBed) %>%
  summary()

TSR <- ggplot(data = sleepDay, aes(x = Weekday, y= TotalSleepRecords)) +
  geom_bar(fill = "orange", stat = "identity") +
  labs(title = "Sleep Records in a Week")

TMA <- ggplot(data = sleepDay, aes(x = Weekday, y= TotalMinutesAsleep)) +
  geom_bar(fill = "magenta", stat = "identity") +
  labs(title = "Sleep Minutes in a Week")

ggarrange(TSR, TMA)

ggplot(data = sleepDay, aes(x = TotalTimeInBed, y =TotalMinutesAsleep)) + 
  geom_point(alpha = 0.50) +
  geom_smooth(method = "loess", formula = "y ~ x", stat = "smooth") +
  labs(title = "Time in Bed vs Minute Asleep", x = "Total Time in Bed", y = "Total Minutes Asleep")

## Analysis Weight Log ##
#Add new column for the weekdays
weightLog <- weightLog %>%
  mutate(Weekday = weekdays(as.Date(ActivityDate, "%m/%d/%Y")))

weightLog$Weekday <- factor(weightLog$Weekday, 
                           levels= c("Monday", "Tuesday", 
                                     "Wednesday", "Thursday", 
                                     "Friday", "Saturday", "Sunday"))

#Weight Log Statistic Summary
weightLog %>%
  dplyr::select(WeightPounds, 
                BMI) %>%
  summary()

head(weightLog)

ggplot(dataMerged, aes(x = TotalSteps, y = BMI, color = Calories)) +
  geom_point() +
  geom_smooth(method = "loess", formula = "y ~ x", stat = "smooth") +
  #scale_color_gradient(low = "blue", high = "green") +
  labs(title = "Total Steps vs BMI", x = "Total Step", y = "Body Mass Index")

## Hourly Analysis ##
n_distinct(hourlyStep$Id)

#hourlyStep$Time <- format(as.POSIXct(hourlyStep$Time,format='%I:%M:%S %p'),format="%H")
head(hourlyStep)

ggplot(data = hourlyStep, aes(x = Time, y = StepTotal, fill=Time)) + 
  geom_bar(stat="identity") +
  labs(title = "Step in a day", x = "Hour", y = "Total Step")

dataMergedHour <- merge(dataMerged, hourlyStep, by = c("Id"), all=TRUE)
write_csv(dataMergedHour, "dataMergedHour.csv")

#==========================================================================
## Correlation (Regression) Analysis of Variable ##
#We're looking for R-Square value with lm() method

step_vs_sedentaryMin <- lm(SedentaryMinutes ~ TotalSteps, data = dataMerged)
summary(step_vs_sedentaryMin)

step_vs_calories <- lm(Calories ~ TotalSteps, data = dataMerged)
summary(step_vs_calories)

calories_vs_actMin <- lm(Calories ~ TotalActivityMinutes, data = dailyActivity)
summary(calories_vs_actMin)

step_vs_actMin <- lm(TotalSteps ~ TotalActivityMinutes, data = dailyActivity)
summary(step_vs_actMin)

minSleep_vs_minBed <- lm(TotalMinutesAsleep ~ TotalTimeInBed, data = dataMerged)
summary(minSleep_vs_minBed)

#==========================================================================
## Collective Plot Analysis ##

colors <- c("SedentaryMinutes" = "red", "LightlyActiveMinutes" = "yellow",
            "FairlyActiveMinutes" = "green", "VeryActiveMinutes" = "blue")

#Corelation between Activity Minutes and Calories
ActivityMinutes_vs_Calories <- ggplot(data = dailyActivity) +
  geom_point(mapping = aes(x = Calories, y = SedentaryMinutes, color = "SedentaryMinutes"), alpha = 0.5) +
  geom_point(mapping = aes(x = Calories, y = LightlyActiveMinutes, color = "LightlyActiveMinutes"), alpha = 0.5) +
  geom_point(mapping = aes(x = Calories, y = FairlyActiveMinutes, color = "FairlyActiveMinutes"), alpha = 0.5) +
  geom_point(mapping = aes(x = Calories, y = VeryActiveMinutes,color = "VeryActiveMinutes"), alpha =  0.5) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = Calories, y = SedentaryMinutes, 
                                                           color = "SedentaryMinutes")) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = Calories, y = LightlyActiveMinutes,
                                                           color = "LightlyActiveMinutes")) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = Calories, y = FairlyActiveMinutes,
                                                           color = "FairlyActiveMinutes")) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = Calories, y = VeryActiveMinutes, 
                                                           color = "VeryActiveMinutes")) +
  labs(x = "Calories", 
       y = "Active Minutes", 
       title = "Calories vs Activity Minutes",
       color = "Legend") +
  scale_color_manual(values = colors)

ActivityMinutes_vs_Calories

#Corelation between Activity Minutes and Total Step
ActivityMinutes_vs_TotalStep <- ggplot(data = dailyActivity) +
  geom_point(mapping = aes(x = TotalSteps, y = SedentaryMinutes, color = "SedentaryMinutes"), alpha = 0.5) +
  geom_point(mapping = aes(x = TotalSteps, y = LightlyActiveMinutes, color = "LightlyActiveMinutes"), alpha = 0.5) +
  geom_point(mapping = aes(x = TotalSteps, y = FairlyActiveMinutes, color = "FairlyActiveMinutes"), alpha = 0.5) +
  geom_point(mapping = aes(x = TotalSteps, y = VeryActiveMinutes, color = "VeryActiveMinutes"), alpha = 0.5) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = TotalSteps, y = SedentaryMinutes,
                                                           color = "SedentaryMinutes")) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = TotalSteps, y = LightlyActiveMinutes,
                                                           color = "LightlyActiveMinutes")) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = TotalSteps, y = FairlyActiveMinutes,
                                                           color = "FairlyActiveMinutes")) +
  geom_smooth(method = loess, formula = y~x, mapping = aes(x = TotalSteps, y = VeryActiveMinutes,
                                                           color = "VeryActiveMinutes")) +
  labs(x = "Total Steps", 
       y = "Active Minutes", 
       title = "Total Steps vs Activity Minutes",
       color = "Legend") +
  scale_color_manual(values = colors)

ActivityMinutes_vs_TotalStep