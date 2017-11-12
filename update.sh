#!/bin/bash

wd=`pwd`

cd build
make -j5 && make bench

cd $wd
