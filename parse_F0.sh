#!/bin/bash
# Usage: ./parse_F0.sh wham_meta_fname wham_out_fname

usage () {
    cat <<HELP_USAGE

    $0  <wham_meta_fname> <wham_out_fname>

    Adds N and F0 information needed for reweighting to a new f0s.<wham_meta_fname> wham meta file
    <wham_meta_fname> wham metafile used to generate wham free energy surface
    <wham_out_fname> output of wham command redirected to this file. (NB: this is not the FES file).
HELP_USAGE
    exit 0
}

[ -z $2 ] && { usage; }

# Count Number of Umbrellas considered
nBias=$(grep -c -v '^#' $1)

# Create Empty Temp Files for Number of Samples and F0 per umbrella
echo n > temp_nr
echo f0 > temp_f0

# Grab F0 from wham output
sed '/#MC trial/q' $2 | tail -n $((nBias+1)) | head -n $nBias | awk '{print $3}' >> temp_f0

# Determine Number of Samples in each umbrella
for f in $(grep -v '^#' $1 | awk '{print $1}'); do
  grep -c -v '^#' $f >> temp_nr
done

# Combine Files & Clean Up
paste -d ' ' $1 temp_f0 temp_nr > f0s.$1
rm temp_nr
rm temp_f0
