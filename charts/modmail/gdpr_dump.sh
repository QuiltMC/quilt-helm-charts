# Produces an export of the ModMail data linked to a discord account identifier
# Assumes an existing connection to a kubernetes cluster hosting the ModMail chart
# Variables:
#  - MODMAIL_MONGO_POD: the name of the pod hosting the ModMail database (e.g. "quilt-modmail-mongodb-1234-abcd")
#  - DB_USERNAME: username for connecting to the database
#  - DB_PASSWORD: password for connecting to the database
#  - DISCORD_ID: identifier of the discord account of which to retrieve associated data (e.g. "123456789012345678")
kubectl exec $MODMAIL_MONGO_POD -- mongosh -u $DB_USERNAME -p $DB_PASSWORD --eval "use modmail_bot" --eval 'db.logs.find({ "messages.author.id": "'"$DISCORD_ID"'" }, { "open": 1, "created_at": 1, "closed_at": 1, "channel_id": 1, "guild_id": 1, "bot_id": 1, "recipient": 1, "creator": 1, "messages": { "$filter": { "input": "$messages", "as": "msg", "cond": { "$eq": [ "$$msg.author.id", "'"$DISCORD_ID"'" ] } } } })'
