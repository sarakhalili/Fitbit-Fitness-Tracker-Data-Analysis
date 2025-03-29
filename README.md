# Smart Device Usage Analysis for Enhancing Wellness Product Strategy using the “Fitbit Fitness Tracker Dataset”
**Objective:** Analyze smart device usage data to gain insights into how consumers use smart devices and apply these insights to enhance the company’s marketing strategy for one of its products.

### Dataset
The Fitbit Fitness Tracker Dataset represents a detailed collection of fitness and health metrics recorded from thirty consenting Fitbit users over a specified period. Here's an overview of the dataset and its components:

#### Overall Structure

* Daily Data: Includes metrics like total steps, distance traveled, calories burned, and active minutes, compiled daily for each user.
* Hourly Data: Breaks down activity, calories burned, and step count into hourly increments, providing insight into activity patterns throughout the day.
* Minute-level Data: Offers granular detail on steps and heart rate recorded every minute, useful for analyzing intensity and duration of physical activities.
* Sleep Data: Tracks total sleep time, number of awakenings, and time spent in bed, helping to assess sleep quality and patterns.

We will be using the dailyActivity_merged, weightLogInfo_merged, and sleepDay_merged files. 

### Merging
The first step is merging data from the two months which are stored in two different .csv files. To do so, we use BigQuery, and create a new table for each merged file using the following SQL code.
```{SQL}
-- Creating a new table with the combined data from April and March, ordered by ActivityDate
CREATE TABLE `my-project-1-421103.the company.dailyActivity_combined`
AS
SELECT *
FROM 
    `my-project-1-421103.the company.dailyActivity_merged_Apr` AS April
UNION ALL
SELECT *
FROM
    `my-project-1-421103.the company.dailyActivity_merged_Mar` AS March
ORDER BY ActivityDate;
```

### Cleaning the data
For cleaning the data, I handle missing data by using the na.omit syntax, then remove duplicates by using the distinct() function. In the next step, I correct the format of fields to ensure data integrity.


```{r}
##           Id ActivityDate TotalSteps TotalDistance TrackerDistance
## 1 1503960366   04/12/2016      13162          8.50            8.50
## 2 1503960366    4/13/2016      10735          6.97            6.97
## 3 1503960366    4/14/2016      10460          6.74            6.74
## 4 1503960366    4/15/2016       9762          6.28            6.28
## 5 1503960366    4/16/2016      12669          8.16            8.16
## 6 1503960366    4/17/2016       9705          6.48            6.48
##   LoggedActivitiesDistance VeryActiveDistance ModeratelyActiveDistance
## 1                        0               1.88                     0.55
## 2                        0               1.57                     0.69
## 3                        0               2.44                     0.40
## 4                        0               2.14                     1.26
## 5                        0               2.71                     0.41
## 6                        0               3.19                     0.78
##   LightActiveDistance SedentaryActiveDistance VeryActiveMinutes
## 1                6.06                       0                25
## 2                4.71                       0                21
## 3                3.91                       0                30
## 4                2.83                       0                29
## 5                5.04                       0                36
## 6                2.51                       0                38
##   FairlyActiveMinutes LightlyActiveMinutes SedentaryMinutes Calories
## 1                  13                  328              728     1985
## 2                  19                  217              776     1797
## 3                  11                  181             1218     1776
## 4                  34                  209              726     1745
## 5                  10                  221              773     1863
## 6                  20                  164              539     1728
```

