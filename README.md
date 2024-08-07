## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```bash
helm repo add quiltmc https://helm-charts.quiltmc.org
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
quiltmc` to see the charts.

To install the <chart-name> chart:

```bash
helm install my-<chart-name> quiltmc/<chart-name>
```

To uninstall the chart:

```bash
helm delete my-<chart-name>
```


## Backups

All the charts include automated daily backups of the databases to an S3-compatible bucket.
The path for each backup is `/<helm-project-name>/yyyy-mm-dd` (the extension being `.gz` for mongodb backups, and `.pgdump` for postgresql backups).
An additional copy of the latest backup is made to `latest/<helm-project-name>`.

### Expiration

Expiration is not built into the backup charts. Instead, you should configure
your storage bucket with appropriate lifecycle rules.
In Quilt's case, Backblaze is configured such that old backups are hidden after 29 days,
then deleted the next day.

### Restoration

To restore those backups, you can create a temporary container, download a backup, and run either `mongorestore`
or `pgrestore`. For example:

```bash
# Assuming you are connected to the Quilt cluster
kubectl run backup-restore --image=ghcr.io/quiltmc/mongodb-s3-backup:b837205 -it --rm -n quilt -- sh
# Then inside the temp shell session:
aws configure # Enter your credentials
aws --endpoint $ENDPOINT_URL s3 cp s3://quilt-backups/xxx/1970-01-01.gz .
mongorestore -h "hostname" -u "user" -p "password"  --gzip --archive="1970-01-01.gz"
```

To connect to a Backblaze B2 storage with the AWS CLI, refer to [this article](https://www.backblaze.com/docs/cloud-storage-use-the-aws-cli-with-backblaze-b2).
If you are restoring an app (e.g. cozy) from a blank slate, you may need to include the `--drop` option to mongorestore.

## Required secrets

### Image pulling secrets

Some images (notably, the forum) require a GitHub token to pull from its container registry.
This secret should be of type `docker-registry`, and can be created as follows:

```bash
kubectl create secret docker-registry ghcr-token --docker-server=https://ghcr.io/v2/ --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_PAT --docker-email=$GITHUB_EMAIL
```

where `$GITHUB_PAT` is a simple [access token](https://github.com/settings/tokens) with no specific permission.

### Cozy

Cozy requires 4 generic secrets named `cozy-quilt-discord-token`, `cozy-collab-discord-token`, `cozy-showcase-discord-token`,
and `cozy-dev-discord-token`, each with a `TOKEN` variable containing the respective discord token.

### Modmail

With default values, Modmail requires a generic secret named `modmail-quilt-discord-token`, with the variable `TOKEN` containing the discord token.
It also requires another generic secret named `modmail-viewer-quilt`, with the variables `MODMAIL_VIEWER_DISCORD_OAUTH_CLIENT_SECRET` and `MODMAIL_VIEWER_SECRETKEY`.

### Forum

The forum requires credentials for both SMTP (email, we use AWS SES) and S3 (storage, we use Backblaze) to be set from a secret:

```bash
kubectl create secret generic discourse-secret-env \
  --from-literal="DISCOURSE_SMTP_USER_NAME=$SMTP_USERNAME" \
  --from-literal="DISCOURSE_SMTP_PASSWORD=$SMTP_PASSWORD" \
  --from-literal="DISCOURSE_S3_ACCESS_KEY_ID=$S3_KEY_ID" \
  --from-literal="DISCOURSE_S3_SECRET_ACCESS_KEY=$S3_SECRET_KEY"
```
