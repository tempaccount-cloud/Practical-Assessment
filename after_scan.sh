#!/bin/bash

oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis_level1_server \
  --results /tmp/openscap_reports/after-results.xml \
  --report /tmp/openscap_reports/after-report.html \
  /usr/share/xml/scap/ssg/content/content/build/ssg-ubuntu2204-ds.xml

sudo wkhtmltopdf /tmp/openscap_reports/after-report.html /tmp/openscap_reports/after-report.pdf

echo "OpenSCAP after scan completed successfully"
exit 0
