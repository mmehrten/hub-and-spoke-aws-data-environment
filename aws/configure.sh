#!/bin/bash
set -e

cd modules 
base=$(pwd)

for f in `find . -type d -d 1`; do 
    ln -sf ${base}/common-variables.tf ${base}/$f/common-variables.tf
done
cd -
base=$(pwd)
for project in commercial government financial; do
    ln -sf ${base}/projects/data-main.tf ${base}/projects/${project}/main.tf
    ln -sf ${base}/projects/data-variables.tf ${base}/projects/${project}/variables.tf
done