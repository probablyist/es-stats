# README

# ES Stats
A simple app that shows a few statistics for the S&P 500 futures contract created with Ruby on Rails and Postgres.

The app takes intra-day price history of the front-month ES contract and calculates the following:
  * Overnight high/low
    * How often the overnight high or low is breached during regular trading hours (RTH)
    * Which RTH thirty minute period most often breaches the overnight high or low
  * First hour high/low (Initial Balance)
    * How often the first hour (8:30 to 9:29 CST) high or low is breached during RTH
    * Which period most often breaches the first hour high or low
  * B to A
    * How often B-period (9:00 to 10:29 CST) breaches the high or low of A-period (8:30 to 8:59 CST)
## Technologies
Project is created with:
* Ruby 3.0.3
* Rails 7.0.3
* Postgres 12.11

## To Do:
* DRY up code
