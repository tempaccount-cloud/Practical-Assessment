#!/bin/bash
#set -e
#cd /usr/share/xml/scap/ssg/content/content/build

mkdir -p /tmp/openscap_reports || true

oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis_level2_server \
  --results /tmp/openscap_reports/before-results.xml \
  --report /tmp/openscap_reports/before-report.html \
  /usr/share/xml/scap/ssg/content/content/build/ssg-ubuntu2204-ds.xml


sudo wkhtmltopdf /tmp/openscap_reports/before-report.html /tmp/openscap_reports/before-report.pdf

echo "OpenSCAP before scan completed successfully"
exit 0