```{r}
##        Id            ActivityDate         TotalSteps    TotalDistance   
##  Min.   :1.504e+09   Length:1397        Min.   :    0   Min.   : 0.000  
##  1st Qu.:2.320e+09   Class :character   1st Qu.: 3146   1st Qu.: 2.170  
##  Median :4.445e+09   Mode  :character   Median : 6999   Median : 4.950  
##  Mean   :4.781e+09                      Mean   : 7281   Mean   : 5.219  
##  3rd Qu.:6.962e+09                      3rd Qu.:10544   3rd Qu.: 7.500  
##  Max.   :8.878e+09                      Max.   :36019   Max.   :28.030  
##  TrackerDistance  LoggedActivitiesDistance VeryActiveDistance
##  Min.   : 0.000   Min.   :0.0000           Min.   : 0.000    
##  1st Qu.: 2.160   1st Qu.:0.0000           1st Qu.: 0.000    
##  Median : 4.950   Median :0.0000           Median : 0.100    
##  Mean   : 5.192   Mean   :0.1315           Mean   : 1.397    
##  3rd Qu.: 7.480   3rd Qu.:0.0000           3rd Qu.: 1.830    
##  Max.   :28.030   Max.   :6.7271           Max.   :21.920    
##  ModeratelyActiveDistance LightActiveDistance SedentaryActiveDistance
##  Min.   :0.0000           Min.   : 0.000      Min.   :0.000000       
##  1st Qu.:0.0000           1st Qu.: 1.610      1st Qu.:0.000000       
##  Median :0.2000           Median : 3.240      Median :0.000000       
##  Mean   :0.5385           Mean   : 3.193      Mean   :0.001704       
##  3rd Qu.:0.7700           3rd Qu.: 4.690      3rd Qu.:0.000000       
##  Max.   :6.4800           Max.   :12.510      Max.   :0.110000       
##  VeryActiveMinutes FairlyActiveMinutes LightlyActiveMinutes SedentaryMinutes
##  Min.   :  0.00    Min.   :  0.0       Min.   :  0.0        Min.   :   0.0  
##  1st Qu.:  0.00    1st Qu.:  0.0       1st Qu.:111.0        1st Qu.: 729.0  
##  Median :  2.00    Median :  6.0       Median :195.0        Median :1057.0  
##  Mean   : 19.68    Mean   : 13.4       Mean   :185.4        Mean   : 992.5  
##  3rd Qu.: 30.00    3rd Qu.: 18.0       3rd Qu.:262.0        3rd Qu.:1244.0  
##  Max.   :210.00    Max.   :660.0       Max.   :720.0        Max.   :1440.0  
##     Calories   
##  Min.   :   0  
##  1st Qu.:1799  
##  Median :2114  
##  Mean   :2266  
##  3rd Qu.:2770  
##  Max.   :4900
```

```{r}
##           Id              SleepDay TotalSleepRecords TotalMinutesAsleep
## 1 1503960366 4/12/2016 12:00:00 AM                 1                327
## 2 1503960366 4/13/2016 12:00:00 AM                 2                384
## 3 1503960366 4/15/2016 12:00:00 AM                 1                412
## 4 1503960366 4/16/2016 12:00:00 AM                 2                340
## 5 1503960366 4/17/2016 12:00:00 AM                 1                700
## 6 1503960366 4/19/2016 12:00:00 AM                 1                304
##   TotalTimeInBed
## 1            346
## 2            407
## 3            442
## 4            367
## 5            712
## 6            320
```

```{r}
##        Id              SleepDay         TotalSleepRecords TotalMinutesAsleep
##  Min.   :1.504e+09   Length:413         Min.   :1.000     Min.   : 58.0     
##  1st Qu.:3.977e+09   Class :character   1st Qu.:1.000     1st Qu.:361.0     
##  Median :4.703e+09   Mode  :character   Median :1.000     Median :433.0     
##  Mean   :5.001e+09                      Mean   :1.119     Mean   :419.5     
##  3rd Qu.:6.962e+09                      3rd Qu.:1.000     3rd Qu.:490.0     
##  Max.   :8.792e+09                      Max.   :3.000     Max.   :796.0     
##  TotalTimeInBed 
##  Min.   : 61.0  
##  1st Qu.:403.0  
##  Median :463.0  
##  Mean   :458.6  
##  3rd Qu.:526.0  
##  Max.   :961.0
```


```{r}
##           Id                  Date WeightKg WeightPounds Fat   BMI
## 1 1503960366      05/02/2016 23:59     52.6     115.9631  22 22.65
## 2 1503960366      05/03/2016 23:59     52.6     115.9631  NA 22.65
## 3 1927972279  4/13/2016 1:08:52 AM    133.5     294.3171  NA 47.54
## 4 2873212765 4/21/2016 11:59:59 PM     56.7     125.0021  NA 21.45
## 5 2873212765      05/12/2016 23:59     57.3     126.3249  NA 21.69
## 6 4319703577 4/17/2016 11:59:59 PM     72.4     159.6147  25 27.45
##   IsManualReport       LogId
## 1           TRUE 1.46223e+12
## 2           TRUE 1.46232e+12
## 3          FALSE 1.46051e+12
## 4           TRUE 1.46128e+12
## 5           TRUE 1.46310e+12
## 6           TRUE 1.46094e+12
```

