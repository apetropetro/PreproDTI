#!/bin/bash

# Script for running fslmaths and BET2 after topup

# Directories 
maindir=/media/hd1/TBI_dataset_BIDS/ # Main directory of the analysis
outdir=${maindir}derivatives/
outf=_ap_pa

#declare -a sublist=("sub-001" "sub-002" "sub-003" "sub-004" "sub-005")
declare -a sublist=("sub-001")

# Loop through all subjects in the defined list.
for u in "${sublist[@]}"; do		

	# Directories and filenames
	echo processing subject ${u} # The command line will show the subject name.
	t_out=${outdir}${u}/dti/ # Where to save the topup output files for this subject

	echo "Running fslmaths and BET subject ${s}..."
	# Convert to radians.
	fslmaths ${t_out}${u}${outf}_run-field -mul 6.28 ${t_out}${u}${outf}_run-field_rads
	# Generate a brain mask. Calculate the mean
	fslmaths ${t_out}${u}${outf}_run-unwarped_images -Tmean ${t_out}${u}${outf}_run-field_mag
	# Extract brain with Brain Extraction Tool (bet2) to create mask
	bet2 ${t_out}${u}${outf}_run-field_mag ${t_out}${u}${outf}_run-field_mag_brain -m -f 0.3 
	
	echo "Done with fslmaths and BET subject ${s}. Check BET visually after completion"	

done