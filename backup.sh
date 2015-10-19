#!/bin/sh

GPGKEYS=${GPGKEYS:-"5A2FE7BF"}
ARCHIVEHOME=${HOME}/Backups/Twitter
TWITTER_USER="@MylesB"

cd ${ARCHIVEHOME}

git fetch origin
git pull origin master

t timeline $TWITTER_USER --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/tweets.csv

t retweets --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/retweets.csv

t favorites --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/favorites.csv

t direct_messages --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/dm_received.csv
t direct_messages_sent --csv --decode-uris --number 3000 > ${ARCHIVEHOME}/dm_sent.csv

t whoami > ${ARCHIVEHOME}/profile.txt

t lists -l --csv > ${ARCHIVEHOME}/lists.csv

for list in `t lists -i`
do
  if [ "$TWITTER_USER" == "$list"* ];
  then
    t list members $list -l --csv > ${ARCHIVEHOME}/lists/${list//${TWITTER_USER,,}\/}.csv
  fi
done

gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o ${ARCHIVEHOME}/dm_received.csv.gpg ${ARCHIVEHOME}/dm_received.csv
gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o ${ARCHIVEHOME}/dm_sent.csv.gpg ${ARCHIVEHOME}/dm_sent.csv
gpg --encrypt --armor -r "${GPGKEYS}" --batch --yes --trust-model always -o ${ARCHIVEHOME}/lists/\@mylesb-awesome-people.csv.gpg  ${ARCHIVEHOME}/lists/\@mylesb-awesome-people.csv

t followings --csv > ${ARCHIVEHOME}/followings.csv
t followers --csv > ${ARCHIVEHOME}/followers.csv

git add ${ARCHIVEHOME}
git commit -m "script.sh automated checkin on `hostname -s`."

git push origin master

