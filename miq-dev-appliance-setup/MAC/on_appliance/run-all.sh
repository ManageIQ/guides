#!/bin/bash

HGFS_MIQ_DIR=${1:-miq}

STEPS=(
	software-install.sh
	vmware-tools-install.sh
	map-source.sh
	miq-setup.sh
)

(
	for STEP in ${STEPS[*]}
	do
		echo ">> $STEP START"
		./$STEP $HGFS_MIQ_DIR || exit 1
		echo ">> $STEP END"
		echo
	done
) 2>&1 | tee $(basename $0 .sh).log
