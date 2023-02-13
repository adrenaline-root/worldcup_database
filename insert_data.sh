#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE teams, games;")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
	if [[ $YEAR != 'year' && $YEAR != '' ]]
	then
		# if winner not in teams
		ITS_IN=$($PSQL "SELECT EXISTS (SELECT 1 FROM teams WHERE name='$WINNER');")
		if [[ $ITS_IN == 'f' ]] 
		then 
			$PSQL "INSERT INTO teams(name) VALUES ('$WINNER');"
		fi
		
		# if opponetn not in teams
		ITS_IN=$($PSQL "SELECT EXISTS (SELECT 1 FROM teams WHERE name='$OPPONENT');")
		if [[ $ITS_IN == 'f' ]] 
		then 
			$PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');"
		fi
		
		# get winner_id
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		
		# get_opponent_id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		
		$PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
			  VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
	fi
done

