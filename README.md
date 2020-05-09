# Dockerfile for Petalinux-Ultra96

This is a Petalinux docker file for Ultra96.  
You need to download petalinux 2019.2 from Xilinx.  
You can download the petalinux with aria2c which enables multipart download.  

This project based on Ubuntu 20.04.  
It's for recent Notebook Computer Users, and so on.
Docker Ubuntu version is 18.04.  
Petalinux is 2019.2.  

Use Vivado Tools on your Linux Machine and use petalinux with docker.  

## Important Issue
```
You have to download petalinux-2019.2-final-installer.run file at this project location.
There are some checksum issue.
```

## How to accelerate download
```
# aria2c -m 10 -s 10 -x 10 -o petalinux-v2019.2-final-installer.run <petalinux link>
```

## Building docker image
```
$ docker build --build-arg PETALINUX_INSTALLER=petalinux-v2019.2-final-installer.run -t petalinux2019_2 .
```

## Run docker container
```
$ docker run -it -v <your directory>:/home/vivado/workshop petalinux2019_2
```

## how to know what commands are currently running on docker
```
$ docker ps --no-trunc
```
