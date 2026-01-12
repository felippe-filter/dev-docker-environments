# JD Wetherspoon

This guide contains all the necessary steps to set up and run the JD Wetherspoon projects using Docker.

### Projects in this Build

| Project        | URL                                                                  | IP          |
|----------------|----------------------------------------------------------------------|-------------|
| jdw-proxy-cache | [proxy.jdw.local](https://proxy.jdw.local) | 175.10.0.10 |
| jdw-auth-service | [auth.jdw.local](https://auth.jdw.local) | 175.10.0.20 |
| jdw-auth-manager-frontend | [users.jdw.local](https://users.jdw.local) | 175.10.0.30 |
| jdw-app-manager-api | [api.jdw.local](https://api.jdw.local) | 175.10.0.101
| jdw-app-manager-frontend | [app.jdw.local](https://app.jdw.local) | 175.10.0.102 |
| jdw-payments-api | [payment.jdw.local](https://payment.jdw.local) | 175.10.0.103 |

---

## Prerequisites

Before starting, ensure the following:

### macOS Users

Unlike Docker on Linux, Docker-for-Mac does not expose the container networks directly on the macOS host.  
To go around, you'll need to install a helper tool: *docker-mac-net-connect*
You can find more on [docker-mac-net-connect](https://github.com/chipmk/docker-mac-net-connect)

1. Install `docker-mac-net-connect` via Homebrew:
    ```bash
    brew install chipmk/tap/docker-mac-net-connect
    ```

2. Start the service and register it to launch at boot:
    ```bash
    sudo brew services start chipmk/tap/docker-mac-net-connect
    ```
   I have seeing some error messages saying, it won't be able to restart the service on login because it's running as a
   root if you see that try running with no sudo.


3. In case you are unable to access you containers you may need to rebuild the container and restart the service:
    ```bash
    sudo brew services stop chipmk/tap/docker-mac-net-connect
    sudo docker-mac-net-connect
    ```

### Docker

Ensure you have both Docker and Docker Compose installed. You can check by running:

```bash
docker version
# Docker version 27.2.1, build 9e34c9b

docker compose version
# Docker Compose version v2.29.2
```

If Docker is not installed, follow the instructions at [Get Docker](https://docs.docker.com/get-started/get-docker/) for
your system.

### Database Backup

If you already have any of these systems running locally, make sure to back up the databases. You’ll need this
backup later.  
If this is your first time setting up the projects, ask for a copy of the databases.

---

## Getting Started

### Clone the Projects

Ensure you have all the required project repositories cloned locally. If any project is missing, download it from the
repository:

| Project                   | Repository                                                                                                               | Description            |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------|------------------------|
| jdw-app-manager-api       | [https://github.com/filter-agency/jdw-app-manager-api](https://github.com/filter-agency/jdw-app-manager-api)             | App Manager API        |
| jdw-app-manager-frontend  | [https://github.com/filter-agency/jdw-app-manager-frontend](https://github.com/filter-agency/jdw-app-manager-frontend)   | App Manager Front End  |
| jdw-auth-service          | [https://github.com/filter-agency/jdw-auth-service](https://github.com/filter-agency/jdw-auth-service)                   | Auth Service           |
| jdw-auth-manager-frontend | [https://github.com/filter-agency/jdw-auth-manager-frontend](https://github.com/filter-agency/jdw-auth-manager-frontend) | Auth Service Front End |
| jdw-proxy-cache           | [https://github.com/filter-agency/jdw-proxy-cache](https://github.com/filter-agency/jdw-proxy-cache)                     | Proxy Service          |
| jdw-payments-api          | [https://github.com/filter-agency/jdw-payments-api](https://github.com/filter-agency/jdw-payments-api)                   | Payments Service       |

---

### Configure Environment Variables

Docker Compose needs specific information about your host system and project paths. Follow these steps to configure:

1. Execute the `setup.sh` in the `<project-root>/jdw`

    ```bash
    cd <project-root>/jdw
    ./setup.sh
    ```

2. Open the `.env` file and verify the following variables:

    - `USER_ID`: Your host user ID. Retrieve it by running `id -u` in your terminal.
    - `GROUP_ID`: Your host group ID. Retrieve it by running `id -g`.
    - `HOST_ADDRESS`: The IP address of your Docker host. You can get this by running `ifconfig` and finding the `inet`
      address of `docker0`. Alternatively, you can set it based on your OS:
        - **macOS**: `HOST_ADDRESS=docker.for.mac.localhost`
        - **Windows**: `HOST_ADDRESS=docker.for.win.localhost`
    - `PRJ_PATH`: The path to your project folder (e.g., `~/Projects`).
    - `API_MANAGER_PATH`: The path to the app manager api project.  
    - `APP_MANAGER_PATH`: The path to the app manager frontend project.  
    - `AUTH_PATH`: The path to the auth service project.  
    - `AUTH_APP_PATH`: The path to the auth service frontend project.  
    - `PROXY_PATH`: The path to the proxy cache project.  
    - `PAYMENT_PATH`: The path to the payment api project.  

---

### Build and Run the Environment

Once your project is set up, build and run the Docker environment:

1. Navigate to your project folder:

    ```bash
    cd <project-root>/docker-environments/jdw
    ```

2. Build the Docker containers:

    ```bash
    docker compose build
    ```

3. Start the containers:

    ```bash
    docker compose up -d
    ```

To stop the containers, run:

```bash
docker compose down
```

> After the fist build, fell free to manage your Docker containers using the Docker Desktop


---

## Setting up Hosts

Each Docker container has a unique IP and URL to simplify access. You need to add the following entries to your
`/etc/hosts` file:

Open

```bash
sudo nano /etc/hosts
```

and paste

```bash
##### Docker containers #####
175.10.0.2 mysql.jdw.local
175.10.0.4 redis.jdw.local
175.10.0.6 dynamodb.jdw.local

175.10.0.10 proxy.jdw.local
175.10.0.20 auth.jdw.local
175.10.0.30 users.jdw.local

175.10.0.101 api.jdw.local
175.10.0.102 app.jdw.local
175.10.0.103 payment.jdw.local
```

Now, you can check if it's all set up, pinging any domain:

``` bash
ping api.jdw.local
```
> **Note**: If you get no response. try restarting `docker-mac-net-connect`
> ```shell
> sudo brew services stop chipmk/tap/docker-mac-net-connect
> docker-mac-net-connect
>```
> and try again

---

## Database Setup

Before continuing, verify that the MySQL database is running by pinging the MySQL server:

```bash
ping mysql.jdw.local
```

> **Note**: If you get no response. try restarting `docker-mac-net-connect`
> ```shell
> sudo brew services stop chipmk/tap/docker-mac-net-connect
> docker-mac-net-connect
>```
> and try again

If you don’t have the database dump yet, request it.

### Create Database Schemas

Run the following command to create the necessary schemas in MySQL:

```bash
mysql --host=mysql.jdw.local --user=root -Bse "
CREATE SCHEMA IF NOT EXISTS \`jdw-app-manager\`;
CREATE SCHEMA IF NOT EXISTS \`jdw-auth\`;
CREATE SCHEMA IF NOT EXISTS \`jdw-payment\`;
CREATE SCHEMA IF NOT EXISTS \`jdw_proxy_cache_local\`;
"
```

### Import Database Dumps

Once you have the database dumps, import them using your preferred DBMS or the MySQL command line:

```bash
mysql --host=mysql.jdw.local --user=root DB_NAME < full_file_name.sql
```

---

## Fist run

Some projects need's to install package from the package manager.

```shell
docker exec -it proxy.jdw.local composer install 
docker exec -it auth.jdw.local composer install 
docker exec -it api.jdw.local composer install 
docker exec -it payment.jdw.local composer install 
```

---

## Conclusion

If everything has been configured correctly, your environment should now be up and running.

Good luck!
