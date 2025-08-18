#!/bin/bash

# Find all unique versions with -SNAPSHOT
versions=$(grep -rohP '<version>\K[0-9A-Za-z\.\-]+(?=-SNAPSHOT</version>)' --include=pom.xml . | sort -u)

for version in $versions; do
    # Replace only the -SNAPSHOT part, keeping the version
    find . -name "pom.xml" -exec sed -i.bak "s/${version}-SNAPSHOT/${version}/g" {} \;
    echo "Replaced ${version}-SNAPSHOT with ${version}"
done

echo "===== DIFF AFTER step_three.sh ====="
find . -name "pom.xml.bak" | while read bakfile; do
    orig="$bakfile"
    mod="${bakfile%.bak}"
    if [ -f "$mod" ]; then
        echo "Diff for $mod"
        diff "$orig" "$mod" || true
    fi
done

# mvn validate -pl "$MODULE_PATH" -am
# status=$?
# if [ $status -ne 0 ]; then
#     echo "Invalid POM after SNAPSHOT replacement"
#     exit 99
# fi