```{r}
##        Id                Date              WeightKg      WeightPounds  
##  Min.   :1.504e+09   Length:100         Min.   : 52.6   Min.   :116.0  
##  1st Qu.:6.962e+09   Class :character   1st Qu.: 61.5   1st Qu.:135.6  
##  Median :6.962e+09   Mode  :character   Median : 62.5   Median :137.8  
##  Mean   :6.834e+09                      Mean   : 72.5   Mean   :159.8  
##  3rd Qu.:8.878e+09                      3rd Qu.: 85.3   3rd Qu.:188.1  
##  Max.   :8.878e+09                      Max.   :133.5   Max.   :294.3  
##                                                                        
##       Fat             BMI        IsManualReport      LogId          
##  Min.   :10.00   Min.   :21.45   Mode :logical   Min.   :1.459e+12  
##  1st Qu.:19.00   1st Qu.:24.00   FALSE:36        1st Qu.:1.460e+12  
##  Median :22.00   Median :24.39   TRUE :64        Median :1.461e+12  
##  Mean   :19.75   Mean   :25.37                   Mean   :1.461e+12  
##  3rd Qu.:22.75   3rd Qu.:25.59                   3rd Qu.:1.462e+12  
##  Max.   :25.00   Max.   :47.54                   Max.   :1.463e+12  
##  NA's   :96
```

```{r}
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
```

## Analyze
During the analysis phase, I begin by examining the dataset through summaries of each table's fields, providing insights into the variables present. Following this initial exploration, I employ these variables in creating visualizations to better understand the data distributions and relationships.

```{r}
##    TotalSteps    TotalDistance       Calories   
##  Min.   :    0   Min.   : 0.000   Min.   :   0  
##  1st Qu.: 3146   1st Qu.: 2.170   1st Qu.:1799  
##  Median : 6999   Median : 4.950   Median :2114  
##  Mean   : 7281   Mean   : 5.219   Mean   :2266  
##  3rd Qu.:10544   3rd Qu.: 7.500   3rd Qu.:2770  
##  Max.   :36019   Max.   :28.030   Max.   :4900
```

```{r}
##  VeryActiveMinutes FairlyActiveMinutes LightlyActiveMinutes SedentaryMinutes
##  Min.   :  0.00    Min.   :  0.0       Min.   :  0.0        Min.   :   0.0  
##  1st Qu.:  0.00    1st Qu.:  0.0       1st Qu.:111.0        1st Qu.: 729.0  
##  Median :  2.00    Median :  6.0       Median :195.0        Median :1057.0  
##  Mean   : 19.68    Mean   : 13.4       Mean   :185.4        Mean   : 992.5  
##  3rd Qu.: 30.00    3rd Qu.: 18.0       3rd Qu.:262.0        3rd Qu.:1244.0  
##  Max.   :210.00    Max.   :660.0       Max.   :720.0        Max.   :1440.0
```

```{r}
##  TotalSleepRecords TotalMinutesAsleep TotalTimeInBed 
##  Min.   :1.00      Min.   : 58.0      Min.   : 61.0  
##  1st Qu.:1.00      1st Qu.:361.0      1st Qu.:403.8  
##  Median :1.00      Median :432.5      Median :463.0  
##  Mean   :1.12      Mean   :419.2      Mean   :458.5  
##  3rd Qu.:1.00      3rd Qu.:490.0      3rd Qu.:526.0  
##  Max.   :3.00      Max.   :796.0      Max.   :961.0
```

```{r}
##     WeightKg          BMI       
##  Min.   :52.60   Min.   :22.65  
##  1st Qu.:53.12   1st Qu.:22.89  
##  Median :58.35   Median :23.87  
##  Mean   :60.42   Mean   :24.46  
##  3rd Qu.:65.65   3rd Qu.:25.44  
##  Max.   :72.40   Max.   :27.45
```

#### Some interesting findings from exploring the data summaries:

1. The average daily step count among participants is 7,281, which is slightly below the threshold suggested for health benefits. According to research by the CDC, taking at least 8,000 steps daily is associated with a 51% reduction in mortality risk for all causes. 
2. The average sedentary time for participants is notably high at 992.5 minutes, or approximately 16 hours per day. This duration significantly exceeds healthy activity levels and suggests a need for interventions to decrease sedentary time.
3. Participants typically sleep once per day for an average duration of 7 hours. This aligns well with general sleep recommendations for adults.

## Visualization
Here, I employ the ggplot() function to visualize relationships between variables and identify critical trends within the data.
### Relationship Between Total Steps and Calories Burned

