#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


  if [[ ! $1 ]]
  then
     echo "Please provide an element as an argument."
    else 
    
    if [[ $1 =~ ^[0-9]+$ ]]
    then
    ATOMIC=$1
    # check atomic number
    ATOMIC_NUMBER_RESULT=$($PSQL "SELECT name,symbol FROM elements WHERE atomic_number = '$ATOMIC'")
    if [[ $ATOMIC_NUMBER_RESULT ]]
    then
    
    # get the names in order
    echo $ATOMIC_NUMBER_RESULT | while read NAME BAR SYMBOL
    do 
      # get rest of the info from the properties table
      REST_OF_INFO=$($PSQL "SELECT atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = '$1';")
      echo $REST_OF_INFO | while read MASS BAR TYPE BAR MELTING BAR BOILING
      do
        echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    done

    fi
    fi

    # check symbol
    SYMBOL_RESULT=$($PSQL "SELECT name,atomic_number FROM elements WHERE symbol='$1'")
    if [[ $SYMBOL_RESULT ]]
    then 
    SYMBOL=$1
    echo $SYMBOL_RESULT | while read NAME BAR ATOMIC
    do 
      # get rest of the values from properties AND types 
      INFO_WITH_SYMBOL=$($PSQL "SELECT atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = '$ATOMIC';")
      echo $INFO_WITH_SYMBOL |  while read MASS BAR TYPE BAR MELTING BAR BOILING
      do
        echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    done
    fi
    # check name
    NAME_RESULT=$($PSQL "SELECT symbol,atomic_number FROM elements WHERE name='$1'")
        if [[ $NAME_RESULT ]]
    then 
    NAME=$1
    echo $NAME_RESULT | while read SYMBOL BAR ATOMIC
    do 
      # get rest of the values from properties AND types 
      INFO_WITH_SYMBOL=$($PSQL "SELECT atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = '$ATOMIC';")
      echo $INFO_WITH_SYMBOL |  while read MASS BAR TYPE BAR MELTING BAR BOILING
      do
        echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    done
    fi
    if [[ ! $NAME && ! $SYMBOL && ! $ATOMIC ]]
    then
      echo "I could not find that element in the database."
    fi
  fi
