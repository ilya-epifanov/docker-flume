#!/bin/bash
set -e

if [ "$1" == 'flume-ng' ]; then
	set -- gosu flume "$@"
fi

exec "$@"
