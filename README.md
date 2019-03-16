# README

* Ruby version: `2.3.1`
* Rails version: `5.1.6.2`
* Database: Postgresql

## Clone project
* Execute `git clone git@github.com:marcuslin/incubit_assessment.git` in your console,
and the directory you want to place this project

## Setting up environment
* Install gems
Execute `bundle` in the project directory

* Rename both databse.example.yml and secrets.example.yml
Rename both these files by executing the commande below:
```
mv config/database.example.yml config/database.yml
mv config/secrets.example.yml config/secrets.yml
```

## Create database
* Execute the command below to create both development and test db
```
rails db:create
```

* Database migration
* Execute the command below for migrating db
```
rails db:migrate
```

## Test
* Execute the commad below to run all tests in console
```
rspec spec/
```

* For running specific test execute in console
```
rspec spec/{ test_type }/{ filename }_spec.rb
```

* Note: For this project, `test_type` will only be `models` and `requests`

