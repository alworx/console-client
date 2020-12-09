# pCloud in a Docker

- Do first run to enter password and create database

  ```docker -it -e USERNAME=user@example.com pcloud```
- Modify SQLite database `data.db` as needed within data directory
- Run

  ```docker --privileged -e USERNAME=user@example.com pcloud```

## Volumes:
- Data directory `/root/.pcloud/`
- Cache directory `/root/.pcloud/Cache`
