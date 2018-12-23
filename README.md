# Dockerized AWS CLI

This docker file will create a local docker image with all the aws tools. Currently it is only designed for Mac and Linux and will alias aws, eb and sam commands straight to the docker image as if it were running locally.

## Tools inside the image

- AWS CLI:latest
- AWS EB:latest
- AWS SAM:latest

## How does it work?

There is an install script that

1. Prompts you to enter your AWS credentials
2. Builds the image and stores those credentials into the image
3. It will then create an alias for each of the commands into the following files on your local machine:

- `.profile`
- `.bashrc`
- `.zsh`

#### Networking

The container will run in HOST mode - this is to allow the docker container to receive incoming requests via SAM so it can start docker containers correctly.

#### Mount Volumes

There are two mounts

* Mount 1 is to allow AWS SAM to connect to your HOST machine running docker. This avoids having docker inside docker *dockerception*.
* Mount 2 will mount your current working directory to the host machine - WARNING do not run the aws commands from your system root as it will attempt to mount your root system to the container. Simply run the commands from inside your projects folder.

## Installation

Simply run

```bash
./install.sh
```

This will then prompt you to enter your AWS credentials. Ensure you put in the correct AWS region and set your output format correctly.

Region = e.g eu-west-2
Output format = json

[AWS Documentation on configuration can be found here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

### Running the commands

Once the install is complete. Simply run the following commands on your host machine - examples below.

```bash
aws --version
eb --version
sam --version
```

Viola
