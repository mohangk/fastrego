# $1 paypal_login
# $2 paypal_password
# $3 paypal_signature
# $4 paypal_appid
# $5 paypal_email
heroku config:add PAYPAL_LOGIN=$1 PAYPAL_PASSWORD=$2 PAYPAL_SIGNATURE=$3 PAYPAL_APPID=$4 PAYPAL_EMAIL=$5 --app mt-fastrego
