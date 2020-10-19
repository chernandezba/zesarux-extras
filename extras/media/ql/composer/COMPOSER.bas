100 REMark ==============================
102 REMark ******** COMPOSER_bas ********
104 REMark ==============================
106 :
108 REMark   QL COMPOSER by James Lucy
110 REMark    A program for writing,
112 REMark   Editing and playing back
114 REMark       Music on the QL
116 REMark
118 REMark  Contributed by  Peter Hale
120 REMark   With mods by Ed Kingsley
122 :
124 REMark    Program is menu driven
126 REMark   With on screen directions
128 REMark      And "HELP" screens
130 :
132 REMark      LRUN COMPOSER_bas
134 :
136 pre_initialise
138 welcome
140 initialise
142 metronome
144 REPeat loader_loop
146 notenum=notenum+1:pagenotecount=pagenotecount+1
148 IF notenum>899:notenum=notenum-1:pagenotecount=pagenotecount-1
150 REPeat check_input
152 er=0
154 IF pagenotecount=101:page=page+1:pagenotecount=1:CLS:stave:current_page=current_page+1
156 status
158 input_pitch:check_pitch:IF er THEN END REPeat check_input
160 convert_pitch:pitch(notenum)=p
162 input_duration:check_duration:IF er THEN END REPeat check_input
164 duration(notenum)=d
166 play p,d
168 display p,d,pagenotecount
170 END REPeat loader_loop
172 :
200 DEFine PROCedure stave
202 REMark -----------------
204 LOCal a,up
206 FOR up=85 TO 5 STEP -20
208  INK 7
210   FOR a=12 TO 0 STEP -3
212    LINE 1,up+a TO 140,up+a
214   END FOR a
216  INK 0
218  LINE 1,up TO 1,up+12
220  LINE 140,up TO 140,up+12
222 END FOR up
224 END DEFine stave
226 :
300 DEFine PROCedure crotchet(across,up)
302 REMark ------------------------------
304 FILL 1
306 semibreve across,up
308 FILL 0
310 stick
312 END DEFine
314 :
400 DEFine PROCedure minim(across,up)
402 REMark ---------------------------
404 semibreve across,up
406 stick
408 END DEFine
410 :
500 DEFine PROCedure semibreve(across,up)
502 REMark ------------------------------
504 CIRCLE across,up,1.5
506 END DEFine
508 :
600 DEFine PROCedure stick
602 REMark -----------------
604 IF p<12
606 LINE across-1.5,up TO across-1.5,up-8
608 ELSE
610 LINE across+1.5,up TO across+1.5,up+8
612 END IF
614 END DEFine
616 :
700 DEFine PROCedure quaver(across,up)
702 REMark ----------------------------
704 crotchet across,up
706 twiddle
708 END DEFine
710 :
800 DEFine PROCedure twiddle
802 REMark -------------------
804 IF p<12
806 LINE_R TO 2,3 TO 0,3
808 ELSE
810 LINE_R TO 2,-3 TO 0,-3
812 END IF
814 END DEFine
816 :
900 DEFine PROCedure semiquaver(across,up)
902 REMark ------------------------------
904 quaver across,up
906 doubletwiddle
908 END DEFine
910 :
1000 DEFine PROCedure doubletwiddle
1002 REMark -------------------------
1004 IF p<12
1006 LINE_R TO 0,-1 TO -2,-3
1008 ELSE
1010 LINE_R TO 0,1 TO -2,3
1012 END IF
1014 END DEFine doubletwiddle
1016 :
1100 DEFine PROCedure dot(across,up)
1102 REMark -------------------------
1104 FILL 1
1106 CIRCLE across+3,up,.5
1108 FILL 0
1110 END DEFine
1112 :
1200 DEFine PROCedure display(p,dd,nnm)
1202 REMark ----------------------------
1204 LOCal pp,ddd,nnnm:pp=p:nnnm=nnm:ddd=dd
1206 SELect ON nnm
1208  =1 TO 20:up=85:across=6.8*nnm
1210  =21 TO 40:up=65:across=6.8*(nnm-20)
1212  =41 TO 60:up=45:across=6.8*(nnm-40)
1214  =61 TO 80:up=25:across=6.8*(nnm-60)
1216  =81 TO 100:up=5:across=6.8*(nnm-80)
1218 END SELect
1220 sharp=0
1222 SELect ON pp
1224  =41:change=-6
1226  =38:change=-6:sharp=1
1228  =36:change=-4.5
1230  =33:change=-3
1232  =31:change=-3:sharp=1
1234  =28:change=-1.5
1236  =26:change=-1.5:sharp=1
1238  =24:change=0
1240  =22:change=1.5
1242  =20:change=1.5:sharp=1
1244  =19:change=3
1246  =17:change=3:sharp=1
1248  =15:change=4.5
1250  =14:change=4.5:sharp=1
1252  =12:change=6
1254  =11:change=7.5
1256  =10:change=7.5:sharp=1
1258  =9:change=9
1260  =8:change=9:sharp=1
1262  =7:change=10.5
1264  =6:change=12
1266  =5:change=12:sharp=1
1268  =4:change=13.5
1270  =3:change=13.5:sharp=1
1272  =0:change=.5
1274 END SELect
1276 staccato=0:legato=0
1278 up=up+change
1280 IF ddd>20 THEN ddd=ddd-20:legato=1
1282 IF ddd>10 THEN ddd=ddd-10:staccato=1
1284 IF p>28:sublines
1286 IF p<>0
1288 IF sharp THEN draw_sharp
1290 IF legato THEN draw_legato
1292 IF staccato THEN draw_staccato
1294 SELect ON ddd
1296  =.25:semiquaver across,up
1298  =.5:quaver across,up
1300  =.75:quaver across,up:dot across,up
1302  =1:crotchet across,up
1304  =1.5:crotchet across,up:dot across,up
1306  =2:minim across,up
1308  =3:minim across,up:dot across,up
1310  =4:semibreve across,up
1312 END SELect
1314 ELSE
1316 SELect ON ddd
1318  =.25:semiquaver_rest
1320  =.5:quaver_rest
1322  =1:crotchet_rest
1324  =2:minim_rest
1326  =4:semibreve_rest
1328 END SELect
1330 END IF
1332 END DEFine display
1334 :
1400 DEFine PROCedure play(p,dp)
1402 REMark ---------------------
1404 IF dp=0 THEN BEEP:RETurn
1406 IF p=0
1408 BEEP:PAUSE 3000*dp/metro_mark-2
1410 ELSE
1412 SELect ON dp
1414 ON dp=20 TO 100
1416 BEEP -100,p,pitch_2,grad_x,grad_y,wraps,fuzzy,random
1418 PAUSE 3000*(dp-20)/metro_mark-2
1420 ON dp=10 TO 19
1422 BEEP
1424 tim=3000*(dp-10)/metro_mark-2:PAUSE .15*tim
1426 BEEP dur,p,pitch_2,grad_x,grad_y,wraps,fuzzy,random
1428 PAUSE .7*tim
1430 BEEP
1432 PAUSE .15*tim
1434 ON dp=.25 TO 9
1436 BEEP dur,p,pitch_2,grad_x,grad_y,wraps,fuzzy,random
1438 PAUSE 3000*dp/metro_mark-2
1440 BEEP
1442 END SELect
1444 END IF
1446 END DEFine play
1448 :
1500 DEFine PROCedure convert_pitch
1502 REMark -------------------------
1504 p$=pitch$
1506 IF p$="z" :p=pitch(notenum-1)
1508 IF p$="r" THEN p=0
1510 IF p$="A":p=41
1512 IF p$="AS":p=38
1514 IF p$="B":p=36
1516 IF p$="C":p=33
1518 IF p$="CS":p=31
1520 IF p$="D":p=28
1522 IF p$="DS":p=26
1524 IF p$="E":p=24
1526 IF p$="F":p=22
1528 IF p$="FS":p=20
1530 IF p$="G":p=19
1532 IF p$="GS":p=17
1534 IF p$="a":p=15
1536 IF p$="as":p=14
1538 IF p$="b":p=12
1540 IF p$="c":p=11
1542 IF p$="cs":p=10
1544 IF p$="d":p=9
1546 IF p$="ds":p=8
1548 IF p$="e":p=7
1550 IF p$="f":p=6
1552 IF p$="fs":p=5
1554 IF p$="g":p=4
1556 IF p$="gs":p=3
1558 IF p$=="EDIT":editor:END REPeat check_input
1560 IF p$=="DELETE":delete_last_note:END REPeat check_input
1562 IF p$=="SAVE":store_music:END REPeat check_input
1564 IF p$=="PLAY":play_tune:END REPeat check_input
1566 IF p$=="LOAD":load_music:END REPeat check_input
1568 IF p$=="TIMBRE":sounds:END REPeat check_input
1570 IF p$=="HELP":help 0:END REPeat check_input
1572 END DEFine
1574 :
1600 DEFine PROCedure input_pitch
1602 REMark -----------------------
1604 CLS #0
1605 IF notenum>1:n$="NEXT":ELSE n$="FIRST"
1606 AT#0,1,2:INK#0,2:PRINT#0,"Type 'edit' for the EDITOR or 'help' for Directions":INK#0,0
1607 AT #0,0,10:PRINT#0,n$;" NOTE - PITCH ? ";:INPUT#0,pitch$;
1608 IF pitch$="input_pitch" THEN pitch$="z"
1610 END DEFine
1612 :
1700 DEFine PROCedure input_duration
1702 REMark --------------------------
1704 AT #0,0,35:INPUT#0,"DURATION ? ";duration$
1706 IF duration$="" THEN duration$="100"
1708 END DEFine
1710 :
1800 DEFine PROCedure initialise
1802 REMark ----------------------
1804 PAPER 0:CLS:WINDOW 448,200,32,16:PAPER 4:CLS
1806 OPEN #3,scr_448x20a32x236
1808 PAPER #3,2:INK#3,0:CSIZE#3,2,0:STRIP#3,4:CLS#3
1810 WINDOW #0,448,20,32,216:PAPER#0,7
1812 CSIZE#0,1,0:INK#0,0:CLS#0
1814 stave
1816 END DEFine initialise
1818 :
1900 DEFine PROCedure check_pitch
1902 REMark -----------------------
1904 IF pitch$="z" AND notenum<2:er=1
1906 IF LEN(pitch$)=2:IF pitch$(1)INSTR "ACDFGacdfg"=0 OR pitch$(2) INSTR "Ss"=0:er=1
1908 IF LEN(pitch$)>2:IF pitch$ INSTR "EDITeditDELETEdeleteSAVEsavePLAYplayloadLOADTIMBREtimbreHELPhelp"=0:er=1
1910 REMark END IF
1912 END DEFine check_pitch
1914 :
2000 DEFine PROCedure check_duration
2002 REMark --------------------------
2004 style$=" ":staccato=0:legato=0
2006 d$=duration$
2008 IF LEN(d$)>1
2010 ch$=d$(LEN(d$))
2012 IF ch$=="S" OR ch$=="L"
2014 style$=ch$
2016 d$=d$(1 TO (LEN(d$)-1))
2018 END IF
2020 END IF
2022 IF style$=="S":staccato=1:IF p=0 THEN er=1
2024 IF style$=="L":legato=1:IF p=0 THEN er=1
2026 IF d$=".25" OR d$="0.25" OR d$=".5" OR d$="0.5" OR d$=".75" OR d$="0.75" OR  d$="1" OR d$="1.5" OR d$="2" OR d$="3" OR d$="4" OR d$="100" THEN d=d$:ELSE er=1
2028 IF staccato THEN d=d+10
2030 IF legato THEN d=d+20
2032 IF notenum>1 AND d=100:d=duration(notenum-1)
2034 IF d=100 THEN er=1
2036 END DEFine check_duration
2038 :
2100 DEFine PROCedure metronome
2102 REMark ---------------------
2104 REPeat check_metro
2106 CLS#0
2108 AT#0,1,10:INK#0,2:PRINT#0,'Press <ENTER> for a Default of 200':INK#0,0
2110 AT#0,0,2:INPUT#0,"Metronome mark ? (beats per minute, 40 to 300): ";metro_mark$
2112 IF metro_mark$="" THEN metro_mark$="200"
2114 FOR c=1 TO LEN(metro_mark$)
2116 IF CODE(metro_mark$(c))<48 OR CODE(metro_mark$(c))>57:END REPeat check_metro
2118 END FOR c
2120 metro_mark=metro_mark$
2122 IF metro_mark<40 OR metro_mark>300:END REPeat check_metro
2124 CLS#0:BEEP 500,0
2126 status
2128 END DEFine metronome
2130 :
2200 DEFine PROCedure delete_last_note
2202 REMark ----------------------------
2204 REPeat deletel
2206 IF notenum=1 THEN RETurn
2208 IF pagenotecount=1 THEN RETurn
2210 notenum=notenum-1:pagenotecount=pagenotecount-1
2212 INK 4:display pitch(notenum),duration(notenum),pagenotecount:INK 0
2214 pitch(notenum)=0:duration(notenum)=0
2216 CLS#0:PRINT #0,"  Delete another note ? (y/n)"
2218 dln$=INKEY$(-1):IF dln$=="Y" :END REPeat deletel
2220 END DEFine delete_last_note
2222 :
2300 DEFine PROCedure play_tune
2302 REMark ---------------------
2304 FOR note=1 TO notenum-1
2306 play pitch(note),duration(note)
2308 END FOR note
2310 END DEFine play_tune
2312 :
2400 DEFine PROCedure crotchet_rest
2402 REMark -------------------------
2404 LINE across,up
2406 LINE_R TO -2,7 TO 2,-2 TO 2,2 TO 0,-.3 TO -2,-2 TO -2,2
2408 END DEFine
2410 :
2500 DEFine PROCedure quaver_rest
2502 REMark -----------------------
2504 LINE across,up
2506 LINE_R TO 2,7 TO -2,-2 TO -2,2 TO 0,-1 TO 2,-2 TO 2,2
2508 END DEFine
2510 :
2600 DEFine PROCedure semiquaver_rest
2602 REMark ---------------------------
2604 LINE across,up
2606 LINE_R TO 2,7 TO -2,-2 TO -2,2 TO 0,-1 TO 2,-2 TO 2,2 TO -1,-1 TO -2,-2 TO -2,2
2608 END DEFine
2610 :
2700 DEFine PROCedure minim_rest
2702 REMark ----------------------
2704 LINE across,up+5.5
2706 LINE_R TO 3,0 TO 0,.5 TO -3,0 TO 0,.5 TO 3,0
2708 END DEFine
2710 :
2800 DEFine PROCedure semibreve_rest
2802 REMark --------------------------
2804 LINE across,up+7.5
2806 LINE_R TO 3,0 TO 0,.5 TO -3,0 TO 0,.5 TO 3,0
2808 END DEFine
2810 :
2900 DEFine PROCedure editor
2902 REMark ------------------
2904 CLS#0
2906 REPeat editor_loop
2908 PRINT #0,"  c)ontinue,  (p)lay,  (a)lter note,  (s)elect page ?  "
2910 PRINT#0,TO 8,"Press (l)etter in brackets, then 'ENTER '";
2912 INPUT #0, choice$
2914 IF choice$="c"OR choice$="C" THEN
2916 IF current_page<>page THEN
2918 stt=(page-1)*100+1:CLS:stave:ntm=0
2920 FOR cpp=stt TO stt+pagenotecount-1:ntm=ntm+1:display pitch(cpp),duration(cpp),ntm
2922 current_page=page
2924 END IF
2926 EXIT editor_loop
2928 END IF
2930 IF choice$=="p" :play_page
2932 IF choice$=="a" :change_note
2934 IF choice$=="s" :show_page
2936 END REPeat editor_loop
2938 END DEFine editor
2940 :
3000 DEFine PROCedure show_page
3002 REMark ---------------------
3004 IF page=1 THEN RETurn
3006 REPeat check_page
3008 CLS#0:INPUT #0,"  Which page ?";page$
3010 IF CODE(page$)<49 OR CODE(page$)>57 THEN END REPeat check_page
3012 selected_page= page$(1)
3014 IF selected_page>page:END REPeat check_page
3016 IF selected_page=current_page THEN RETurn
3018 CLS:stave:cp=0
3020 sta=(selected_page-1)*100+1:sto=sta+99
3022 IF selected_page=page THEN sto=sta+pagenotecount
3024 FOR sp=sta TO sto
3026 cp=cp+1
3028 display pitch(sp),duration(sp),cp
3030 END FOR sp
3032 current_page=selected_page
3034 status
3036 END DEFine
3038 :
3100 DEFine PROCedure play_page
3102 REMark ---------------------
3104   show_page
3106 highlight=0:CLS#0
3108 PRINT#0," Press 'h' to highlight played notes - any key if not":high$=INKEY$(-1)
3110 IF high$=="h" :highlight=1
3112 REPeat check_sele
3114 CLS#0:PRINT #0,"(W)hole page, line(1), (2), (3), (4), (5), (m)etronome ?"
3116 PRINT#0,TO 10,"(Press letter or number in brackets)":ss$=INKEY$(-1)
3118 se=CODE(ss$)
3120 bp=(current_page-1)*100+1
3122 SELect ON se
3124  =119:start=bp:stp=bp+99:upp=85
3126  =87:start=bp:stp=bp+99:upp=85
3128  =49:start=bp:stp=start+19:upp=85
3130  =50:start=bp+20:stp=start+19:upp=65
3132  =51:start=bp+40:stp=start+19:upp=45
3134  =52:start=bp+60:stp=start+19:upp=25
3136  =53:start=bp+80:stp=start+19:upp=5
3138  =77:metronome:END REPeat check_sele
3140  =109:metronome:END REPeat check_sele
3142  =REMAINDER :END REPeat check_sele
3144 END SELect
3146 IF current_page=page :IF stp>bp+pagenotecount :stp=bp+pagenotecount
3148 IF current_page=page :IF start>pagenotecount+bp:RETurn
3150 IF highlight
3152 acrs=4.5:CSIZE 2,0:INK 6
3154 FOR note=start TO stp
3156 OVER -1:CURSOR acrs,upp,0,0:PRINT"¾"
3158 play pitch(note),duration(note)
3160 CURSOR acrs,upp,0,0:PRINT"¾"
3162 acrs=acrs+6.8:IF acrs>140 THEN acrs=4.5:upp=upp-20
3164 END FOR note
3166 OVER 0:INK 0
3168 ELSE
3170 FOR note=start TO stp:play pitch(note),duration(note)
3172 END IF
3174 END DEFine play_page
3176 :
3200 DEFine PROCedure drawpointer(h,ac)
3202 REMark ----------------------------
3204 OVER -1
3206 INK 7
3208 LINE ac,h-3
3210 FILL 1
3212 LINE_R TO 2,2 TO -2,2 TO -2,-2 TO 2,-2
3214 FILL 0
3216 INK 0
3218 OVER 0
3220 END DEFine drawpointer
3222 :
3300 DEFine PROCedure change_note
3302 REMark -----------------------
3304  show_page
3306 CLS#0:PRINT #0,"  Use cursor keys to move arrow to note to be changed"\TO 15,"Press 'c' when satisfied."
3308 counter =1:h=85:ac=6.8
3310 drawpointer h,ac
3312 REPeat cursor_loop
3314 cur$=INKEY$(-1)
3316 cur =CODE(cur$)
3318 limit=100:IF current_page=page THEN limit=pagenotecount-1
3320 SELect ON cur
3322 ON cur=192
3324 IF counter>1 THEN drawpointer h,ac:ac=ac-6.8:drawpointer h,ac:counter=counter-1:IF ac=0 THEN drawpointer h,ac:ac=136:h=h+20:drawpointer h,ac
3326 ON cur=200
3328 IF counter < limit THEN drawpointer h,ac:ac=ac+6.8:drawpointer h,ac:counter=counter+1:IF ac=142.8 THEN drawpointer h,ac:ac=6.8: h=h-20:drawpointer h,ac
3330 ON cur=208:IF counter > 20 THEN drawpointer h,ac:h=h+20:counter=counter-20:drawpointer h,ac
3332 ON cur=216:IF counter < limit-19 THEN drawpointer h,ac:h=h-20:counter=counter+20:drawpointer h,ac
3334 ON cur=67:make_change:drawpointer h,ac
3336 ON cur=99:make_change:drawpointer h,ac
3338 ON cur=REMAINDER :EXIT cursor_loop
3340 drawpointer h,ac
3342 END SELect
3344 END REPeat cursor_loop
3346 drawpointer h,ac
3348 END DEFine
3350 :
3400 DEFine PROCedure make_change
3402 REMark -----------------------
3404 note_number=(current_page-1)*100+counter
3406 CLS#0:AT#0,0,1:PRINT#0,"(d)elete note, (c)hange note, (i)nsert note, (e)scape":AT#0,1,10:INPUT#0,"Type a (l)etter and <ENTER>  ";act$
3408 drawpointer h,ac
3410 IF act$=="e" THEN CLS#0:editor
3412 IF act$=="d" :delete_note
3414 IF act$=="i" :insert_note
3416 IF act$=="c"
3418 INK 4:display pitch(note_number),duration(note_number),counter:INK 0
3420 REPeat check_new_note
3422 er=0
3424 input_pitch:check_pitch:IF er:END REPeat check_new_note
3426 convert_pitch
3428 input_duration:check_duration:IF er=1:END REPeat check_new_note
3430 display p,d,counter
3432 play p,d
3434 pitch(note_number)=p:duration(note_number)=d
3436 END IF
3438 :
3440 status
3442 CLS#0:AT#0,0,1:PRINT #0," To continue changes, press 'c' when arrow is at note":AT#0,1,7:PRINT #0," or ANY OTHER KEY TO RETURN TO THE EDITOR"
3446 END DEFine
3448 :
3500 DEFine PROCedure status
3502 REMark ------------------
3504 CLS#3
3506 AT #3,1,2:PRINT#3,"PAGE"!current_page!!!"NOTES"!notenum-1!!!"METRONOME ";metro_mark
3508 END DEFine
3510 :
3600 DEFine PROCedure sublines
3602 REMark --------------------
3604 IF p=33 OR p=31 :LINE across,up:LINE_R TO 4,0 TO -8,0
3606 IF p=36:LINE across,up+1.5:LINE_R TO 4,0 TO -8,0
3608 IF p=41 OR p=38:LINE across,up :LINE_R TO 4,0 TO -8,0:LINE_R 0,3 TO 8,0
3610 END DEFine
3612 :
3700 DEFine PROCedure delete_note
3702 REMark -----------------------
3704 INK 4:dn=counter-1
3706 en=(current_page-1)*100+100:IF current_page=page:en=en-100+pagenotecount
3708 FOR del=note_number TO en
3710 dn=dn+1
3712 display pitch(del),duration(del),dn
3714 END FOR del
3716 FOR shift=note_number TO notenum
3718 pitch(shift)=pitch(shift+1)
3720 duration(shift)=duration(shift+1)
3722 END FOR shift
3724 notenum=notenum-1
3726 pagenotecount=pagenotecount-1
3728 INK 0:dn=counter-1
3730 FOR redraw=note_number TO en
3732 dn=dn+1
3734 display pitch(redraw),duration(redraw),dn
3736 END FOR redraw
3738 END DEFine
3740 :
3800 DEFine PROCedure insert_note
3802 REMark -----------------------
3804 INK 4:ino=counter-1
3806 en=(current_page-1)*100+100:IF current_page=page:en=en-100+pagenotecount
3808 FOR ins=note_number TO en
3810 ino=ino+1
3812 display pitch(ins),duration(ins),ino
3814 END FOR ins
3816 REPeat check_inserted_note
3818 er=0
3820 input_pitch:check_pitch:IF er:END REPeat check_inserted_note
3822 convert_pitch
3824 input_duration:check_duration:IF er:END REPeat check_inserted_note
3826 INK 0:display p,d,counter
3828 play p,d
3830 FOR shove_along=notenum+1 TO note_number+1 STEP -1
3832 pitch(shove_along)=pitch(shove_along-1)
3834 duration(shove_along)=duration(shove_along-1)
3836 END FOR shove_along
3838 pitch(note_number)=p:duration(note_number)=d
3840 dn=counter-1
3842 FOR redraw=note_number TO en
3844 dn=dn+1
3846 display pitch(redraw),duration(redraw),dn
3848 END FOR redraw
3850 notenum=notenum+1:pagenotecount=pagenotecount+1
3852 END DEFine
3854 :
3900 DEFine PROCedure store_music
3902 REMark -----------------------
3904 CLS#0:PRINT#0,TO 8,"To SAVE type 'S' - or any key to continue":y$=INKEY$(-1)
3906 IF y$<>"s" AND y$<>"S" THEN RETurn
3908 REPeat check_saved_music
3910 CLS#0:INK#0,2:AT#0,1,1:PRINT#0,"Device must exist & not contain the same File name!":INK#0,0
3912 AT#0,0,1:INPUT#0,"Enter file name (eg, Flp1_opus1) ";stored_music$
3914 CLS#0:PRINT#0, TO 20,"Saving ";stored_music$:PRINT#0, TO 20,"Please be patient"
3916 n$=stored_music$&"    ":n$=n$(1 TO 5)
3918 IF n$(1 TO 5)=="mdv1_" OR n$(1 TO 5)=="mdv2_"OR n$(1 TO 5)=="flp1_" OR n$(1 TO 5)=="flp2_" OR n$(1 TO 5)=="ram1_":ELSE END REPeat check_saved_music
3920 OPEN_NEW #9,stored_music$
3922 FOR a=0 TO 950:PRINT#9,pitch(a)
3924 FOR a=0 TO 950:PRINT#9,duration(a)
3926 PRINT #9,notenum:PRINT#9,pagenotecount:PRINT#9,page:PRINT#9,metro_mark
3928 CLOSE #9
3930 REMark
3932 REMark
3934 END DEFine
3936 :
4000 DEFine PROCedure load_music
4002 REMark ----------------------
4004 CLS#0:PRINT#0,TO 1,"LOAD: Press 'L' to continue - any other key to return":y$=INKEY$(-1)
4006 IF y$<>"l" AND y$<>"L" THEN RETurn
4008 REPeat check_stored_music
4010 CLS#0:PRINT#0,TO 3,"Enter File name of stored music : (e.g. mdv1_opus1)"\TO 3
4012 INPUT #0,stored_music$
4014 n$=stored_music$&"     ":n$=n$(1 TO 5)
4016 IF n$(1 TO 5)=="mdv1_" OR n$(1 TO 5)="mdv2_" OR n$(1 TO 5)=="flp1_" OR n$(1 TO 5)=="flp2_" OR n$(1 TO 5)=="ram1_":ELSE END REPeat check_stored_music
4018 CLS:stave
4020 OPEN_IN#9,stored_music$
4022 FOR a=0 TO 950:INPUT#9,pitch(a)
4024 FOR a=0 TO 950:INPUT#9,duration(a)
4026 INPUT#9,notenum:INPUT#9,pagenotecount:INPUT#9,page:INPUT#9,metro_mark
4028 CLOSE#9
4030 current_page=1
4032 lim=100:IF notenum<100 THEN lim=notenum+1
4034 FOR a=1 TO lim:display pitch(a),duration(a),a
4036 status
4038 editor
4040 END DEFine
4042 :
4100 DEFine PROCedure sounds
4102 REMark ------------------
4108 CLS#0: PRINT#0,TO 9,"Press 'T' to change Tone characteristics"\ TO 12,"or any other key to return to menu"
4110 y$=INKEY$(-1)
4111 IF y$<>"T" AND y$<>"t" THEN dur=-1:pitch_2=0:grad_x=0:grad_y=0:wraps=0:fuzzy=0:random=0:RETurn :END IF
4112 CLS#0:INPUT#0,"  Duration:  (-32768 to 32767) ";dur
4114 INPUT#0,"  Pitch_2 :  (0 to 255) ";pitch_2
4116 INPUT#0,"  Grad_x  :  (-32768 to 15) ";grad_x
4118 INPUT#0,"  Grad_y  :  (-8 to 7)  ";grad_y
4120 INPUT#0,"  Wraps   :  (0 to 32767)  ";wraps
4122 INPUT#0,"  Fuzzy   :  (0 to 15)  ";fuzzy
4124 INPUT#0,"  Random  :  (0 to 15)  ";random
4126 END DEFine sounds
4128 :
4200 DEFine PROCedure draw_sharp
4202 REMark ----------------------
4204 CSIZE 0,0
4206 CURSOR across-4,up+2,0,0
4208 PRINT "#"
4210 END DEFine draw_sharp
4212 :
4300 DEFine PROCedure draw_legato
4302 REMark -----------------------
4304 IF p<13
4306 LINE across,up-change+13
4308 ARC_R TO 6.8,0,-PI/2
4310 ELSE
4312 LINE across,up+9
4314 ARC_R TO 6.8,0,-PI/2
4316 END IF
4318 END DEFine
4320 :
4400 DEFine PROCedure draw_staccato
4402 REMark -------------------------
4404 FILL 1
4406 IF p<12
4408 CIRCLE across,up+3,.5
4410 ELSE
4412 CIRCLE across,up-3,.5
4414 END IF
4416 FILL 0
4418 END DEFine
4420 :
4500 DEFine PROCedure help(intro)
4502 REMark ----------------------
4504 PAPER 5:CLS: INK 0:CSIZE 3,1
4506 AT 0,11:UNDER 1:PRINT"HELP":UNDER 0
4508 CSIZE 0,0
4510 PRINT\" The pitches of notes entered start at A to G, then rising a to g. Sharps  are entered by adding an 'S' or 's'. Rests are entered using 'R' or 'r'.  The treble clef applies to all stave lines."
4512 PRINT\" You may also type EDIT, DELETE, SAVE, LOAD, PLAY, TIMBRE or HELP in       answer to the PITCH ? prompt."
4514 PRINT\" EDIT - Enters  the  editor.  You  may  select a page and can then delete, insert, or change notes. Pressing 'c'ontinue redraws the last page of     your music. 'P'lay allows any part of the music to be played."
4516 PRINT\" DELETE - Deletes last note drawn.  For immediately noticed mistakes."
4518 PRINT\" SAVE - Saves the music to a Device. Must be drive 1 or 2 . File name must be valid and not yet exist."
4520 INK 7:AT 19,20:PRINT"PRESS ANY KEY TO CONTINUE:":PAUSE:INK 0
4522 CLS
4524 PRINT\" LOAD - Deletes any music on the screen and loads music from a File."
4526 PRINT\" PLAY - Plays all or part of a piece from beginning."
4528 PRINT\" TIMBRE - Allows sound parameters to be reset. Sound effects may be played like music.  Press 'm' to return to music parameters."
4532 PRINT\" The DURATION ? prompt takes notes in numerical form, assuming a crotchet  = 1. The allowed values are .5, .75, 1, 1.5, 2, 3, 4 i.e. from semiquaver to semibreve.  A staccato note may be specified by adding an 's' after    the number and a legato note an 'l' e.g.  2l."
4534 PRINT\" Both  PITCH  and  DURATION  inputs  'auto  repeat' - they  default to the previous value if 'ENTER' is pressed."
4536 PRINT\" No more information."
4538 AT 19,22:INK 7:PRINT"PRESS ANY KEY TO RETURN"
4540 PAUSE:INK 0
4542 IF intro THEN RETurn
4544 PAPER 4:CLS:stave
4546 star=(current_page-1)*100+1:spot=star+99
4548 IF current_page=page THEN spot=star+pagenotecount
4550 pp=0:FOR rp=star TO spot: pp=pp+1:display pitch(rp),duration(rp),pp
4552 REMark
4554 REMark
4556 REMark
4558 END DEFine help
4560 :
4600 DEFine PROCedure welcome
4602 REMark -------------------
4604 MODE 4:WINDOW 512,256,0,0:PAPER 4,2,0:CLS
4606 STRIP 1:PAPER 7:INK 0:CSIZE 2,1:AT 3,12:PRINT"   QL   COMPOSER   "
4608 AT 6,18:PRINT"  by  "
4610 AT 8,15:PRINT" James Lucy "
4612 AT 10,18:CSIZE 1,0:PRINT" (c) 1985 "
4614 PAUSE 100
4616 PAPER 4,2,0:CLS:PAPER 7:CSIZE 2,0
4618 AT 5,6:PRINT" Press 'I' for more Information "
4620 AT 8,6:PRINT" Press 'D' for a Demonstration  "
4622 AT 11,6:PRINT" Press 'S' to Start the program "
4624 STRIP 0
4626 REPeat check_choice
4628 cho$=INKEY$(-1)
4630 IF cho$ INSTR "iIsSdD"=0:END REPeat check_cho
4632 IF cho$=="S":RETurn
4634 IF cho$=="D":demo
4636 IF cho$=="I" THEN
4638 WINDOW 448,220,32,16
4640 PAPER 5:CLS
4642 PRINT\"  QL COMPOSER accepts musical notes  typed in by the user, displays them  on a stave and plays them. "
4644 PRINT\"  Notes can be inserted, deleted or  changed  and  can be played staccato,legato, or  normally.  The speed of  playing can be varied; the program   accepts the standard metronome mark. "
4646 PRINT\"  The program starts by requesting a metronome mark.  Press enter for the default value.  A pitch will then be requested, which can be used to enterthe  first  note  or  to  enter the  commands listed on the help screen."
4648 AT 19,7:STRIP 1:PAPER 7:CSIZE 1,0:PRINT"Press any key to view help screen.":PAUSE:STRIP 0
4650 help 1
4652 PAPER 5:CLS:STRIP 1:PAPER 7:INK 0
4654 AT 10,0:CSIZE 1,0:PRINT" Press 'D' for a Demonstration, 'S' to Start the program":STRIP 0
4656 REPeat check_ch
4658 cho$=INKEY$(-1)
4660 IF cho$ INSTR "dsDS"=0:END REPeat check_ch
4662 IF cho$=="s":RETurn
4664 demo
4666 END IF
4668 END DEFine welcome
4670 :
4700 DEFine PROCedure demo
4702 REMark ----------------
4704 PAPER 0:CLS:WINDOW 448,200,32,16:PAPER 4:CLS
4706 DIM demop(35),demod(35)
4708 stave:RESTORE :draw_clef 8,85
4710 STRIP 1:PAPER 7:CSIZE 0,0:AT 10,14:PRINT" Extract from Beethoven's Ninth Symphony ":STRIP 0:PAPER 4
4712 FOR red=3 TO 32: READ demop(red),demod(red):display demop(red),demod(red),red
4714 FOR red=3 TO 32:play demop(red),demod(red)
4716 DATA 20,1,20,1,19,1,15,1,15,1,19,1,20,1,24,1,28,1,28,1,24,1,20,1,20,1.5
4718 DATA 24,.5,24,2,20,1,20,1,19,1,15,1,15,1,19,1,20,1,24,1,28,1,28,1,24,1
4720 DATA 20,1,24,1.5,28,.5,28,2
4722 REMark
4724 REMark
4726 END DEFine demo
4728 :
4800 DEFine PROCedure pre_initialise
4802 REMark --------------------------
4804 DIM pitch(950):DIM duration (950)
4806 notenum=0:pagenotecount=0:page=1:current_page=1:metro_mark=160
4808 dur=-1:pitch_2=0:grad_x=0:grad_y=0:wraps=0:fuzzy=0:random=0
4810 END DEFine pre_initialize
4812 :
4900 DEFine PROCedure draw_clef(x,y)
4902 REMark -------------------------
4904 LINE x,y+1.5
4906 ARC_R TO 0,4.5,-PI TO 0,-6,-PI TO -3,7,-3*PI/4
4908 LINE_R TO 5,7:ARC_R TO -2,0,PI
4910 LINE_R TO 0,-18
4912 FILL 1:CIRCLE_R -1,0,1:FILL 0
4914 END DEFine draw_clef
