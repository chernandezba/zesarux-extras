100 REMark ==============================
105 REMark ******* 3DticTACtoe_bas ******
110 REMark ==============================
115 :
120 REMark            THE GAME
125 REMark        By T.J. Arnfield
130 REMark
135 REMark  Contributed by Sherm Waterman
140 REMark  Mods-Peter Hale & Ed Kingsley
150 REMark     On-screen Instructions
160 :
170 REMark      LRUN 3DticTACtoe_bas
180 :
200 CLEAR
202 initialise :REMark all game data and variables
204 display_board true% : REMark display empty board - once only
206 REPeat until_no_more_games
208   init_for_new_game
210   REPeat until_end_of_game
212     IF whos_go%=you% THEN
214       move%=get_your_move
216     ELSE
218       move%=generate_my_move
220     END IF
222     update_board (move%):result%=update_game_tables (move%)
224     IF result%<>game_not_over%: EXIT      until_end_of_game
226     whos_go%=whos_go%*-1
228   END REPeat until_end_of_game
230   new_game%=game_over (result%)
232   IF NOT new_game%:EXIT until_no_more_games
234   display_board false%
236 END REPeat until_no_more_games
238 CLOSE#4:CLOSE#5:STOP
240 :
300 DEFine FuNction generate_my_move
301   REMark ---------------------------
302   LOCal i,j,p%,sq%,my2_count%,your2_count%,val,maxval,pathv
304   CLS#5:PRINT#5,TO 3,"MY MOVE":PRINT#5,TO 5,"...THINKING"
306   IF moves%<2 THEN
308     PAUSE 75
310     IF board%(1)=0:RETurn 1
312     IF board%(4)=0:RETurn 4
314   END IF
316   IF moves%>4 THEN
318     p%=0
320     FOR i=1 TO 76
322       IF path_value(i)=me%*3:RETurn find_square(i)
324       IF path_value(i)=you%*3:p%=i
326     END FOR i
328     IF p%>0:RETurn find_square(p%)
330   END IF
332   maxval=-1:sq%=0
334   FOR i=1 TO 64
336     IF board%(i)=0 THEN
338       val=0:my2_count%=0:your2_count%=0
340       FOR j=1 TO sq_to_path%(i,0)
342         pathv=path_value(sq_to_path%(i,j))
344         IF pathv<>dead% THEN
346           IF pathv=2*me%:my2_count%=my2_count%+1
348           IF pathv=2*you%:your2_count%=your2_count%+1
350           val=val+ABS(pathv)+.2+5E-2*(pathv>0)
352         END IF
354       NEXT j
356         IF my2_count%>1:RETurn i
358         IF your2_count%>1:sq%=i*-1
360         IF val>maxval AND sq%>=0 THEN
362           maxval=val:sq%=i
364         END IF
366       END FOR j
368     END IF
370   END FOR i
372   RETurn ABS(sq%)
374 END DEFine generate_my_move
376 :
400 DEFine FuNction find_square (path%)
401   REMark ------------------------------
402   LOCal i
404   FOR i=1 TO 4
406     IF board%(winning_paths%(path%,i))=0:RETurn winning_paths%(path%,i)
408   END FOR i
410   STOP
412 END DEFine find_square
414 :
500 DEFine PROCedure update_board (m%)
501   REMark ----------------------------
502   board%(m%)=whos_go%:moves%=moves%+1
504   fill_previous_square
506   print_square m%,(whos_go%+3),1,true%
508 END DEFine update_board
510 :
600 DEFine FuNction update_game_tables (sq%)
601   REMark ----------------------------------
602   LOCal i,p%
604   FOR i=1 TO sq_to_path%(sq%,0)
606     p%=sq_to_path%(sq%,i)
608     IF path_value(p%)<>dead% THEN
610       IF path_value(p%)*whos_go%<0 THEN
612         path_value(p%)=dead%
614         dead_paths%=dead_paths%+1
616         IF dead_paths%=76:RETurn stalemate%
618       ELSE
620         path_value(p%)=path_value(p%)+whos_go%
622         IF path_value(p%)=4*whos_go% THEN
624           highlight_winning_path(p%)
626           RETurn whos_go%
628         END IF
630       END IF
632     END IF
634   END FOR i
636   RETurn game_not_over%
638 END DEFine update_game_tables
640 :
700 DEFine FuNction get_your_move
701   REMark ------------------------
702   LOCal x%,x,k%
704   CLS#5:PRINT#5,TO 5,"YOUR MOVE"
706   FOR x=1 TO 64:IF board%(x)=0:x%=x:EXIT x
708   REPeat until_enter
710     print_square x%,7,0,false%:x=x%
712     REPeat get_cursor
714       k%=CODE(INKEY$(-1))
716       IF k%=10:EXIT get_cursor
718       IF k%=32:x%=find_next_sq(x%,16): EXIT get_cursor
720       IF k%=192:x%=find_next_sq(x%,-1):EXIT get_cursor
722       IF k%=200:x%=find_next_sq(x%,1): EXIT get_cursor
724       IF k%=216:x%=find_next_sq(x%,4): EXIT get_cursor
726       IF k%=208:x%=find_next_sq(x%,-4):EXIT get_cursor
728     END REPeat get_cursor
730     print_square x,0,0,false%
732     IF k%=10:RETurn x%
734   END REPeat until_enter
736 END DEFine get_your_move
738 :
800 DEFine FuNction find_next_sq (start%,offset%)
801   REMark ---------------------------------------
802   LOCal x%
804   x%=start%
806   IF offset%=16:x%=(x%+15) DIV 16*16:offset%=1
808   REPeat find_empty_sq
810     x%=(x%+offset%+63) MOD 64+1
812     IF board%(x%)=0:RETurn x%
814   END REPeat find_empty_sq
816 END DEFine find_next_sq
818 :
900 DEFine PROCedure fill_previous_square
901   REMark --------------------------------
902   IF prev_ink<>0:INK#4,prev_ink:print_x%=save_x%:print_y%=save_y%:fill_square 1,false%
904 END DEFine fill_previous_square
906 :
1000 DEFine PROCedure print_square(sq%,ik%,fill%,half_sq%)
1001   REMark -----------------------------------------------
1002   LOCal plane%,col%,row%,locink%
1004   plane%=invert((sq%-1) DIV 16)
1006   row%=invert(((sq%-1) MOD 16) DIV 4)
1008   col%=(sq%-1) MOD 4
1010   print_x%=x0%+(col%*xsq%)+(row%*(x01%-x0%) DIV 4)
1012   print_y%=y0%+(plane%*y_diff%)+(row%*ysq%)
1014   INK#4,ik%
1016   IF half_sq% THEN
1018     save_x%=print_x%:save_y%=print_y%:prev_ink=ik%
1020   END IF
1022   fill_square fill%,half_sq%
1024   INK#4,0
1026 END DEFine print_square
1028 :
1100 DEFine FuNction invert(n%)
1101   REMark --------------------
1102   IF n%=0:RETurn 3
1104   IF n%=1:RETurn 2
1106   IF n%=2:RETurn 1
1108   RETurn 0
1110 END DEFine invert
1112 :
1200 DEFine PROCedure fill_square(fill%,half%)
1201   REMark -----------------------------------
1202   FILL#4,fill%
1204   IF NOT half% THEN
1206     LINE#4,print_x%+3,print_y%+1 TO print_x%+xsq%-1,print_y%+1 TO print_x%+xsq%-3+(x01%-x0%) DIV 4,print_y%+ysq%-1 TO print_x%+1+(x01%-x0%) DIV 4,print_y%+ysq%-1 TO print_x%+3,print_y%+1
1208   ELSE
1210     LINE#4,print_x%+3,print_y%+1 TO print_x%+xsq%-1,print_y%+1 TO print_x%+1+(x01%-x0%) DIV 4,print_y%+ysq%-1 TO print_x%+3,print_y%+1
1212   END IF
1214   FILL#4,0
1216 END DEFine fill_square
1218 :
1300 DEFine PROCedure highlight_winning_path (path%)
1301   REMark -----------------------------------------
1302   LOCal i,sq%
1304   FOR i=1 TO 4
1306     sq%=winning_paths%(path%,i)
1308     print_square winning_paths%(path%,i),7,1,true%
1310   END FOR i
1312 END DEFine highlight_winning_path
1314 :
1400 DEFine PROCedure init_board_variables
1401   REMark --------------------------------
1402   x0%=10:y0%=4:x1%=50:y1%=24:x01%=30:x11%=70:y_diff%=24
1404   xsq%=(x1%-x0%) DIV 4:ysq%=(y1%-y0%) DIV 4
1406 END DEFine init_board_variables
1408 :
1500 DEFine PROCedure display_board (init%)
1501   REMark --------------------------------
1502   prev_ink=0
1504   IF init% THEN
1506     PAPER#4,0:INK#4,7:CLS#4
1508     FOR i=0 TO 3
1510       FOR j=0 TO 4
1512         fromx%=x0%+(j*(x01%-x0%) DIV 4):fromy%=y0%+(i*y_diff%)+(ysq%*j)
1514         IF j=0 THEN
1516           FILL#4,1
1518           LINE#4,fromx%,fromy% TO fromx%+x1%-x0%,fromy% TO fromx%+x1%-x0%,fromy%-2 TO fromx%,fromy%-2 TO fromx%,fromy%
1520           FILL#4,0
1522         END IF
1524         LINE#4,fromx%,fromy% TO fromx%+x1%-x0%,fromy%
1526         fromx%=x0%+j*xsq%:fromy%=y0%+i*y_diff%
1528         LINE#4,fromx%,fromy% TO fromx%+x01%-x0%,fromy%+y1%-y0%
1530         IF j=4 THEN
1532           FILL#4,1
1534           LINE#4,fromx%,fromy% TO fromx%+x01%-x0%,fromy%+y1%-y0% TO fromx%+x01%-x0%,fromy%+y1%-y0%-2 TO fromx%,fromy%-2 TO fromx%,fromy%
1536           FILL#4,0
1538         END IF
1540       END FOR j
1542     END FOR i
1544   ELSE
1546     FOR i=1 TO 64
1548       IF board%(i)<>0:print_square i,0,1,false%
1550     END FOR i
1552   END IF
1554 END DEFine display_board
1556 :
1600 DEFine FuNction game_over(res%)
1601   REMark -------------------------
1602   LOCal r%:r%=true%
1604   CLS#5
1606   IF res%=you%:PRINT#5,"    YOU WIN"
1608   IF res%=me%:PRINT#5,"     I WIN !!"
1610   IF res%=stalemate%:PRINT#5,"  STALEMATE"
1612   PRINT#5," ANOTHER GAME ? Y/N";
1614   REPeat another_game
1616     q$=INKEY$(#5,-1)
1618     IF q$=="y":EXIT another_game
1620     IF q$=="n":r%=false%:EXIT another_game
1622   END REPeat another_game
1624   CLS#5:RETurn r%
1626 END DEFine game_over
1628 :
1700 DEFine PROCedure init_for_new_game
1701   REMark -----------------------------
1702   moves%=0:dead_paths%=0
1704   FOR i=1 TO 76:path_value(i)=0
1706   FOR i=1 TO 64:board%(i)=0
1708   IF RND<.5:whos_go%=you%:ELSE :whos_go%=me%
1710 END DEFine init_for_new_game
1712 :
1800 DEFine PROCedure initialise
1802   REMark --------------------
1804   DIM board%(64),winning_paths%(76,4),sq_to_path%(64,8)
1806   DIM path_value(76)
1808   MODE 4
1810   BORDER#1,0:PAPER#1,0:BORDER#2,0:PAPER#2,0:CLS#1:CLS#2
1814   OPEN#4,scr_250x206a130x0
1818   BORDER#4,2,4 : PAPER#4,7
1820   OPEN#5,con_250x44a130x211
1824   BORDER#5,2,4 : PAPER#5,0 : INK#5,7 : CLS#5 : CSIZE#5,2,1
1828   instructions
1830   init_winning_paths
1832   init_board_variables
1834   true%=(1=1):false%=(1=2)
1836   first%=true%:you%=-1:me%=1
1838   game_not_over%=0
1840   stalemate%=99
1842   dead%=99
1844   INK#5,2:CSIZE#5,1,0:PRINT#5,\TO 3,"PRESS ANY KEY WHEN READY":INK#5,7:PAUSE:CSIZE#5,2,1:CLS#5
1846 END DEFine initialise
1848 :
1900 DEFine PROCedure init_winning_paths
1901   REMark ------------------------------
1902   LOCal x%,no_of_datasets%,first%,sq_inc%,path_inc%,no_of_paths%,val%
1904   x%=1
1906   RESTORE 1942
1908   READ no_of_datasets%
1910   FOR i=1 TO no_of_datasets%
1912     READ first%,sq_inc%,path_inc%,no_of_paths%
1914     val%=first%
1916     FOR j=1 TO no_of_paths%
1918       FOR k=1 TO 4
1920         winning_paths%(x%,k)=val%
1922         sq_to_path%(val%,0)=sq_to_path%(val%,0)+1
1924         sq_to_path%(val%,sq_to_path%(val%,0))=x%
1926         val%=val%+sq_inc%
1928       END FOR k
1930       val%=val%-4*sq_inc%+path_inc%
1932       x%=x%+1
1934     END FOR j
1936   END FOR i
1938 END DEFine init_winning_paths
1940 :
1942 DATA 16
1944 DATA 1,1,4,16
1946 DATA 1,4,1,4
1948 DATA 17,4,1,4
1950 DATA 33,4,1,4
1952 DATA 49,4,1,4
1954 DATA 1,16,1,16
1956 DATA 1,5,16,4
1958 DATA 4,3,16,4
1960 DATA 1,17,4,4
1962 DATA 1,20,1,4
1964 DATA 13,12,1,4
1966 DATA 4,15,4,4
1968 DATA 1,21,0,1
1970 DATA 4,19,0,1
1972 DATA 13,13,0,1
1974 DATA 16,11,0,1
1976 :
2000 DEFine PROCedure instructions
2002   REMark ------------------------
2004   CLS#4 : INK#4,0
2006   PRINT#4,TO 1,"        ======================"
2008   PRINT#4,TO 1,"        3D NOUGHTS AND CROSSES"
2010   PRINT#4,TO 1,"        ======================"
2012   PRINT#4,\TO 2,"   This is the TIC TAC TOE game"
2014   PRINT#4,TO 2,"      in 3D on a 4x4x4x4 grid."
2016   PRINT#4,TO 2," The object of the game is to get 4"
2018   PRINT#4,TO 2," in a line, through all four grids,"
2020   PRINT#4,TO 2," at any angle, or on a single grid,"
2022   PRINT#4,TO 2," in any row or across the diagonal."
2024   PRINT#4,TO 2," When it's your move, use the arrow"
2026   PRINT#4,TO 2,"  keys to move your 'piece' in the"
2028   PRINT#4,TO 2," indicated direction,  or the SPACE"
2030   PRINT#4,TO 2," bar to move it onto the next plane"
2032   PRINT#4,TO 2," When you are at the square of your"
2034   PRINT#4,TO 2,"  choice,  press the ENTER key for"
2036   PRINT#4,TO 2," your move.  ALL WILL BECOME CLEAR."
2040   PRINT#4,\TO 2," PLEASE WAIT WHILE I INITIALISE THE"
2042   PRINT#4,TO 2,"  COMPUTER VARIABLES AND THE BOARD."
2044 END DEFine instructions
