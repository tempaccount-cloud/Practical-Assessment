#!/bin/bash
set -eux


sudo rm -f /etc/apt/apt.conf.d/50command-not-found
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean
sudo apt-get autoclean
sudo rm -rf /var/lib/apt/lists/*

sudo apt upgrade -y
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y software-properties-common
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo add-apt-repository restricted -y

sudo apt-get install -y cmake make expat libopenscap8 libxml2-utils ninja-build python3-jinja2 python3-yaml python3-setuptools xsltproc wkhtmltopdf
