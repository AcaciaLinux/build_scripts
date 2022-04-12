#!/bin/bash
set +e

#Check for the BUILD_LOGS_DIR variable
if [ -z ${BUILD_LOGS_DIR} ];
then
	echo "BUILD_LOGS_DIR variable is not set!"
	exit 1
fi

{ time ./preTools/perl-5.34.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/perl-5.34.0.log
{ time ./preTools/python-3.10.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/python-3.10.2.log
{ time ./preTools/texinfo-6.8.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/texinfo-6.8.log

{ time ./man-pages-5.13.sh  ; } 2>&1 | tee ${BUILD_LOGS_DIR}/man-pages-5.13.log
{ time ./iana-etc-20220207.sh  ; } 2>&1 | tee ${BUILD_LOGS_DIR}/.log
{ time ./glibc-2.35.sh  ; } 2>&1 | tee ${BUILD_LOGS_DIR}/.log
{ time ./zlib-1.2.11.sh  ; } 2>&1 | tee ${BUILD_LOGS_DIR}/.log
{ time ./bzip2-1.0.8.sh   ; } 2>&1 | tee ${BUILD_LOGS_DIR}/.log
{ time ./xz-5.2.5.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/.log
{ time ./zstd-1.5.2.sh  ; } 2>&1 | tee ${BUILD_LOGS_DIR}/.log
{ time ./file-5.41.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/file-5.41.log
{ time ./readline-8.1.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/readline-8.1.2.log
{ time ./m4-1.4.19.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/m4-1.4.19.log
{ time ./bc-5.2.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/bc-5.2.2.log
{ time ./flex-2.6.4.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/flex-2.6.4.log
{ time ./tcl-8.6.12.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/tcl-8.6.12.log
{ time ./expect-5.45.4.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/expect-5.45.4.log
{ time ./dejagnu-1.6.3.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/dejagnu-1.6.3.log
{ time ./binutils-2.38.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/binutils-2.38.log
{ time ./gmp-6.2.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gmp-6.2.1.log
{ time ./mpfr-4.1.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/mpfr-4.1.0.log
{ time ./mpc-1.2.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/mpc-1.2.1.log
{ time ./attr-2.5.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/attr-2.5.1.log
{ time ./acl-2.3.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/acl-2.3.1.log
{ time ./libcap-2.63.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/libcap-2.63.log
{ time ./shadow-4.11.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/shadow-4.11.1.log
{ time ./gcc-11.2.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gcc-11.2.0.log
{ time ./pkg-config-0.29.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/pkg-config-0.29.2.log
{ time ./ncurses-6.3.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/ncurses-6.3.log
{ time ./sed-4.8.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/sed-4.8.log
{ time ./psmisc-23.4.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/psmisc-23.4.log
{ time ./gettext-0.21.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gettext-0.21.log
{ time ./bison-3.8.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/bison-3.8.2.log
{ time ./grep-3.7.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/grep-3.7.log
{ time ./bash-5.1.16.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/bash-5.1.16.log
{ time ./libtool-2.4.6.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/libtool-2.4.6.log
{ time ./gdbm-1.23.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gdbm-1.23.log
{ time ./gperf-3.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gperf-3.1.log
{ time ./expat-2.4.6.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/expat-2.4.6.log
{ time ./inetutils-2.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/inetutils-2.2.log
{ time ./less-590.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/less-590.log
{ time ./perl-5.34.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/perl-5.34.0.log
{ time ./xml-parser-2.46.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/xml-parser-2.46.log
{ time ./intltool-0.51.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/intltool-0.51.0.log
{ time ./autoconf-2.71.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/autoconf-2.71.log
{ time ./automake-1.16.5.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/automake-1.16.5.log
{ time ./openssl-3.0.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/openssl-3.0.1.log
{ time ./kmod-29.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/kmod-29.log
{ time ./libelf-0.186.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/libelf-0.186.log
{ time ./libffi-3.4.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/libffi-3.4.2.log
{ time ./python-3.10.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/python-3.10.2.log
{ time ./ninja-1.10.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/ninja-1.10.2.log
{ time ./meson-0.61.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/meson-0.61.1.log
{ time ./coreutils-9.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/coreutils-9.0.log
{ time ./check-0.15.2.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/check-0.15.2.log
{ time ./diffutils-3.8.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/diffutils-3.8.log
{ time ./gawk-5.1.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gawk-5.1.1.log
{ time ./findutils-4.9.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/findutils-4.9.0.log
{ time ./groff-1.22.4.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/groff-1.22.4.log
{ time ./gzip-1.11.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/gzip-1.11.log
{ time ./iproute2-5.16.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/iproute2-5.16.0.log
{ time ./kbd-2.4.0.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/kbd-2.4.0.log
{ time ./libpipeline-1.5.5.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/libpipeline-1.5.5.log
{ time ./make-4.3.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/make-4.3.log
{ time ./patch-2.7.6.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/patch-2.7.6.log
{ time ./tar-1.34.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/tar-1.34.log
{ time ./texinfo-6.8.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/texinfo-6.8.log
{ time ./vim-8.2.4383.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/vim-8.2.4383.log
{ time ./markupsafe-2.0.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/markupsafe-2.0.1.log
{ time ./jinja2-3.0.3.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/jinja2-3.0.3.log
{ time ./systemd-250.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/systemd-250.log
{ time ./d-bus-1.12.20.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/d-bus-1.12.20.log
{ time ./man-db-2.10.1.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/man-db-2.10.1.log
{ time ./procps-ng-3.3.17.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/procps-ng-3.3.17.log
{ time ./util-linux-2.37.4.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/util-linux-2.37.4.log
{ time ./e2fsprogs-1.46.5.sh ; } 2>&1 | tee ${BUILD_LOGS_DIR}/e2fsprogs-1.46.5.log

echo "DONE building base!"
