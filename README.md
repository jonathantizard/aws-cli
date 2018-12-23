# Dockerized AWS CLI

This docker file will create a local docker image with all the aws tools. Currently it is only designed for Mac and Linux and will alias aws, eb and sam commands straight to the docker image as if it were running locally.

## Tools inside the image

- AWS CLI:latest
- AWS EB:latest
- AWS SAM:latest

## How does it work?

It will create an alias for each of the commands into the following files:

- .profile
- .bashrc
- .zsh

#### Networking

The container will run in HOST mode - this is to allow the docker container to receive incoming requests via SAM so it can start docker containers correctly.

#### Mount Volumes

There are two mounts

* Mount 1 is to allow AWS SAM to connect to your HOST docker instance. This is so docker doesnt run inside docker.
* Mount 2 will mount your current working directory to the host machine - WARNING do not run the aws commands from your system root as it will attempt to mount your root system to the container. Simply run the commands from inside your projects folder.

## Installation

Simply run

```bash
./install.sh
```

### Running the commands

Simply run them as if they were local

```bash
aws --version
eb --version
sam --version
```

Viola
