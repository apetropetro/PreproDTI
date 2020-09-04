#!/bin/bash

# Script for running eddy_openmp

# Directories 
maindir=/media/hd1/TBI_dataset_BIDS/ # Main directory of the analysis

#declare -a sublist=("sub-001" "sub-002" "sub-003" "sub-004" "sub-005")
declare -a sublist=("sub-001")

outdir=${maindir}derivatives/

# Configuration files with paramenters
source=${maindir}sourcedata/
acqpar=${source}acqparams.txt # Acquisition parameters txt file, placed at this level because all the B0s have the same parameters (phase encoding and total readout time of the two merged images).
outf=_ap_pa
indx=""; for ((i=1; i<=62; i+=1)); do indx="$indx 1"; done # Create an index file that tells eddy which line/of the lines in the acqparams.txt file that are relevant for the data passed into eddy

# Loop through all subjects in the defined list.
for u in "${sublist[@]}"; do		

	# Subject directories and filenames
	t_out=${outdir}${u}/dti/ # Where to save the topup output files for this subject

	# Before running eddy lets modify the input image so it has the same dinension of the mask. Reduce z voxels from 55 to 54
	# fslroi: arguments are minimum index and size (not maximum index). So to extract voxels 10 to 12 inclusive you would specify 10 and 3 (not 10 and 12).
	# fslroi <input> <output> <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
    fslroi ${maindir}${u}/dti/${u} ${t_out}${u}_trimmed  0 96 0 96 0 54

	echo "Run eddy_openmp on subject ${s}" 
	
	eddy_openmp --imain=${t_out}${u}_trimmed \
	--mask=${t_out}${u}${outf}_run-field_mag_brain --acqp=${acqpar} \
	--index=${source}index.txt --bvecs=${maindir}${u}/dti/${u}.bvec \
	--bvals=${maindir}${u}/dti/${u}.bval \
	--topup=${t_out}${u}${outf}_run-topup \
	--out=${t_out}${u}_eddy_corrected_data
	
	echo "Done with ${u} !"

done