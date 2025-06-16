#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
# Determine what kind of input it is
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number = $1"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  CONDITION="symbol = '$1'"
else
  CONDITION="name = '$1'"
fi

# Query the database
RESULT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $CONDITION")


# Check if element was found
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi
