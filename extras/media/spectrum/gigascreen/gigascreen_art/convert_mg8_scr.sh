#!/bin/bash

INPUTFILE=$1

dd if=${INPUTFILE} of=${INPUTFILE}_frame1_pixels.scr bs=1 skip=256 count=6144
dd if=${INPUTFILE} of=${INPUTFILE}_frame1_colours.scr bs=1 skip=12544 count=768
cat ${INPUTFILE}_frame1_pixels.scr > ${INPUTFILE}_frame1.scr
cat ${INPUTFILE}_frame1_colours.scr >> ${INPUTFILE}_frame1.scr
rm -f ${INPUTFILE}_frame1_pixels.scr
rm -f ${INPUTFILE}_frame1_colours.scr

dd if=${INPUTFILE} of=${INPUTFILE}_frame2_pixels.scr bs=1 skip=6400 count=6144
dd if=${INPUTFILE} of=${INPUTFILE}_frame2_colours.scr bs=1 skip=13312 count=768
cat ${INPUTFILE}_frame2_pixels.scr > ${INPUTFILE}_frame2.scr 
cat ${INPUTFILE}_frame2_colours.scr >> ${INPUTFILE}_frame2.scr 

rm -f ${INPUTFILE}_frame2_pixels.scr
rm -f ${INPUTFILE}_frame2_colours.scr

