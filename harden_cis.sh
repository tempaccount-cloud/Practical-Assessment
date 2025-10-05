#!/bin/bash

oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis_level2_server \
  --remediate \
  --results /tmp/openscap_reports/remediate-results.xml \
  --report /tmp/openscap_reports/remediate-report.html \
  /usr/share/xml/scap/ssg/content/content/build/ssg-ubuntu2204-ds.xml

sudo wkhtmltopdf /tmp/openscap_reports/remediate-report.html /tmp/openscap_reports/remediate-report.pdf

echo "Harden CIS completed successfully"
exit 0