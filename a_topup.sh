#!/bin/bash

# Script for running topup

# Directories 
maindir=/media/hd1/TBI_dataset_BIDS/ # Main directory of the analysis
outdir=${maindir}derivatives/

#declare -a sublist=("sub-001" "sub-002" "sub-003" "sub-004" "sub-005")
declare -a sublist=("sub-001")

# Configuration files with paramenters
source=${maindir}sourcedata/
acqpar=${source}acqparams.txt # Acquisition parameters txt file, placed at this level because all the B0s have the same parameters (phase encoding and total readout time of the two merged images).
cfile=${source}b02b0.cnf # configuration file. A standard file provided by FSL
outf=_ap_pa

# Loop through all subjects in the defined list.
for u in "${sublist[@]}"; do		

	# Directories and filenames
	echo processing subject ${u} # The command line will show the subject name.
    out=${outdir}${u}
	t_out=${out}/dti/ # Where to save the topup output files for this subject
	mergedfmap=${out}/fmap/${u}_fieldmap_imain

	# Reduce z voxels from 55 to 54, so topup can work
    fslroi ${mergedfmap} ${mergedfmap}_trimmed 0 -1 0 -1 0 54
	echo "Running topup subject ${s}..."
    
    # imain is the merged volume of the B0s, datain is the acquisition parameters file, 
	topup --imain=${mergedfmap}_trimmed --datain=${acqpar} --config=${cfile} \
	--out=${t_out}${u}${outf}_run-topup --fout=${t_out}${u}${outf}_run-field \
	--iout=${t_out}${u}${outf}_run-unwarped_images
	
	echo "Topup done subject ${s}"

done