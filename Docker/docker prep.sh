🐳 What is Docker?
Docker is an open-source platform that allows you to:
Package, distribute, and run applications in lightweight, portable containers.
Containers include everything the software needs to run: code, libraries, dependencies, and runtime — all bundled together.
It solves the classic problem of "It works on my machine" by ensuring consistency across different environments.


Layer Concept	Purpose / Benefit
Layer Reuse	Docker caches unchanged layers to speed up builds.
Smaller Image Size	Unchanged base layers are reused, reducing image size and bandwidth.
Efficient Storage	Layers are stored as diffs — only changes are added layer by layer.
Version Control-like	Changes are tracked step by step, making debugging and rollbacks easier.
Parallel Use	Multiple containers can use the same base layers, saving space and memory.


Virtual machines have their own OS whereas containers use the kernel of the host OS
Docker works as client server architecture
1️⃣ Docker Client – The user interface for interacting with Docker.
2️⃣ Docker Server (Docker Daemon) – Runs in the background and manages containers.

==================Docker engine:
-docker doemon
-docker cli
-rest api

to access any docker host from other device by using the cmd:
docker -H=<host address>:<port number> run nginx

+--------------------+      +---------------------+
|  Docker Client    |  --->|  Docker Daemon      |
|  (docker CLI)     |      |  (dockerd)          |
+--------------------+      +---------------------+
         |                         |
         v                         v
+------------------+      +------------------+
| Docker Registry |      |   Docker Objects  |
| (Docker Hub)    |      | (Containers, Vols)|
+------------------+      +------------------+
 

 for vms
+----------------------+
|  App 1              |
|  Guest OS (Linux)    |
+----------------------+
|  App 2              |
|  Guest OS (Windows)  |
+----------------------+
| Hypervisor (VMware)  |
+----------------------+
| Host OS (Linux)      |
+----------------------+
| Physical Hardware    |
+----------------------+

for contianers

+----------------------+
|  App 1              |
+----------------------+
|  App 2              |
+----------------------+
| Shared Host Kernel  |
+----------------------+
| Host OS (Linux)      |
+----------------------+
| Physical Hardware    |
+----------------------+


docker images -> list of images in docker host
docker rmi <image name>  -> to delete the image but before running  thsi must confirm no containers avilable with this image
#This will remove all images without at least one container associated to them
docker image prune -a

docker run kodecloud # it will help to run container using images if images in not there it will pull the image from regsitery or
docker pull imagename  #it will pull form repo to imahes 
docker exec <name>  # to access the contianer in a bash terminal or env
docker run -it <name> bash  # it will run the container and go inside on it  {i interactive and  t refers terminal}

docker stop <name or id> #to kill the particular the container

docker ps   -> for running conatainers
docker ps -a  -> for all stopoped and ruuning
docker inspect <container name>   # to inscpect all the elements in a json format network and mount settings

docker stop <container name >   ->  to stop the container
# to stop mutltiple containers at a once then we have to use first 2 digigts of the container id
docker stop j2 y4 6d 7s j2   #then it will stop all the contianer

docker rm <id / name >   ->  to remove the container

==> if you host any web application in docker
docker run kodecloud/simple-webapp
then it will give the web port from that we access it UI

detch or attach mode:
docker run -d <image name>   #it will run an container backend and give nxt promt in terminal
docker attach <contianer id>     # to attach the running container in terminal then we can get it from this 

=================port mapping==================
docker run -p 80(local):5000(container) <name>   # it will map 80 of local host to the 5000 of docker container then /
                               #we can access the applcation outside of docker host
#and only for one port of container to local port will be map more than one will not work
-if we access any ip from internal which means host then it will work with internal port
-but if we access out of host and from user account then we have to access through docker host ip and we have to map the ports b/w local host and container
docker run -p <host_port>:<container_port> <image_name>
<host_port> → The port on your machine (host) that you want to expose.
<container_port> → The port inside the container where the service is running.
Binding to a Specific IP Address  ->  docker run -p 127.0.0.1:8080:80 nginx


