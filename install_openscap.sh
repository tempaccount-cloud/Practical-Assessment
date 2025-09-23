#!/bin/bash
set -eux

 sudo mkdir -p /usr/share/xml/scap/ssg/content
 cd /usr/share/xml/scap/ssg/content
 
sudo git clone -b master https://github.com/ComplianceAsCode/content.git

cd content

sudo ./build_product ubuntu2204

cd build
XML_FILE="ssg-ubuntu2204-ds.xml"


#ls -lah 
oscap info ${XML_FILE}
oscap info --profile xccdf_org.ssgproject.content_profile_cis_level2_server ${XML_FILE}