![image](https://github.com/user-attachments/assets/78617c6c-3aca-4c4a-a18e-ddfee668e1b2)

![image](https://github.com/user-attachments/assets/ecc95c3a-3006-493e-8622-721f97443be6)

  
#### Analysis:
The scatter plot reveals a positive correlation between Total Steps and Calories, indicating that increased physical activity leads to higher caloric expenditure. This relationship aligns with the expected outcome that more steps translate into more calories burned.
This boxplot visualizes calorie expenditure across different step and distance categories. The graph is organized to explore which factor—steps or distance—more significantly influences calories burned. Notably, the highest calorie burns are observed in the "6k > & < 10k Steps" and "> 7 miles" categories, suggesting activities like running where greater distances are covered with fewer steps.

The comparison between the "> 10k Steps" at a moderate distance and the "<6k Steps" at a shorter distance highlights that speed, rather than simply activity duration or step count, plays a crucial role in calorie expenditure. This suggests that more intense, quicker paces are key for higher calorie burn.

### User type analysis
For the next analysis, I define user types based on their activity levels — categorized as VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, and SedentaryMinutes.These classifications can help in understanding patterns of physical activity among different segments and tailoring interventions or recommendations accordingly.
1. Very Active Users
2. Moderately Active Users
3. Lightly Active Users
4. Sedentary Users

```{r}
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
```

![image](https://github.com/user-attachments/assets/d4967fbd-7bd0-4ae1-97ed-7c4a1aceb6d3)

![image](https://github.com/user-attachments/assets/ce7ed492-9b63-4f1a-9388-3eace8b20dd3)

![image](https://github.com/user-attachments/assets/534c984b-24bd-480a-8f95-d2f1f46c49fd)

#### Analysis:
It appears that the majority of users are either sedentary or only lightly active, yet it's fascinating to note that while they form the largest group, the fairly active and, notably, the very active users burn the most calories. This finding, while not unexpected, confirms the hypothesis that calorie expenditure is closely linked to activity levels, making it a crucial consideration in any weight loss endeavor.


### Sleep and user type
For investigating the relationship between sleep and user type, I merge the two daily_activity and sleep_day datasets.
```{r}
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
```
![image](https://github.com/user-attachments/assets/e5e8a6bb-8a84-4240-81aa-dbf11496be0d)

#### Analysis:
This chart effectively illustrates the correlation between activity levels and sleep quality. Notably, it reveals that sedentary individuals have a higher percentage of poor sleep quality. Conversely, even minimal physical activity appears to significantly enhance the proportion of normal sleep quality among participants.

Surprisingly, the chart also shows a decline in the number of individuals who sleep excessively (over 8 hours) among the most active groups. This observation aligns with the idea that highly active people tend to spend less time in bed, possibly due to lifestyle or personal preferences.


### Revised Ideas for the the company App

**Health and Activity Insights:**
- The average total daily steps for users are 7,638, which is slightly below the threshold for significant health benefits. Research from the CDC indicates that taking at least 8,000 steps per day can lower the risk of mortality by 51%, compared to taking 4,000 steps. Taking 12,000 steps per day could reduce this risk by up to 65%. the company can leverage this data to encourage users to achieve at least 8,000 steps daily, emphasizing the substantial health benefits.

**Dietary Recommendations:**
- For users aiming to lose weight, managing daily calorie intake is crucial. the company can offer suggestions for low-calorie meals for lunch and dinner, helping users make healthier dietary choices.

**Sleep Improvement Strategies:**
- To aid users in improving their sleep quality, the company could implement app notifications reminding users to go to bed at optimal times.
- Another suggestion is to promote reducing sedentary time as a method to enhance sleep quality.

**Activity Timing:**
- Observations indicate that most physical activity occurs between 5 PM and 7 PM, likely because individuals engage in exercise after work. the company can capitalize on this by sending timely reminders or motivational messages encouraging users to walk or run during these peak times.

**Marketing Insights and Strategies:**
- There is a demonstrable correlation between high-intensity activity and increased calorie burn. Highlighting this in marketing materials can motivate potential customers to use the the company device to monitor their physical activities, particularly if they have goals related to weight loss.
- Additionally, data suggests that higher activity levels are associated with better sleep quality and lower stress levels. Marketing messages should focus on these benefits, promoting how tracking sleep and activity with the company devices can help users enhance their overall quality of life and well-being.

By integrating these insights, the company can more effectively tailor its app functionalities and marketing strategies to meet the needs and preferences of its users, ultimately fostering a healthier lifestyle.