docker run -v /opt/data:/var/log mysql   #volume mapping of a docker containers

docker logs <container> # to find out all logs fot that contianer with ports

=====================DOCKER FILE=====================
usual steps
1. OS install
2. update the app repo
3. install the dependecies
4. install the python dependecies
5. copy source code
6. run the web server using flask command


INSTRUCTION ARGUMENT

FROM Ubuntu
RUN apt-get update && apt-get -y install python
RUN pip install flask flask-mysql
COPY . /opt/source-code
ENTRYPOINT FLASK-APP=/opt/source-code/app.py flask run

#to build the image from docker file 
docker build . -f Dockerfile -t <image name>   #-t is set to tag for the image name
#if you tag just image name it is not possible to push the images we have to tag account name alos
docker build . -t vpraneeth/myapplication    #vpraneeth -> account name   then it will tag with application name

docker push <image name>    #if we face any login then we use docker login then we have give docker creds in the prompt
#then it will pushed to docker hub

environment variable:
#to run any container by using enviormental variables then we have to -e
docker run -e APP_COLOR=blue <image name>    #that is to just change the colour 

=> how we will find the environmental variable running on the container
docker inpect image   # in config section we can able to find the env variable

diff between CMD & ENTRYPOINT

defines---
ENTRYPOINT ["sleep"]
CMD ["some value"]

CMD 
- we can override it by giving the argument in command line while running the container 
- if we havent any paramater then it wont override and run what is the paramater presented in docker file 

ENTRYPOINT
- it will append the command to run in command line argument when starting the command to start container
- so exp it will docker run <filename>   then it will run the actual command is like   docker run <image run> sleep

====================Docker compose==========================
we can create a confgurtion file in YAML format and keep togetehr diff services to keep all things in things in same file and easy accesible to run alla at ati
to run any docker compose file we have to install the docker compose

example:
we have five serivcs to run an application wit in container
docker run -d --name=redis redis
docker run -d --name=db postgres
docker run -d --name=result -p 5000:80 --link db:postgres resultapp/nodejs
docker run -d --name=worker --link db:postgres --link redis:redis worker/.net
docker run -d --name=vote -p 5001:80 --link redis:redis votingapp/python

if we run all services are diff container by using diff run commands we havent mapped the all services we have used 
link is cli option to link the 2 contianers so i have link tag in that above commands
#exp docker file::
services:
    redis:
        image: redis   #these are fefault from doker hub registry
    postgres:
        image: postgres
    result:
        #in this service this is owned script to get build the so shoudl use as build
        #image: result 
        build: ./folder   #specify the folder name in repositry
        ports:
            -5000:80
        links:
            -db:postgres
    worker:
        #image: worker
        build: ./folder
        links:
            -db:postgres
            -redis:redis
    votingapp:
        build: ./folder   #for image
        ports:
            -5001:80
        links:
            -redis:redis

by using docker-compose up then it will run this yaml file

services is mandatory to used in the docker-compose file 
and version is not much mandatory in the latest docker compose images v2+
#xp--2
services:
  redis:
    image: redis:alpine
  clickcounter:
    image: kodekloud/click-counter
    ports:
    - 8085:5000
version: '3.0'

resources:
https://docs.docker.com/install/linux/docker-ce/ubuntu/
https://docs.docker.com/compose/
https://docs.docker.com/engine/reference/commandline/compose/
https://github.com/dockersamples/example-voting-app
https://docs.docker.com/engine/containers/resource_constraints/


docker registry  -->?  which is the central repositroy for all the public images 
all public images are pulled from registry   docker.io
image: <dockerhub username>/<image name>

if it is a private registary then we have to type of private-registary.io
how to create private registry in our organization?  it is also a image from regitsry and accessible from port 5000
once you loged inn we have to run the command

docker run -d --name my-registry --restart always -p 5000:5000 registry:2
#pull for central repo and tag image name with localhost and push again back
docker pull nginx:latest
docker image tag nginx:latest localhost:5000/nginx:latest   #re-tagging the docker image
docker push localhost:5000/nginx:latest   #pushing into the regitsry

