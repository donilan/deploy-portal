Deploy Portal
=============

A tool to execute scripts on server side via web UI.

## Who needs Deploy Portal?

This tool makes for the one who like below:

* There is one or more staging/testing server to update project all the time.
* There is a QA team just want to provide them less permission to run predefined script.

## Requirements

* ruby 2.2.0+ to install rails 5
* sqlite3 or other DB that rails supported

## Features

* Deployment user management with two roles admin and normal user
* Execute scripts that defined by admin user
* Store outputs for each job that to be executed
* Sign in with gitlab oauth2
* Execute script remotly without login but use token
* Import/Export Task to other Deploy Portal

## Installation

Checkout this project then execute the commands below step by step

``` bash
gem install bundler
bundle install --path vendor/bundle
cp config/app.yml.sample config/app.yml
rails s -b 0.0.0.0
```

## TODOs

* downgrade to lower version of rails, so that can use lower version ruby, this is very important

