#!/bin/bash

case ${1} in
    start)
        bin/setup
        bin/rails s -b 0.0.0.0
        ;;
esac
