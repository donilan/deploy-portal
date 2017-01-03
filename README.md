Deploy Portal
=============

A tool to execute predefined script on script side.

## Who needs Deploy Portal?

This tool makes for the one who like below:

* There is one or more staging/testing server to update project all the time.
* There is a QA team just want to provide them less permission to run perdefined script.

## requirements

* ruby 2.2.0+ to install rails 5
* sqlite3 or other DB that rails supported

## installation

Checkout this project then execute the commands below step by step

``` bash
gem install bundler
bundle install --path vendor/bundle
rails s -b 0.0.0.0
```
