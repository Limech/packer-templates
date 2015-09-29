#!/bin/bash

set -e
set -x

cd /home/vagrant/cis-cat-full/
./CIS-CAT.sh -a -t -b benchmarks/CIS_CentOS_Linux_6_Benchmark_v1.1.0-xccdf.xml -p "Level 2" -r ../
cd ..
ls
