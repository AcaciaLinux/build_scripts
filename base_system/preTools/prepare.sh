#!/bin/bash

#Error if a command fails
set -e

#Check for the PKG_NAME variable
if [ -z ${PKG_NAME} ];
then 	
	echo "PKG_NAME variable is not set!"
	exit 1
fi

#Check for the PKG_VERSION variable
if [ -z ${PKG_VERSION} ];
then
	echo "PKG_VERSION variable is not set!"
	exit 1
fi

#Check for the PKG_TARFILE variable
if [ -z ${PKG_TARFILE} ];
then
	echo "PKG_TARFILE variable is not set!"
	exit 1
fi

#Check for the SOURCES_DIR variable
if [ -z ${SOURCES_DIR} ];
then
	echo "SOURCES_DIR variable is not set!"
	exit 1
fi

#Check for the PACKAGES_DIR variable
if [ -z ${PACKAGES_DIR} ];
then
	echo "PACKAGES_DIR variable is not set!"
	exit 1
fi

#Check for the BUILD_CACHE_DIR variable
if [ -z ${BUILD_CACHE_DIR} ];
then
	echo "BUIlD_CACHE_DIR variable is not set!"
	exit 1
fi

#Check for the BUILD_LOGS_DIR variable
if [ -z ${BUILD_LOGS_DIR} ];
then
	echo "BUILD_LOGS_DIR variable is not set!"
	exit 1
fi

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/preTools/${PKG_NAME}-${PKG_VERSION}

#Create the necessary directories
mkdir -pv ${BUILD_LOGS_DIR}/preTools/${PKG_NAME}-${PKG_VERSION}/
mkdir -pv ${PACKAGES_DIR}/preTools/${PKG_NAME}-${PKG_VERSION}/
mkdir -pv ${PKG_BUILD_DIR}

#Untar the package
tar xpf ${SOURCES_DIR}/${PKG_TARFILE} -C ${BUILD_CACHE_DIR}/preTools

echo ${PKG_BUILD_DIR}
