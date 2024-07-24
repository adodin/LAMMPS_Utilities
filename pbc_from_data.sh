#!/bin/bash

usage (){
    cat <<HELP_USAGE

    $0  <file> 

    Prints PBC (Half) box length from LAMMPS data file
    <file> LAMMPS data file containing the PBC information 
HELP_USAGE
    exit 0
}

[ -z $1 ] && { usage; }

grep ".lo .hi" $1 | awk '{ printf "%.17g ", ($2-$1)/2 }'