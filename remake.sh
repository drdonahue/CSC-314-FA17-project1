#!/bin/bash
wd=`pwd`

cd build
make clean
../glibc-2.26/configure --prefix=`pwd`/../glibc-install && make -j5 && make bench

cd $wd
