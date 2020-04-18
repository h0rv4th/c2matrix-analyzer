#!/usr/bin/env bash

# Remove firewalld
yum remove firewalld -y -q

# Install net-tools, git, zip, ntp
yum install net-tools git zip ntp -y -q || true
ntpdate -s time.nist.gov || true
