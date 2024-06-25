# Anonymizes the ModMail data linked to a discord account identifier
# Assumes an existing connection to a kubernetes cluster hosting the ModMail chart
# Variables:
#  - MODMAIL_MONGO_POD: the name of the pod hosting the ModMail database (e.g. "quilt-modmail-mongodb-1234-abcd")
#  - DB_USERNAME: username for connecting to the database
#  - DB_PASSWORD: password for connecting to the database
#  - DISCORD_ID: identifier of the discord account of which to retrieve associated data (e.g. "123456789012345678")
kubectl exec -n quilt $MODMAIL_MONGO_POD -- mongosh -u $DB_USERNAME -p $DB_PASSWORD \
  --eval "use modmail_bot" \
  --eval 'db.logs.updateMany('\
    '{ "recipient.id": "'"$DISCORD_ID"'" }, '\
    '{ $set: {'\
      '"messages.$[elem].author.name": "deleted_user",'\
      '"messages.$[elem].author.avatar_url": "",'\
      '"messages.$[elem].content": "",'\
      '"messages.$[elem].author.id": "0",'\
      '"recipient.name": "deleted_user",'\
      '"creator.name": "deleted_user",'\
      '"recipient.avatar_url": "",'\
      '"creator.avatar_url": "",'\
      '"recipient.id": "0",'\
      '"creator.id": "0"'\
    '} },'\
    '{ arrayFilters: [ { "elem.author.id": "'"$DISCORD_ID"'" } ] })'
