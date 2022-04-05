#!/bin/bash

if [ -z ${MAKEFLAGS} ];
then 	
	echo "MAKEFLAGS is not set! You should set it if you have multiple cores!"
	exit 1
fi
