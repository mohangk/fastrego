#!/bin/bash
# $1 - identifier
# $2 - admin email
# $3 - admin password
# $4 - tournament name

heroku run rake fastrego:create_admin[$2,$3] --app mt-fastrego
heroku run rake fastrego:create_tournament[$1,$4,$2] --app mt-fastrego
heroku run rake fastrego:create_settings[$1] --app mt-fastrego
