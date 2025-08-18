# #!/bin/bash

# MODULE_PATH="$1"

# # List of Java versions to try
# JAVA_VERSIONS=(
#     "/usr/local/openjdk-8"
#     "/usr/lib/jvm/java-11-openjdk-amd64"
#     "/usr/lib/jvm/java-17-openjdk-amd64"
# )

# for JAVA_HOME_PATH in "${JAVA_VERSIONS[@]}"; do
#     if [ -x "$JAVA_HOME_PATH/bin/java" ]; then
#         export JAVA_HOME="$JAVA_HOME_PATH"
#         export PATH="$JAVA_HOME/bin:$PATH"

#         echo "Trying Java version: $("$JAVA_HOME/bin/java" -version 2>&1 | head -n 1)"
# 	"$JAVA_HOME/bin/java" -version 2>&1
#         /workspace/step_one.sh "$MODULE_PATH"
#         status=$?

#         if [ $status -eq 0 ]; then
#             echo "Success with Java at $JAVA_HOME_PATH"
#             exit 0
#         else
#             echo "Failed with Java at $JAVA_HOME_PATH"
#         fi
#     else
#         echo "Java not found at $JAVA_HOME_PATH"
#     fi
# done

# echo "All Java versions failed"
# #exit 1

#!/bin/bash

MODULE_PATH="$1"

JAVA_VERSIONS=(
    "/usr/local/openjdk-8"
    "/usr/lib/jvm/java-11-openjdk-amd64"
    "/usr/lib/jvm/java-17-openjdk-amd64"
)

success=false

for JAVA_HOME_PATH in "${JAVA_VERSIONS[@]}"; do
    if [ -x "$JAVA_HOME_PATH/bin/java" ]; then
        export JAVA_HOME="$JAVA_HOME_PATH"
        export PATH="$JAVA_HOME/bin:$PATH"

        echo "Trying Java version: $("$JAVA_HOME/bin/java" -version 2>&1 | head -n 1)"
        "$JAVA_HOME/bin/java" -version 2>&1

        /workspace/step_one.sh "$MODULE_PATH"
        status=$?

        if [ $status -eq 0 ]; then
            echo "Success with Java at $JAVA_HOME_PATH"
            exit 0  # Success — stop trying and stop overall pipeline
        else
            echo "Failed with Java at $JAVA_HOME_PATH"
        fi
    else
        echo "Java not found at $JAVA_HOME_PATH"
    fi
done

# All Java versions failed — continue to next steps
echo "All Java versions failed in step_two.sh"
exit 99
	


