#!/bin/bash

usage () {
    cat <<HELP_USAGE

    $0  <file> <columns>[...]

    Prints averages of specified columns of a csv file
    <file> Target csv file
    <columns>[...] Column indexes to average over. At least one must be provided
HELP_USAGE
    exit 0
}

[ -z $2 ] && { usage; }

f=$1
for i in "${@:2}"
do
	yname=$(head -1 $f|awk "{ print \$$i }")
  echo "${yname}:"
	tail +2 $f|awk -v N=$i '{ sum += $N } END { if (NR > 0) print sum / NR }'
done
