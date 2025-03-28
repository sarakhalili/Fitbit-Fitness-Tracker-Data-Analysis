# Install the tidyverse package
install.packages("tidyverse")
install.packages("reshape2")

# Load the tidyverse package
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)
library(reshape2)

# Importing datasets
daily_activity <- read.csv("dailyActivity_merged.csv")
sleep_day <- read.csv("sleepDay_merged.csv")
weight_log <- read.csv("weightLogInfo_merged.csv")

# Inspect data
print(head(daily_activity))
summary(daily_activity)
print(head(sleep_day))
summary(sleep_day)
print(head(weight_log))
summary(weight_log)

#------------------------------Cleaning------------------------
# Handle missing values
daily_activity <- na.omit(daily_activity)
weight_log <- na.omit(weight_log)
sleep_day <- na.omit(sleep_day)

# Remove duplicates
daily_activity <- daily_activity %>% distinct()
sleep_day <- sleep_day %>% distinct()
weight_log <- weight_log %>% distinct()

# Ensure correct data types
daily_activity$ActivityDate=as.POSIXct(daily_activity$ActivityDate, format="%m/%d/%Y", tz=Sys.timezone())
daily_activity$date <- format(daily_activity$ActivityDate, format = "%m/%d/%y")
sleep_day$SleepDay=as.POSIXct(sleep_day$SleepDay, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
sleep_day$date <- format(sleep_day$SleepDay, format = "%m/%d/%y")
weight_log$Date=as.POSIXct(weight_log$Date, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
weight_log$date <- format(weight_log$Date, format = "%m/%d/%y")
weight_log$WeightKg <- as.numeric(weight_log$WeightKg)

#----------------------Data Exploration----------------
# Daily Activity Summary
daily_activity_summary <- daily_activity %>%
  select(TotalSteps, TotalDistance, Calories) %>%
  summary()
print("Daily Activity Summary:")
print(daily_activity_summary)

# Activity levels
daily_activity %>%
  select(VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes,SedentaryMinutes) %>%
  summary()

# Sleep Day Summary
sleep_day_summary <- sleep_day %>%
  select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed) %>%
  summary()
print("Sleep Day Summary:")
print(sleep_day_summary)

# Weight Log Summary
weight_log_summary <- weight_log %>%
  select(WeightKg, BMI) %>%
  summary()
print("Weight Log Summary:")
print(weight_log_summary)

#---------------------Visualization--------------------
# Plot for TotalSteps vs Calories
p1 <- ggplot(daily_activity, aes(x = TotalSteps, y = Calories)) +
  geom_point(alpha = 0.4, color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Total Steps Vs Calories Burned",
       x = "Total Steps",
       y = "Calories Burned") +
  theme_minimal()

# Plot for TotalDistance vs Calories
p2 <- ggplot(daily_activity, aes(x = TotalDistance, y = Calories)) +
  geom_point(alpha = 0.4, color = "green") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Total Distance Vs Calories Burned",
       x = "Total Distance",
       y = "Calories Burned") +
  theme_minimal()

# Display plots
gridExtra::grid.arrange(p1, p2, ncol = 2)

#------
daily_activity %>%
  summarise(
    distance = factor(case_when(
      TotalDistance < 4.5 ~ "< 4.5 mi",
      TotalDistance >= 4.5 & TotalDistance <= 7 ~ "4.5 > & < 7 mi",
      TotalDistance > 7 ~ "> 7 mi",
    ),levels = c("> 7 mi","4.5 > & < 7 mi","< 4.5 mi")),
    steps = factor(case_when(
      TotalSteps < 6000 ~ "< 6k steps",
      TotalSteps >= 6000 & TotalSteps <= 10000 ~ "6k > & < 10k Steps",
      TotalSteps > 10000 ~ "> 10k Steps",
    ),levels = c("> 10k Steps","6k > & < 10k Steps","< 6k steps")),
    Calories) %>%
  ggplot(aes(steps,Calories,fill=steps)) +
  geom_boxplot() +
  facet_wrap(~distance)+
  labs(title="Calories burned by Steps and Distance",x=NULL) +
  theme(legend.position="none", text = element_text(size = 20),plot.title = element_text(hjust = 0.5))

