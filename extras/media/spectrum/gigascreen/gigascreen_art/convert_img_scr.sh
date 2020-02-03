#!/bin/bash

INPUTFILE=$1

dd if=${INPUTFILE} of=${INPUTFILE}_frame1.scr bs=1 skip=0 count=6912
dd if=${INPUTFILE} of=${INPUTFILE}_frame2.scr bs=1 skip=6912 count=6912

