# pCloud in a Docker

- Do first run to enter password and create database

  ```docker -it -e USERNAME=user@example.com pcloud```
- Modify SQLite database `data.db` as needed within data directory
- Run

  ```docker --privileged -e USERNAME=user@example.com pcloud```

## syncfolder management
```
# print usage
docker run pcloud syncfolder

# list syncfolders
docker run pcloud syncfolder list

# add folder for two-way sync
docker run pcloud syncfolder add PCLOUD_PATH LOCAL_PATH sync

# remove syncfolder
docker run pcloud syncfolder remove ID
```

## Volumes:
- Data directory `/root/.pcloud/`
- Cache directory `/root/.pcloud/Cache`
