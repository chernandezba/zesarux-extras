#!/bin/bash

  NUM=0

  LINE=""

  while [ 1 ]
  do
    read LINE || break
	echo -n "$((2#$LINE)),"

	NUM=$(($NUM+1))
	if [ $NUM == 8 ]; then
		echo
		NUM=0
	fi

  done < $1


