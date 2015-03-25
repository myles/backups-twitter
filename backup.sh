#!/bin/sh

GPGKEYS=${GPGKEYS:-"5A2FE7BF"}
ARCHIVEHOME=${HOME}/Backups/Twitter
TWITTER_USER="@MylesB"

cd ${ARCHIVEHOME}

git fetch origin
git pull origin master

t timeline $TWITTER_USER --csv --decode-uris --number 3000 > tweets.csv

t retweets --csv --decode-uris --number 3000 > retweets.csv

t favorites --csv --decode-uris --number 3000 > favorites.csv

t direct_messages --csv --decode-uris --number 3000 > dm_received.csv
t direct_messages_sent --csv --decode-uris --number 3000 > dm_sent.csv

t whoami > profile.txt

t lists -l --csv > lists.csv

gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o dm_received.csv.gpg dm_received.csv
gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o dm_sent.csv.gpg dm_sent.csv

t followings --csv > followings.csv
t followers --csv > followers.csv

git add ${ARCHIVEHOME}
git commit -m "script.sh automated checkin on `hostname -s`."

git push origin master