#To check the list of images pushed , 
use curl -X GET localhost:5000/v2/_catalog


=========conternization
-process ID
-Unix Timesharing
-network
-innterprocess
-mount

cgroups:
to set the usage of docker cpu and memory by using the commands:
docker run --cpu=.5 ubuntu
docker run --memory=100m ubuntu


docker exec <contianer id> ps -eaf   #it will list all the processers running on the containers


=======================docker storage and file system  ============
Docker will store each layer of exceution of docker file in cache and when new iteration or new exeution /
comes to run same then it will take copy of that layer fromcache and use that same space
and efficemtly uses the disk spaace

===Volumes
to create a dockervolume in that directory
docker volume create data_vol
then it will create in a direct:  /var/lo/docker/volume/data_vol ##as this is defacult for volume for docker

====mounting types======
#Bind mounting: if we mount from any directorary of docker host to the container
eg; docker run -v /data/mysql:/var/log/mysql mysql
#volume mounting: mount from volume directory of docker host to the container 
eg; docker run -v data_vol:/var/log/mysql mysql 

now the latest use mouuting the voulumes is using --mount
docker run --mount type=bind,source=/data/mysql,target=/var/log/mysql mysql

these things will be hanlded by storgae drivers like they will layered architecture
-AUFS
-ZFS
-BTRFS
-overlay
-overlay2
-device mapper
these storage drivers are used byu depending with the OS if we taken as example for ubuntu -AUFS


docker history <imagename>

docker system df   # it will show disk consumption of images , containers, local volumes

docker system df -v

========Docker networking
1. bridge  ->  docker run ubuntu # in this contianer are running to within host network and it 
#isaccessible with ohter containers in same host . it is private internal network they get an ip address by using host.
#by default ip is 172.17 range of subnet
2. none  ->  docker run ubuntu --network=none   #in this containers are running in isolated network so it wont have connection between others
3. host  ->  docker run ubuntu --network=host  # this dont have no port mapping and that network is connect 
#to host network so all ports wiil be conneted to host . finally it will accessible with host network.

User-defined network:
============
usaully in a docker host all continaers are connected with in default network but if we want differnet ineternal 
network with in the docker host then we have to use below command

docker network create --driver bridge --subnet <0.0.0.0/16> custom-isoalated-network
eg: docker network create --driver bridge --subnet 182.18.0.0/24 --gateway 182.18.0.1 wp-mysql-network

#to get all networks in docker
docker network ls
#to get the type od network used in continer
docker inspect <contianer>   #in network section we can observe which type of network they are using

#to get the subnet of the network of any 
docker inspect <netowkr id>

=======Container orchestration==========
docker service create --replicas=100 nodejs

*******multiple sloutions **************8
--> docker swarm   (docker)
--> kubernates  (goggle)
--> mesos   (apache)

==docker swarm===
#to inatize the manager
docker swarm init
#to join the workers to manager
docker swarm join --token <>


================References=======
Before going into the quiz on Docker on Windows, please find some tips and references below:
Summary Points:
Docker on Windows has two options
Docker on Windows using Docker Toolbox - Docker on Linux VM on Oracle Virtual Box on Windows
Docker Toolbox Requirements
64-bit operating system
Windows 7 or Higher
Virtualization enabled on Windows
Docker Toolbox Contents
Oracle Virtualbox
Docker Engine
Docker Machine
Docker Compose
Kitematic GUI
Docker For Windows - Docker on Linux VM on Windows Hyper-V on Windows
Docker For Windows Requirements
Windows 10 Enterprise/Professional Edition
Windows Server 2016
Docker For Windows supports Linux Containers (Default) and Windows Containers
Docker For Windows Container Types:
Windows Server Core: Windows container on native windows server core
Hyper-V Isolation: Windows container on an isolated hyper-v kernel
References and Links:
Docker on Windows Documentation: https://docs.docker.com/docker-for-windows/
Docker For Windows Download: https://www.docker.com/docker-windows
Docker Toolbox Download: https://www.docker.com/products/docker-toolbox
















