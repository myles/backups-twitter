#!/bin/bash

GPGKEYS=${GPGKEYS:-"5A2FE7BF"}
ARCHIVEHOME=${HOME}/Backups/Twitter
TWITTER_USER="@MylesB"
PRIVATE_LISTS=("mylesb/awesome-people" "mylesb/egocentric" "mylesb/family")

cd ${ARCHIVEHOME}

git fetch origin
git pull origin master

function encrypt () {
  gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o ${ARCHIVEHOME}/$1.gpg ${ARCHIVEHOME}/$1.csv
}

t timeline $TWITTER_USER --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/tweets.csv
git add ${ARCHIVEHOME}/tweets.csv

t retweets $TWITTER_USER --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/retweets.csv
git add ${ARCHIVEHOME}/retweets.csv

t favorites $TWITTER_USER --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/favorites.csv
git add ${ARCHIVEHOME}/favorites.csv

t whois $TWITTER_USER > ${ARCHIVEHOME}/profile.txt
git add ${ARCHIVEHOME}/profile.txt

t lists -l --csv > ${ARCHIVEHOME}/lists.csv
git add ${ARCHIVEHOME}/lists.csv

for list in `t lists -i`
do
  t list members $list -l --csv > ${ARCHIVEHOME}/lists/${list//\@}.csv
done

for list in ${PRIVATE_LISTS[@]}
do
  encrypt lists/$list.csv
done

git add ${ARCHIVEHOME}/lists

t direct_messages --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/dm_received.csv
encrypt dm_received.csv
git add ${ARCHIVEHOME}/dm_received.csv.gpg

t direct_messages_sent --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/dm_sent.csv
encrypt dm_sent.csv
git add ${ARCHIVEHOME}/dm_sent.csv.gpg

t followings $TWITTER_USER --csv > ${ARCHIVEHOME}/followings.csv
git add ${ARCHIVEHOME}/followings.csv

t followers $TWITTER_USER --csv > ${ARCHIVEHOME}/followers.csv
git add ${ARCHIVEHOME}/followers.csv

git commit -m "script.sh automated checkin on `hostname -s`."

git push origin master

