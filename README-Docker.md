# pCloud console-client Docker Image

**NOTE**: The docker image was done rather quick'n'dirty and is run as root user with `--privileged` argument, use at your own risk and backup data before getting started!

If `pCloudDrive` fuse mount is not needed, the `--privileged` argument can be left out - but prepare to have the logs spammed with errors about that.

## Build Docker Image

```
docker build -t pcloud:latest .
```

## Environment Variables

- `USERNAME=user@example.com` login user email
- `PCLOUD_REGION_EU=true` connect to EU data center instead of US (thanks to @joemat)

## Volumes

- `/root/.pcloud`: Database is stored here. Mount a docker volume or bind-mount a local directory for database persistence.
- `/root/.pcloud/Cache`: Folder where the client caches files during transfer or when the `pCloudDrive` is accessed.

## First run

On first run the client database is created. Enter the account password once, it is then stored in the database and should not be prompted in subsequent runs.

```
# don't forget to change USERNAME and /local/path/to/config
docker run -it \
  --name=pcloud \
  --privileged \
  -v /local/path/to/config:/root/.pcloud \
  -e USERNAME=user@example.com \
  -e PCLOUD_REGION_EU=true \
  pcloud
```

When status changes from `SCANNING` to `READY`, the local database has been populated and the container can be stopped with `Ctrl` + `c`.

## Add/remove syncfolders

**IMPORTANT: Always stop the container before performing manual database operations!**

Modify SQLite database `data.db` within data directory using a tool like [DB Browser for SQLite](https://sqlitebrowser.org/) or using the `syncfolder` script:

```
# stop and remove pcloud console client if running
docker stop pcloud

# print usage
docker run --rm pcloud syncfolder

# list syncfolders
docker run \
--rm \
-v /local/path/to/config:/root/.pcloud \
pcloud \
syncfolder list

# add folder for two-way sync
# In the example, /my/data is the host path to sync that is bind-mounted
# into the docker container and used as the target folder for syncing.
# This bind-mount has to be mounted when running the client later as well!
docker run \
  --rm \
  -v /tmp/pcloud:/root/.pcloud \
  -v /path/to/my/data:/mnt/my-data \
  pcloud \
  syncfolder add my/data/on/pcloud /mnt/my-data sync

# remove syncfolder
docker run \
  --rm \
  -v /local/path/to/config:/root/.pcloud \
  pcloud \
  syncfolder remove ID
```

## Subsequent/normal run

The pCloudDrive is mounted on `/mnt/pCloudDrive` by default.

Make sure to adjust `USERNAME`, `PCLOUD_REGION_EU` and bind-mounts/volumes for config and data.

```
docker run -d \
  --name=pcloud \
  --privileged \
  -v /local/path/to/config:/root/.pcloud \
  -v /path/to/my/data:/mnt/my-data \
  -e USERNAME=user@example.com \
  -e PCLOUD_REGION_EU=true \
  pcloud
```
