#!/bin/bash
set -e

for f in modules/*/ projects/*/; do 
	echo $f
	terraform-docs $f > $f/README.md; 
	cd $f && terraform fmt && cd -;
done
