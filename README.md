# Quick Jenkins customization

This docker compose and docker file allows a quick customization of jenkins
instances and allow full reproducible and committed environment.
It is very useful as a groovy playground and to have solid and reproducible
 environment in production.


## Get Docker

Firs of all you need Docker, if you use Ubuntu and you want the bleeding edge
version you can run the script

    bash ./setup-docker-host.sh

Or install from Ubuntu standard repositories:

    sudo apt-get install docker.io docker-compose

## Build the Docker images

The Jenkins docker images are inherited in this way:

    . debian
    └── ...
        └── jenkins/jenkins:lts
            └── jenkins-base
                ├── jenkins-derived-1
                ├── jenkins-derived-2
                └── jenkins- ...

### Clean up previous images

Before start, to make sure you have the right version of all the images you'd
 better have to remove old images looking with `docker images`, and if you
 want to remove data also volumes shown with `docker volume ls`.

**WARNING MAKE YOU KNOW WHAT YOU'RE DOING BEFORE REMOVING VOLUMES!!!**

Make sure to not have previous versions of the jenkins images:

    docker rm jenkins jenkins-base
    docker rmi jenkins jenkins-base

And carefully remove some orphan images:

    docker image prune

DON'T USE THIS IN PRODUCTION it will remove all static data in volumes:

    #docker volume prune


### Build the jenkins-base template image

First of all you get the Jenkins image.

    docker pull jenkins/jenkins:lts

Then you build the jenkins-base image based on it.

    cd docker-jenkins
    docker build jenkins-base -t jenkins-base

For testing/devel purpose you can use directly the template container. The
 following command will create a new container named 'jenkins-base' based on
 'jenkins-base' image with a data volume named 'jenkins_base' where all jenkins
 data will be created.

    docker run -p 80:8080 -v jenkins_base:/var/jenkins_home --name jenkins-base jenkins-base

And open the browser on http://127.0.0.1:80

### Build specific Jenkins image

Once you've built the jenkins-base image you can build derived images like
 jenkins-release in the same way:

    docker build jenkins-release -t jenkins-release

In the same way as the jenkins-base you can run the container:

    docker run -p 81:8080 -v jenkins_release:/var/jenkins_home --name jenkins-release jenkins-release

## Run the instances with docker-compose

Once all the specific images have been built in production environment you can
setup a nginx reverse proxy instance the routes http/https to a fqdn host with
dedicated ssl certificates.

You have to edit the `docker-compose.yml` yaml file to match the requirements.
The following volumes will keep the data (backup is required), if you want to
keep the volume out of compose or you already have one you should use
'external' key word.

    volumes:
        nignx-ssl-certs:
        jenkins-base-data:
        jenkins-release-data:
            external: true

Bring up the composed images and the magic will happen

    docker-compose up

### Handle ssl certificates

The docker container will genereate every time the ssl certs if not found to
 keep them persistent you should put the crt and key in the shared nginx
 volume.

```
    root@bs:/var/lib/docker/volumes/dockerjenkins_nignx-ssl-certs/_data# ls -l
    total 8.0K
    -rw-r--r-- 1 luca luca 1.3K Sep 29 17:18 jenkins-base.domain.com.crt
    -rw------- 1 luca luca 1.7K Sep 29 17:18 jenkins-base.domain.com.key
```

## References to inherited Dockers

jenkins/jenkins  
https://github.com/jenkinsci/docker

jwilder/nginx-proxy  
https://github.com/jwilder/nginx-proxy
