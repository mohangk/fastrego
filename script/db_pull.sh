#!/bin/bash

heroku pgbackups:capture --app mt-fastrego
curl -o latest.dump `heroku pgbackups:url --app mt-fastrego`
pg_restore --verbose --clean --no-acl --no-owner -h localhost  -d fastrego_live latest.dump
rm latest.dump

