#!/bin/bash
set -e

<<comment
	Got tired of the long commands throughout the dev/test workflow.
	This script simplifies it :)

	Passing no args will simply run the unit tests
	Passing --analyze or -a will run static type analysis
	Passing --snapshot or -s will (re)generate the Jest snapshots
	Passing --profile or -p will generate & open a flamegraph of a benchmark that you supply

	Example usages:
		bin/testing.sh
		bin/testing.sh -a
		bin/testing.sh --snapshot
		bin/testing.sh -p bin/run-wide-tree-benchmark.lua
comment

# Parse the args
PARAMS=""
while (( "$#" )); do
	case "$1" in
		-s|--snapshot)
			SNAPSHOT=0
			shift
		;;
		-a|--analyze)
			ANALYZE=0
			shift
		;;
		-p|--profile)
			if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
				PROFILE=$2
				shift 2
			else
				echo "Error: Argument for $1 is missing, please specify a lua file to run (ie: bin/run-sierpinski-triangle-benchmark.lua)" >&2
				exit 1
			fi
		;;
		-*|--*=)
			echo "Error: Unsupported flag $1" >&2
			exit 1
		;;
		*) # Preserve positional arguments
			PARAMS="$PARAMS $1"
			shift
		;;
	esac
done
# Set positional arguments in their proper place
eval set -- "$PARAMS"

# Perform requested action

if [[ $SNAPSHOT ]]; then
	echo "Generating snapshots..."
	roblox-cli run --load.model tests.project.json --run bin/spec.lua --fastFlags.overrides EnableLoadModule=true --fastFlags.allOnLuau --lua.globals=__DEV__=true --lua.globals=__COMPAT_WARNINGS__=true --lua.globals=UPDATESNAPSHOT="all" --load.asRobloxScript --fs.readwrite="$(pwd)"
	exit 0
fi

if [[ $ANALYZE ]]; then
	echo "Analyzing..."
	robloxdev-cli analyze tests.project.json
	exit 0
fi

if [[ $PROFILE  ]]; then
	echo "Generating profiled benchmark '$PROFILE'..."
	robloxdev-cli run --load.model tests.project.json --run $PROFILE --headlessRenderer 1 --fastFlags.overrides "EnableDelayedTaskMethods=true" "FIntScriptProfilerFrequency=1000000" "DebugScriptProfilerEnabled=true" "EnableLoadModule=true" --fastFlags.allOnLuau
	python ../game-engine/Client/Luau/tools/perfgraph.py profile.out > $PROFILE-profile.svg
	rm profile.out
	start $PROFILE-profile.svg
	echo "Flamegraph opened successfully in default svg viewer application"
	exit 0
fi

echo "Running tests..."
roblox-cli run --load.model tests.project.json --run bin/spec.lua --fastFlags.overrides EnableLoadModule=true --fastFlags.allOnLuau --lua.globals=__DEV__=true --lua.globals=__COMPAT_WARNINGS__=true
