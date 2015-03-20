#!/bin/sh

GPGKEYS=${GPGKEYS:-"5A2FE7BF"}
ARCHIVEHOME=${HOME}/Backups/Twitter


cd ${ARCHIVEHOME}

git fetch origin
git pull origin master

t timeline @mylesb --csv --number 3000 > tweets.csv
t retweets --csv --number 3000 > retweets.csv
t favorites --csv --number 3000 > favorites.csv

t direct_messages --csv --number 3000 > dm_received.csv
t direct_messages_sent --csv --number 3000 > dm_sent.csv

t whoami > profile.txt

gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o dm_received.csv.gpg dm_received.csv
gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o dm_sent.csv.gpg dm_sent.csv

t followings --csv > followings.csv
t followers --csv > followers.csv

git add ${ARCHIVEHOME}
git commit -m "script.sh automated checkin on `hostname -s`."
