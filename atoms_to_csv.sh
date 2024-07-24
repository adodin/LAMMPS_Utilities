#!/bin/bash
# Converts LAMMPS atom style dumps into csv

usage () {
    cat <<HELP_USAGE

    $0  <file> <output-file> [<atom_types>...]

    Converts a LAMMPS trajectory file to a csv
    <file> LAMMPS log file containing data
    <output-file> Target output file
    [<atom_types>...] Select specific atom types. If not specified gets all atoms
HELP_USAGE
    exit 0
}

[ -z $1 ] && { usage; }

# Which Atom Indexes to grab
args=${@:3}
i="/^${args// / |^} /"

[ -z $args ] && { i="/ITEM:/!"; }

# Look for atom spec Header and continue until next header
sed -En '/ITEM: ATOMS/,/ITEM:/{
	       # Skip Header
	       /ITEM: ATOMS/n
	       # Check that we have not hit END condition
	       '"$i"'{
		 # Append the held word (timestep) as a new line
	       	 G
	       	 # Remove new line and move timestep to first entry
	       	 s/(.*)\n(.*)/\2 \1/
	       	 # Print the new line to output
	       	 p
	       }
}
# Look for TIMESTEP Header
/ITEM: TIMESTEP/{
		# Move to next line (after Header)
		n
		# Hold the (TimeStep) in HOLD buffer
	       	h
}' < $1 > $2