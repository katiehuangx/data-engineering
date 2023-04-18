# Katie's Notes

## Run postgres in Docker

Reference: https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/

Enter the following docker run command to start a new Postgres instance or container: 

```
(base) katiehuang@Katies-MacBook-Air ~ % docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
Unable to find image 'postgres:latest' locally
latest: Pulling from library/postgres
ebc3dc5a2d72: Already exists 
3911649e4bca: Already exists 
c4ddc1b927db: Already exists 
34a1b68eb94e: Already exists 
94797b7742f7: Already exists 
7778eb70742d: Already exists 
84a383c97c40: Already exists 
56567f60de78: Already exists 
3663d28ad11d: Pull complete 
1ac7d1542da0: Pull complete 
0abcab7ee629: Pull complete 
b4a505fe257b: Pull complete 
63257b07ec0c: Pull complete 
Digest: sha256:6cc97262444f1c45171081bc5a1d4c28b883ea46a6e0d1a45a8eac4a7f4767ab
Status: Downloaded newer image for postgres:latest
be1f885325793532ef8e91ab6c50308363fd18a8ab7a2f50956cd54d88e04aa8
(base) katiehuang@Katies-MacBook-Air ~ % 
```

```
(base) katiehuang@Katies-MacBook-Air ~ % docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED         STATUS         PORTS      NAMES
be1f88532579   postgres   "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   5432/tcp   some-postgres
```

```
docker ps -- list all images
docker images -- list all images locally
docker ps -a -- shows current and history of run images
docker run <image_id> -- create new container from image

docker run -d -- run docker detached
docker run -d -p6000:6379 --run docker image and bind to local host port

docker start <container_id> -- restart stopped container

docker stop <image_id> -- runs the selected image
docker rmi <image_id> -- removes the image from local machine
```

Rename docker image
```
(base) katiehuang@Katies-MacBook-Air ~ % docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED      STATUS      PORTS                    NAMES
6bddb0f95edb   redis:4.0      "docker-entrypoint.s…"   3 days ago   Up 3 days   0.0.0.0:6001->6379/tcp   strange_keller
916d08075eda   redis          "docker-entrypoint.s…"   3 days ago   Up 3 days   0.0.0.0:6000->6379/tcp   modest_kowalevski

(base) katiehuang@Katies-MacBook-Air ~ % docker run -d -p6001:6379 --name redis-older redis:4.0
4e5c0fdb2e584ece759e2e167c6794d67dea9af6b31d45f56afaaa7401555222

(base) katiehuang@Katies-MacBook-Air ~ % docker run -d -p6000:6379 --name redis-latest redis
45cb9c30e35a2905fd6e2ea34b62346a048e07001b5d15e1abc0df7cae8d2989

(base) katiehuang@Katies-MacBook-Air ~ % docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                    NAMES
45cb9c30e35a   redis          "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   0.0.0.0:6000->6379/tcp   redis-latest
4e5c0fdb2e58   redis:4.0      "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:6001->6379/tcp   redis-older
```

Get the terminal/log file/configuration/environment of running container for debugging
```(base) katiehuang@Katies-MacBook-Air ~ % docker exec -it 45cb9c30e35a /bin/bash
root@45cb9c30e35a:/data# ls
root@45cb9c30e35a:/data# pwd
/data
root@45cb9c30e35a:/data# cd /
root@45cb9c30e35a:/# ls
bin  boot  data  dev  etc  home  lib  media  mnt  opt  proc  root  run	sbin  srv  sys	tmp  usr  var
root@45cb9c30e35a:/# env
HOSTNAME=45cb9c30e35a
REDIS_DOWNLOAD_SHA=1dee4c6487341cae7bd6432ff7590906522215a061fdef87c7d040a0cb600131
PWD=/
HOME=/root
REDIS_VERSION=7.0.10
GOSU_VERSION=1.16
TERM=xterm
REDIS_DOWNLOAD_URL=http://download.redis.io/releases/redis-7.0.10.tar.gz
SHLVL=1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_=/usr/bin/env
OLDPWD=/data
root@45cb9c30e35a:/# exit
exit
(base) katiehuang@Katies-MacBook-Air ~ %
```

