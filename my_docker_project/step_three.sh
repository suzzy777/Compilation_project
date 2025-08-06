#!/bin/bash

versions=$(grep -rohP '<version>\K[0-9A-Za-z\.\-]+(?=-SNAPSHOT</version>)' --include=pom.xml . | sort -u)

for version in $versions; do
	  read -p "Replace ${version}-SNAPSHOT with what? " stable_ver
	  find . -name "pom.xml" -exec sed -i.bak "s/${version}-SNAPSHOT/${stable_ver}/g" {} \;
	  echo "${version}-SNAPSHOT has been replaced with ${stable_ver}"
done