#---------user type----------------
data_by_usertype <- daily_activity %>%
  summarise(
    user_type = factor(case_when(
      SedentaryMinutes > mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Sedentary",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes > mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Lightly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes > mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Fairly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes > mean(VeryActiveMinutes) ~ "Very Active",
    ),levels=c("Sedentary", "Lightly Active", "Fairly Active", "Very Active")), Calories, .group=Id) %>%
  drop_na()

# Bar chart
data_by_usertype %>%
  group_by(user_type) %>%
  summarise(total = n()) %>%
  mutate(totals = sum(total)) %>%
  group_by(user_type) %>%
  summarise(total_percent = total / totals) %>%   
  ggplot(aes(user_type,y=total_percent, fill=user_type)) +   # Visualize user types
  geom_col()+
  scale_y_continuous(labels = scales::percent) +
  theme(legend.position="none") +
  labs(title="User type distridution", x=NULL) +
  theme(legend.position="none", text = element_text(size = 20),plot.title = element_text(hjust = 0.5))
#Pie Chart
data_by_usertype %>%
  group_by(user_type) %>%
  summarise(total = n()) %>%
  mutate(totals = sum(total)) %>%
  group_by(user_type) %>%
  summarise(total_percent = total / totals) %>%
  ggplot(aes(x="", y=total_percent, fill=paste(user_type, scales::percent(total_percent)))) +   # Combine user type and percentage for legend
  geom_bar(stat="identity", width=1) +
  coord_polar(theta="y") +
  scale_fill_discrete(name="User Type", labels=function(x) x) +  # Custom label function to keep original labels
  theme_void() +
  labs(title="User Type Distribution") +
  theme(legend.position="right", legend.title = element_text(size=14), legend.text = element_text(size=12), plot.title = element_text(hjust=0.5))

# Box plot
ggplot(data_by_usertype, aes(user_type, Calories, fill=user_type)) +
  geom_boxplot() +
  theme(legend.position="none") +
  labs(title="Calories burned by User type", x=NULL) +
  theme(legend.position="none", text = element_text(size = 20),plot.title = element_text(hjust = 0.5))    


# Plotting Sleep and user type relationship
merged_data <- merge(sleep_day, daily_activity, by=c('Id', 'date'))
head(merged_data)

sleepType_by_userType <- merged_data %>%
  group_by(Id) %>%
  summarise(
    user_type = factor(case_when(
      SedentaryMinutes > mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Sedentary",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes > mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Lightly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes > mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Fairly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes > mean(VeryActiveMinutes) ~ "Very Active",
    ),levels=c("Sedentary", "Lightly Active", "Fairly Active", "Very Active")),
    sleep_type = factor(case_when(
      mean(TotalMinutesAsleep) < 360 ~ "Bad Sleep",
      mean(TotalMinutesAsleep) > 360 & mean(TotalMinutesAsleep) <= 480 ~ "Normal Sleep",
      mean(TotalMinutesAsleep) > 480 ~ "Over Sleep",
    ),levels=c("Bad Sleep", "Normal Sleep", "Over Sleep")), total_sleep = sum(TotalMinutesAsleep) ,.groups="drop"
  ) %>%
  drop_na() %>%
  group_by(user_type) %>%
  summarise(bad_sleepers = sum(sleep_type == "Bad Sleep"), normal_sleepers = sum(sleep_type == "Normal Sleep"),over_sleepers = sum(sleep_type == "Over Sleep"),total=n(),.groups="drop") %>%
  group_by(user_type) %>%
  summarise(
    bad_sleepers = bad_sleepers / total, 
    normal_sleepers = normal_sleepers / total, 
    over_sleepers = over_sleepers / total,
    .groups="drop"
  )

#Now we can plot the data for each user type:
sleepType_by_userType_melted<- melt(sleepType_by_userType, id.vars = "user_type")

ggplot(sleepType_by_userType_melted, aes(user_type, value, fill = variable)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_y_continuous(labels = scales::percent) +
  labs(x=NULL, fill="Sleep type") + 
  theme(legend.position="bottom",text = element_text(size = 20),plot.title = element_text(hjust = 0.5))


