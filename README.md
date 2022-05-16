# Result Analyzer
This Repository holds the code for the Result Analyzer task.
It stores the daily results and compute daily stats by EOD and monthly stats by 3rd wednesday month

## Object Domain
We have three models:

1) ResultsDatum
2) DailyResultStat
3) MonthlyAverage

ResultsDatum model is used to store results data.
**POST `/results_data`** API is used to recieve results data.
its accepts array of [subject, timestamp, marks]

**DailyResultStat** is used to store daily stats at every 11:00 pm bt analyzing ResultDatum data.
**MonthlyAverage** is used to store monthly stats by analyzing DailyResultStat data.

Have used ActiveInteraction to to handle all the businees logic and keep model lioght weight and make code more mainatnable also avoid side effects of ActiveRecord when scope of project increases.

**Follwing interactions are introduced:**
ResutDatumArrayInteraction: accept array of [subject, timestamp, marks] and process it bulk import is used to save all data in single query.

**ResutDatumInteraction:** accept params :subject, :timestamp, :marks and validate it and return new object which later saved using bulk import
**DailyResultStatsInteraction:** Compute daily stats by analyzing ResultsDatum data.
**MonthlyAverageInteraction:** Compute monthly stats by analyzing DailyResultStat data.




**Rake Tasks:**

1) Every day one rake task is running at 00:11:00 UTC to daily result stats.

2) Another rake task is running every Monday and if the week contains 3rd wednesday then it computs MontlyAverage
and update it in the database.

# Project Flow:
- Users can create results data by calling API **POST /results_data** .
- At end of day we compute Daily stats by analyzing results data
- At month end we compute montly avaeray stats.
- 
# Database:
Squlite

# Environment Setup

## Prerequisites
To run this application in development you will either want to have
- Ruby 3.2.0
- Rails 6.1.4

###### To setup DB Run:
* `rake db:create`
* `rake db:migrate`

###### Run rails app using
* `rails s`

###### Run Rspec using
* `rake spec`

###### Run cucumber  using
* `rake cucumber`


#### Test Coverage Report

visit http://currency-exchange-dev.herokuapp.com/coverage/index.html for coverage report


# Future Enhancements:

1) Can Add UI to to show results_data, daily_stats and monthly stats.
2) Can switch to better DB(postgresql, mysql) when need increases.

# Coverage report 
Coverage: **98.55%**  Expecpt some cases of code which we copy from o'reilly to compute 3rd wednesday week all are fully covered

![Code coverage for Result analyzer](https://user-images.githubusercontent.com/12711305/168616797-b2ffd4e4-b591-4584-8043-ed4ac830fff6.png)
