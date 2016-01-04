#!/bin/bash

set -e
set -x

cd /home/vagrant/cis-cat-full/
./CIS-CAT.sh -a -t -b benchmarks/CIS_Red_Hat_Enterprise_Linux_6_Benchmark_v1.4.0-xccdf.xml -p "Level 2" -r ../
cd ..
ls
