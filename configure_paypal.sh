# $1 paypal_login
# $2 paypal_password
# $3 paypal_signature
# $4 paypal_appid
heroku config:add PAYPAL_LOGIN=$1 PAYPAL_PASSWORD=$2 PAYPAL_SIGNATURE=$3 PAYPAL_APPID=$4
