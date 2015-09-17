#!/bin/bash

set -e
set -x

# Run security audit on provisioned system.
sh /home/vagrant/cis-cat-full/CIS-CAT.sh --accept-terms --results-dir /home/vagrant/ --profile "" --level 2

