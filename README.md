# Docker Container Scheduler

It works on a simple cron principle.

What to be carefull at:
1. `crontab` file - it must exists, with this specific name, and the content explained below
2. Mount the directory containing your `crontab` at `/usr/scheduler/[production:?]`
3. Environment telling the script where is your cron under `/usr/scheduler/` => `SCHEDULER_ENVIRONMENT=production`

The common part between `2.` and `3.` is `production`, you can say whatever you like there, but mount the volume accordingly. (i.e. if you wanna say `test` mount under `/usr/scheduler/test` your `crontab` and all the scripts)

## production directory content

- crontab
- hello.sh
- other scripts.....


By default, the container will start with `SCHEDULER_ENVIRONMENT="development"` and will run an empty cron 😋

## `crontab` file format
```
    |------------------------> Cron expresion
    |       |----------------> static word, to call the script, don't change this
    |       |    |-----------> Container name
    |       |    |  |--------> `s` or `c` meaning script or command
    |       |    |  |   |----> Command / Script to be executed in container
    |       |    |  |   |
* * * * * sched vm1 s hello.sh
* * * * * sched vm1 c hostname
* * * * * sched vm2 s hello.sh
* * * * * sched vm3 s hello.sh
```


# Build

`docker build -t docker-container-scheduler:dev0 .`


# Install

## docker-compose.yml
```
version: '3.8'

services:
  scheduler:
    container_name: scheduler
    hostname: scheduler
    image: docker-container-scheduler:dev0
    restart: unless-stopped
    privileged: true
    tty: true
    environment:
      - SCHEDULER_ENVIRONMENT=production
    volumes:
      - ${PWD}/production:/usr/scheduler/production
      - /var/run/docker.sock:/var/run/docker.sock
```

## docker run

```
docker run --rm -d --name scheduler \
  -e SCHEDULER_ENVIRONMENT="production" \
  -v ${PWD}/production:/usr/scheduler/production \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker-container-scheduler:dev0
```
