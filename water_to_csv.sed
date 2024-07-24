#!/usr/bin/sed -Enf
# Converts chunked time averaged data into csv format w/ space delimiter

# Look for lines with two 'words'(TimeStep Nmol)
/^[[:alnum:]]+ [[:alnum:]]+$/{
		# Substitute only the first word (TimeStep) into PATT buffer
		s/([[:alnum:]]+) .*/\1/
		# Hold the (TimeStep) in HOLD buffer
	       	h
}
# If we ran above block, PATT will have only one word
# So if PATT has more than one word, proceed
/^[[:alnum:]]+ /{
	       # Append the held word (timestep) as a new line
	       G
	       # Remove new line and move timestep to first entry
	       s/(.*)\n(.*)/\2 \1/
	       # Print the new line to output
	       p
}