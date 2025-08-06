#!/bin/bash

REPO_URL="$1"
COMMIT_SHA="$2"
MODULE_PATH="$3"

if [ -z "$REPO_URL" ] || [ -z "$COMMIT_SHA" ] || [ -z "$MODULE_PATH" ]; then
    echo "Usage: $0 <repo_url> <commit_sha> <module_path>"
    exit 1
fi

rm -rf target-project
git clone "$REPO_URL" target-project
cd target-project || exit 1
git checkout "$COMMIT_SHA"


SHA=$(git rev-parse HEAD)
LOG_DIR="/root/logs"
mkdir -p "$LOG_DIR"



cd "$MODULE_PATH" || exit 1

check(){
	if [ $1 -eq 0 ]; then
		echo "success"
		exit 0
	fi
}

log_output(){
	steps_combo="$1"
	shift
	echo "Running $steps_combo"
	log_file="$LOG_DIR/${SHA}__${steps_combo}.log"
	{
		echo "===== $steps_combo ====="
		"$@"
	} &> "$log_file"

	status=$?
	echo "Exit code for $steps_combo: $status"
	check $status
	echo
}

log_output "Step 1" /workspace/step_one.sh "$MODULE_PATH"

git reset --hard HEAD
git clean -xfd
log_output "Step 1 + 2" /workspace/step_two.sh "$MODULE_PATH"


git reset --hard HEAD
git clean -xfd
log_output "Step 1 + 3"	bash -c "/workspace/step_three.sh && /workspace/step_one.sh '$MODULE_PATH'"

git reset --hard HEAD
git clean -xfd
log_output "Step 1 + 4"	bash -c "/workspace/step_four.sh && /workspace/step_one.sh '$MODULE_PATH'"

git reset --hard HEAD
git clean -xfd 
log_output "Step 1 + 2 + 3"	bash -c "/workspace/step_two.sh '$MODULE_PATH' && /workspace/step_three.sh"


git reset --hard HEAD
git clean -xfd 
log_output "Step 1 + 2 + 4"	bash -c "/workspace/step_two.sh '$MODULE_PATH' && /workspace/step_four.sh"


git reset --hard HEAD
git clean -xfd
log_output "Step 1 + 3 + 4"	bash -c "/workspace/step_three.sh && /workspace/step_four.sh && /workspace/step_one.sh '$MODULE_PATH'"

git reset --hard HEAD
git clean -xfd 
log_output "Step 1 + 2 + 3 + 4"	bash -c "/workspace/step_two.sh '$MODULE_PATH' && /workspace/step_three.sh && /workspace/step_four.sh"
