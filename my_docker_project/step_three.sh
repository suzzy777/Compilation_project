#!/bin/bash

# Find all unique versions with -SNAPSHOT
versions=$(grep -rohP '<version>\K[0-9A-Za-z\.\-]+(?=-SNAPSHOT</version>)' --include=pom.xml . | sort -u)

for version in $versions; do
    # Replace only the -SNAPSHOT part, keeping the version
    find . -name "pom.xml" -exec sed -i.bak "s/${version}-SNAPSHOT/${version}/g" {} \;
    echo "Replaced ${version}-SNAPSHOT with ${version}"
done
