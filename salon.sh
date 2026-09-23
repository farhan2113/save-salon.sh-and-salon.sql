#!/bin/bash
PSQL="psql -U freecodecamp -d salon -t -n -A -q -c"

echo "Welcome to My Salon, how can I help you?"


SALON_SERVICES=$($PSQL "SELECT service_id, name FROM services")

function MAIN_MENU () {

while [[ -z $SERVICE_ID ]]
do

echo "$SALON_SERVICES" | sed 's/|/) /g'
read SERVICE_ID_SELECTED

SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

done
}

MAIN_MENU

echo "What's your phone number?"
read CUSTOMER_PHONE

PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $PHONE ]]
then
echo "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

$PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"

echo "What time would you like your cut, Fabio?"
read SERVICE_TIME



CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers  WHERE phone='$CUSTOMER_PHONE'")
$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')"

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
