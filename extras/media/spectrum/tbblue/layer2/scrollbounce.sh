#!/bin/bash


# Example script to "bounce" layer2 display by using ZRCP

POSX=90
POSY=5
INCX=+1
INCY=+1

while [ 1 == 1 ]; do


	echo "$POSX $POSY"
	(sleep 0.1 ; echo "tbblue-set-register 22 $POSX" ; sleep 0.1 ; echo "tbblue-set-register 23 $POSY" ; echo "quit") | telnet localhost 10000

	POSX=$(($POSX+$INCX))
	POSY=$(($POSY+$INCY))

	# horizontal limits. invert direction
	if [ $POSX -gt 255 ] || [ $POSX -lt 1 ]; then
		INCX=$((0-$INCX))
		POSX=$(($POSX+$INCX))
	fi
	
	# vertical. invert direction
	if [ $POSY -gt 255 ] || [ $POSY -lt 1 ]; then
		INCY=$((0-$INCY))
		POSY=$(($POSY+$INCY))
	fi
	

done
