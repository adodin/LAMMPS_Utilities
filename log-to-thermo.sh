#!/bin/bash

usage () {
    cat <<HELP_USAGE

    $0  <file> <output-file>

    Converts a LAMMPS log file to a csv
    <file> LAMMPS log file containing data
    <output-file> Target output file
HELP_USAGE
    exit 0
}

[ -z $1 ] && { usage; }

sed -En '/Step|Time/,/Loop/ {
  /^SHOCK:/n
  /^SHAKE:/n
  /^Loop/ !p
}' < $1 > $2
