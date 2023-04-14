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
