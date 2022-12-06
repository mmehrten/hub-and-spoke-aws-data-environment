#!/bin/bash
set -e

for f in projects/*/; do 
	cd $f && terraform init -reconfigure && terraform validate && cd -
done
