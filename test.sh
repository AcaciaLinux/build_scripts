#!/bin/bash

if [ -z ${ROOTDIR} ];
then 	
	echo "ROOTDIR is not set!"
	exit 1
fi

{ time echo \"This is mine!\"; } 2>&1 | tee monn.txt
