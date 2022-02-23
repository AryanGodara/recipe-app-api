FROM python:3.7-alpine

LABEL maintainer="Aryan Godara"

ENV PYTHONUNBUFFERED=1
    #? Tells python to run in unbuffered mode (1 == true), when run inside Docker Containers.
    #* This doesn't allow Python to buffer the outputs. It just prints them directly. It avoids
    #* some complications with the Docker Image, when you're running your python application.

COPY ./requirements.txt /requirements.txt

RUN apk add --update --no-cache postgresql-client
    #TODO: We're installing the PostgreSQL Client.
    #* update : Update the registery before we add this package
    #* no-cache : Don't store the registery index on our dockerfile. (minimize the no. of
    #* extra files and packages included on our docker container)
    #? apk = package manager ; add = add a new package

#TODO: Now, we're going to install some temporary packages that need to be installed on the 
#TODO: system while we run our requirements. And then, we can remove them after the 
#TODO: requirements have run. (Again, to minimize the size of Dockerifle)
RUN apk add --update --no-cahce --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev
    #* virtual : adds an alias for our dependencies that we can use to easily remove those
    #* dependencies later. (.tmp-build-deps)
    #? Then, after linebreak, we list all the temp dependencies that we want to install

RUN pip install -r /requirements.txt
    #? It takes the requirements.txt file we just copied to the container, and it isntalls it
    #? using pip

#TODO: Now, we delete the temporary requirements that we no longer need
RUN apk del .tmp-build-deps

#TODO: Next we're going to make a directory within our Docker Image that we can use to store
#TODO: our application source code

RUN mkdir /app
    #* Creates an empty folder on our docker image, called /app
WORKDIR /app
    #* Then, it switches to this folder as the default directory.
    #* So, any application we run using our docker container will run from this location
    #* unless we specify otherwise.
COPY ./app /app/
    #* It copies the ./app folder from our local machine to the app folder that we just created.
    #? Remember, we don't need to specify /app/ now, as it's the WORKDIR now.


#TODO: Next, we're going to create user that is going to run our application using Docker

RUN adduser -D user
    #* 'user' is the username (I know, it's a bit confusing)
    #? '-D' syas that, create a user that is only going to be used for running applications.
    #? Not for having a home directory, or someone to login as. ONLY to run the Application
USER user
    #? We switched to that user we just create by typing "USER user"

