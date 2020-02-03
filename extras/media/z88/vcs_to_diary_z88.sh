#!/bin/sh

#TODO: Gestionar repeticiones (anuales, mensuales, etc)
#input file tiene que ser con formato unix, pasar si hace falta: dos2unix
#archivo de salida luego guardarlo en formato Mac con el kwrite
VCSFILE=`mktemp`
cp $1 $VCSFILE

Z88FILE=$2

REPETICION_ANYOS=10

#VCS:
#BEGIN:VEVENT
#DTSTART:20030315T130000Z
#DTEND:20030315T140000Z
#DCREATED:20070620T223124Z
#UID:libkcal-85480675.636
#SEQUENCE:0
#LAST-MODIFIED:20070620T223124Z
#X-ORGANIZER:MAILTO:
#RRULE:YM1 3 #0
#SUMMARY:Mi santo :-)
#CLASS:PUBLIC
#PRIORITY:5
#TRANSP:0
#X-PILOTID:136306712
#X-PILOTSTAT:0
#END:VEVENT

#ICS:
#BEGIN:VEVENT
#DTSTAMP:20071018T205146Z
#ORGANIZER:MAILTO:
#X-PILOTID:136306712
#X-PILOTSTAT:0
#CREATED:20070620T223124Z
#UID:libkcal-85480675.636
#SEQUENCE:0
#LAST-MODIFIED:20070620T223124Z
#SUMMARY:Mi santo :-)
#CLASS:PUBLIC
#PRIORITY:5
#RRULE:FREQ=YEARLY;BYMONTH=3
#DTSTART:20030315T130000Z
#DTEND:20030315T140000Z
#TRANSP:OPAQUE
#END:VEVENT

#Z88:
#%18/9/2007
#mi cumple
#30 anyitos
#
#%18/10/2007
#
#hoy

#eventos con repeticion
#cada mes
#BEGIN:VEVENT
#DTSTART:20071229T094500Z
#DTEND:20071229T114500Z
#DCREATED:20071220T230252Z
#UID:KOrganizer-1202891248.299
#SEQUENCE:0
#LAST-MODIFIED:20071220T230252Z
#X-ORGANIZER:MAILTO:
#RRULE:MD1 29 #0
#SUMMARY:prueba
#CLASS:PUBLIC
#PRIORITY:5
#TRANSP:0
#END:VEVENT

#cada anyo
#VCS:
#BEGIN:VEVENT
#DTSTART:20030315T130000Z
#DTEND:20030315T140000Z
#DCREATED:20070620T223124Z
#UID:libkcal-85480675.636
#SEQUENCE:0
#LAST-MODIFIED:20070620T223124Z
#X-ORGANIZER:MAILTO:
#RRULE:YM1 3 #0
#SUMMARY:Mi santo :-)
#CLASS:PUBLIC
#PRIORITY:5
#TRANSP:0
#X-PILOTID:136306712
#X-PILOTSTAT:0
#END:VEVENT


procesa_linea()
{

  echo -n "$1" | grep SUMMARY > /dev/null
  if [ $? == 0 ]; then
	VCS_SUMMARY=`echo -n "$1"|cut -d ':' -f2-`
        return
  fi

  echo -n "$1" | grep DTSTART > /dev/null
  if [ $? == 0 ]; then
	VCS_DTSTART=`echo -n "$1"|cut -d ':' -f2-`
        return
  fi

  echo -n "$1" | grep DTEND > /dev/null
  if [ $? == 0 ]; then
	VCS_DTEND=`echo -n "$1"|cut -d ':' -f2-`
        return
  fi

  echo -n "$1" | grep "RRULE:YM1" > /dev/null
  if [ $? == 0 ]; then
        VCS_RRULE="ANUAL"
        return
  fi



}

procesa_fecha ()
{
#DTSTART:20030315T130000Z
ANYO=`echo -n $1|cut -b 1-4`
MES=`echo -n $1|cut -b 5-6`
DIA=`echo -n $1|cut -b 7-8`
HORA=`echo -n $1|cut -b 10-11`
MINUTO=`echo -n $1|cut -b 12-13`

}

  RETURNCODE=0

  while [ $RETURNCODE == 0 ]
  do
    echo
    echo "Nuevo registro"
    echo
    VCS_SUMMARY=""
    VCS_DTSTART=""
    VCS_DTEND=""
    VCS_RRULE=""
    LINE="nada"

    while [ "$LINE" != "" ] && [ $RETURNCODE == 0 ] && [ "$LINE" != "\x0a" ]
    do
    read LINE 
    RETURNCODE=$?
    echo "$LINE"

    procesa_linea "$LINE"

    done 

    #procesar registro
    if [ "$VCS_SUMMARY" != "" ] && [ "$VCS_DTSTART" != "" ] && [ "$VCS_DTEND" != "" ]; then
	echo Sumario: $VCS_SUMMARY
	echo Inicio: $VCS_DTSTART
	echo Final: $VCS_DTEND

	procesa_fecha $VCS_DTSTART
	ANYO_INICIO=$ANYO
	MES_INICIO=$MES
	DIA_INICIO=$DIA
	HORA_INICIO=$HORA
	MINUTO_INICIO=$MINUTO

	procesa_fecha $VCS_DTEND
        ANYO_FINAL=$ANYO
        MES_FINAL=$MES
        DIA_FINAL=$DIA
        HORA_FINAL=$HORA
        MINUTO_FINAL=$MINUTO


	echo "Inicio " $ANYO_INICIO-$MES_INICIO-$DIA_INICIO-$HORA_INICIO-$MINUTO_INICIO

	echo "Final " $ANYO_FINAL-$MES_FINAL-$DIA_FINAL-$HORA_FINAL-$MINUTO_FINAL
#%18/9/2007
#mi cumple

	echo "%"$DIA_INICIO"/"$MES_INICIO"/"$ANYO_INICIO >> $Z88FILE
	echo "$VCS_SUMMARY" >> $Z88FILE
	echo >> $Z88FILE

	if [ "$VCS_RRULE" == "ANUAL" ]; then
	ANYO=0
		while [ $ANYO != $REPETICION_ANYOS ]; do
			ANYO_INICIO=$(($ANYO_INICIO+1))
			ANYO=$(($ANYO+1))
		        echo "%"$DIA_INICIO"/"$MES_INICIO"/"$ANYO_INICIO >> $Z88FILE
			     echo "$VCS_SUMMARY" >> $Z88FILE
			     echo >> $Z88FILE

		done	
	fi
	
    fi

    

  done < $VCSFILE


rm -f $VCSFILE
