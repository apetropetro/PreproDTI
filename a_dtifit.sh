#!/bin/bash

# Script for running dtifit

# Directories 
maindir=/media/hd1/TBI_dataset_BIDS/ # Main directory of the analysis
#sublist=${maindir}*sub-* # subject directories list
outdir=${maindir}derivatives/

#declare -a sublist=("sub-001" "sub-002" "sub-003" "sub-004" "sub-005" "sub-006" "sub-007" "sub-009" "sub-010" "sub-011" "sub-012" "sub-013" "sub-014" "sub-015" "sub-016" "sub-017" "sub-018" "sub-019" "sub-020" "sub-021" "sub-022" "sub-023" "sub-024" "sub-025" "sub-026" "sub-027" "sub-028" "sub-029" "sub-030" "sub-031" "sub-032" "sub-033" "sub-034" "sub-035" "sub-036" "sub-037" "sub-038" "sub-039" "sub-040" "sub-041" "sub-042" "sub-043" "sub-044" "sub-045" "sub-046" "sub-047" "sub-048" "sub-049" "sub-051" "sub-052" "sub-053" "sub-054" "sub-055" "sub-056" "sub-057" "sub-058" "sub-059" "sub-060" "sub-061" "sub-062" "sub-063" "sub-064" "sub-065" "sub-066" "sub-067" "sub-068" "sub-069" "sub-070" "sub-071" "sub-072" "sub-073" "sub-074" "sub-076" "sub-077" "sub-078" "sub-079" "sub-081" "sub-082" "sub-083" "sub-084" "sub-085" "sub-086" "sub-087" "sub-088" "sub-089" "sub-090" "sub-091" "sub-092" "sub-093" "sub-095" "sub-096" "sub-097" "sub-098" "sub-099" "sub-100" "sub-101" "sub-102" "sub-104" "sub-105" "sub-107" "sub-108" "sub-109" "sub-110" "sub-111" "sub-112" "sub-113" "sub-114" "sub-115" "sub-116" "sub-117" "sub-118" "sub-119" "sub-120" "sub-121" "sub-122" "sub-123" "sub-124" "sub-125" "sub-126" "sub-127" "sub-128" "sub-129" "sub-130" "sub-131" "sub-132" "sub-133" "sub-134" "sub-135" "sub-136" "sub-137" "sub-138" "sub-139" "sub-140" "sub-141" "sub-142" "sub-143" "sub-144" "sub-145" "sub-146" "sub-147" "sub-148" "sub-149" "sub-150" "sub-151" "sub-152" "sub-153" "sub-154" "sub-155" "sub-156" "sub-157" "sub-158" "sub-159" "sub-160" "sub-161" "sub-162" "sub-163" "sub-164" "sub-165" "sub-166" "sub-167" "sub-168" "sub-170" "sub-171" "sub-172" "sub-173" "sub-174" "sub-175" "sub-176" "sub-177" "sub-178" "sub-179" "sub-180" "sub-181" "sub-182" "sub-183" "sub-184" "sub-185" "sub-186" "sub-187" "sub-188" "sub-189" "sub-191" "sub-192" "sub-193" "sub-194" "sub-195" "sub-196" "sub-197" "sub-198" "sub-199" "sub-200" "sub-201" "sub-202" "sub-204" "sub-205" "sub-206" "sub-207" "sub-209" "sub-210")
declare -a sublist=("sub-001")
# to call an element and show it write: echo "${sublist[0]}"


# Loop through all subjects in the defined list.
for u in "${sublist[@]}"; do		
#for u in sub-002; do

	# Directories and filenames
	echo processing subject ${u} # The command line will show the subject name.
	t_out=${outdir}${u}/dti/ # Where to save the topup output files for this subject
	
	# Mask for DTIFIT, taken after eddy_openmp
	bet2 ${t_out}${u}_eddy_corrected_data ${t_out}${u}_eddy_corrected_data_brain -m -f 0.65 

	# DTIFIT
	# Compulsory arguments (You MUST set one or more of):
 #        -k,--data       dti data file
 #        -o,--out        Output basename
 #        -m,--mask       Bet binary mask file
 #        -r,--bvecs      b vectors file
 #        -b,--bvals      b values file

	dtifit -k ${t_out}${u}_eddy_corrected_data \
		-o ${t_out}${u}_tensor_fitted \
		-m ${t_out}${u}_eddy_corrected_data_brain_mask \
		-r ${t_out}${u}_eddy_corrected_data.eddy_rotated_bvecs \
		-b ${maindir}${u}/dti/${u}.bval --save_tensor
	

	#fslmaths ${dirO}${subj}/${subj}_L2.nii.gz -add ${dirO}${subj}/${subj}_L3.nii.gz -div 2 ${dirO}${subj}/${subj}_RD.nii.gz


	# /usr/local/ANTs/bin/ImageMath 4 ${dirO}${subj}/${subj}_Comp.nii.gz TimeSeriesDisassemble ${dirO}${subj}/${subj}_tensor.nii.gz
	# i=0
	# for index in xx xy xz yy yz zz;
	# do
	# mv ${dirO}${subj}/${subj}_Comp10${i}.nii.gz ${dirO}${subj}/${subj}_Comp_${index}.nii.gz
	# i=$((i+1))
	# done

	# /usr/local/ANTs/bin/ImageMath 3 ${dirO}${subj}/${subj}_dtAnts.nii.gz ComponentTo3DTensor ${dirO}${subj}/${subj}_Comp_


	echo "Done with ${u} !"

done