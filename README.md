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

All the charts include automated daily backups of the databases to an S3.
To restore those backups, you currently have to download the files manually,
then copy them to a container and run either `mongorestore` or `pgrestore`.

## Required secrets

### Image pulling secrets

Some images (notably, the forum) require a GitHub token to pull from its container registry.
This secret should be of type `docker-registry`, and can be created as follows:

```bash
kubectl create secret docker-registry ghcr-token --docker-server=https://ghcr.io/v2/ --docker-username=$GITHUB_USERNAME --docker-password=$GITHUB_PAT --docker-email=$GITHUB_EMAIL
```

where `$GITHUB_PAT` is a simple [access token](https://github.com/settings/tokens) with no specific permission.

### Forum

The forum requires credentials for both SMTP (email, we use AWS SES) and S3 (storage, we use Backblaze) to be set from a secret:

```bash
kubectl create secret generic discourse-secret-env \
  --from-literal="DISCOURSE_SMTP_USER_NAME=$SMTP_USERNAME" \
  --from-literal="DISCOURSE_SMTP_PASSWORD=$SMTP_PASSWORD" \
  --from-literal="DISCOURSE_S3_ACCESS_KEY_ID=$S3_KEY_ID" \
  --from-literal="DISCOURSE_S3_SECRET_ACCESS_KEY=$S3_SECRET_KEY"
```
