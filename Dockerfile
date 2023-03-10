FROM --platform=linux/x86_64 ubuntu:16.04

RUN apt-get update && \
  apt-get install -y apt-transport-https curl

RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

# Install latest NPM and Yarn
RUN npm install -g npm@latest
RUN npm install -g yarn@latest

# install additional native dependencies build tools
RUN apt install -y build-essential

# install Git client
RUN apt-get install -y git
# install unzip utility to speed up Cypress unzips
# https://github.com/cypress-io/cypress/releases/tag/v3.8.0
RUN apt-get install -y unzip

# avoid any prompts
ENV DEBIAN_FRONTEND noninteractive
#install tzdata package
RUN apt-get install -y tzdata
# set your timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# install Cypress dependencies (separate commands to avoid time outs)
RUN apt-get install -y \
    libgtk2.0-0
RUN apt-get install -y \
    libnotify-dev
RUN apt-get install -y \
    libgconf-2-4 \
    libnss3 \
    libxss1
RUN apt-get install -y \
    libasound2 \
    xvfb

# a few environment variables to make NPM installs easier
# good colors for most applications
ENV TERM xterm
# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true


LABEL author="Mohd Jeeshan"

WORKDIR /app

COPY package.json .

COPY package-lock.json .

RUN npm ci


COPY . .

CMD ["npm", "run",  "test"]

