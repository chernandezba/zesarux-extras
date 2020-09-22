100 REMark Q-Draughts
110 WINDOW #0,512,256,0,0 : PAPER #0,7 : INK #0,0 : CLS #0 : CSIZE #0,2,0
120 DRAW_BOARD
130 :
140 DIM bestmove(3) : REMark 0=best score,1-2=from square,3-4=to square
150 best_move = -999 : REMark means no best move yet
160 DIM board(7,7) : REMark 0,0 is bottom left, i.e. A0
170 RESTORE 
180 FOR y = 7,6,5,2,1,0
190   FOR x = 0 TO 7 : READ board(x,y)
200 END FOR y
210 REMark computer pieces for top of screen
220 DATA 0,-1,0,-1,0,-1,0,-1
230 DATA -1,0,-1,0,-1,0,-1,0
240 DATA 0,-1,0,-1,0,-1,0,-1
250 DATA 1,0,1,0,1,0,1,0
260 DATA 0,1,0,1,0,1,0,1
270 DATA 1,0,1,0,1,0,1,0
280 :
290 REPeat this_game
300   best_move = -999 : REMark no best move yet
310   REPeat QL_move
320     eval = 0
330     FOR x = 0 TO 7
340       FOR y = 0 TO 7
350         IF board(x,y) < 0 THEN 
360           REMark this square contains a QL piece
370           FOR across = -1,1
380             FOR up = -1 TO (-1+(2*(board(x,y) = -2))) STEP 2
390               SCAN_AROUND
400             END FOR up
410           END FOR across
420         END IF 
430       END FOR y
440     END FOR x
450     REMark if QL cannot move...
460     IF best_move = -999 THEN EXIT QL_move
470     REMark implement best move
480     board(bestmove(2),bestmove(3)) = board(bestmove(0),bestmove(1))
490     board(bestmove(0),bestmove(1)) = 0 : REMark blank FROM square
500     AT #0,8,24 : CLS #0,4
510     PRINT #0,CHR$(65+bestmove(0));bestmove(1);' TO ';
520     PRINT #0,CHR$(65+bestmove(2));bestmove(3);
530     CLEAR_SQUARE bestmove(0),bestmove(1)
540     SHOW_PIECE_AT bestmove(2),bestmove(3)
550     IF bestmove(3) = 0 AND board(bestmove(2),bestmove(3)) = -1 THEN 
560       REMark crown QL piece which has moved to row A
570       board(bestmove(2),bestmove(3)) = -2 : REMark QL crown value
580       SHOW_PIECE_AT bestmove(2),bestmove(3)
590     END IF 
600     REMark source and destination squares set, but not in-between
610     REMark (jumped) squares at this point.
620     REMark bale out if not a jump (move finished)
630     IF ABS(bestmove(0)-bestmove(2)) <> 2 THEN EXIT QL_move
640     REPeat jumps
650       REMark jumped a player piece, this routine handles any extra
660       REMark jumps, but first, remove jumped player piece
670       board((bestmove(0)+bestmove(2))/2,(bestmove(1)+bestmove(3))/2)=0
680       CLEAR_SQUARE (bestmove(0)+bestmove(2))/2,(bestmove(1)+bestmove(3))/2
690       x = bestmove(2) : y = bestmove(3) : REMark new position
700       best_move = -999 : REMark start looking for next 'best move'
710       FOR up = -2 TO (-2+(4*(board(x,y)=2))) STEP 2
720         FOR across = -2,2
730           newx = x + across : newy = y + up : REMark jump dest. square
740           IF newx >= 0 AND newx <= 7 AND newy >= 0 AND newy <= 7 THEN 
750             IF board(newx,newy)=0 AND board(x+(across/2),y+(up/2))>0 THEN 
760               REMark halfway square contains a player piece and
770               REMark destination square is vacant, so evaluate as a
780               REMark possible move
790               EVALUATE_POSITION
800             END IF 
810           END IF 
820         END FOR across
830       END FOR up
840       IF best_move = -999 THEN EXIT jumps
850       REMark a move of some sort (i.e. another jump) decided upon
860       AT #0,8,24 : CLS #0,4 : PRINT #0,CHR$(65+x);y;'+TO ';
870       PRINT #0,CHR$(65+bestmove(2));bestmove(3);
880       CLEAR_SQUARE x,y
890       board(bestmove(2),bestmove(3))=board(bestmove(0),bestmove(1))
900       board(bestmove(0),bestmove(1)) = 0 : REMark clear from square
910       SHOW_PIECE_AT bestmove(2),bestmove(3)
920       IF board(bestmove(2),bestmove(3)) = -1 AND bestmove(3)=0 THEN 
930         REMark crown QL piece upon move to bottom of board
940         board(bestmove(2),bestmove(3)) = -2
950         SHOW_PIECE_AT bestmove(2),bestmove(3)
960       END IF 
970     END REPeat jumps
980     EXIT QL_move
990   END REPeat QL_move
1000   winner = SOMEONE_WON : IF winner <> 0 THEN EXIT this_game
1010   :
1020   REMark player move
1030   REPeat enter_from
1040     AT #0,14,24 : CLS #0,4 : INPUT #0,mve$
1050     from_x = CODE(mve$) - 65 : from_y = CODE(mve$(2)) - 48
1060     IF from_x > 31 THEN from_x =from_x - 32 : REMark lower case
1070     REMark can only move from black square
1080     IF (from_x MOD 2) <> (from_y MOD 2) THEN BEEP 5000,50 : NEXT enter_from
1090     jumped% = 0 : REMark used for counting jump moves
1100     REPeat enter_to
1110       AT #0,14,26
1120       IF jumped% = 0 THEN PRINT #0,' '; : ELSE PRINT #0,'+';
1130       INPUT #0,'TO ';mve$
1140       to_x = CODE(mve$) - 65 : to_y = CODE(mve$(2)) - 48
1150       IF to_x > 31 THEN to_x = to_x - 32
1160       REMark can only move to black square
1170       IF (to_x MOD 2) <> (to_y MOD 2) THEN BEEP 5000,50 : NEXT enter_from
1180       board(to_x,to_y) = board(from_x,from_y)
1190       REMark does it need to be crowned?
1200       IF to_y = 7 AND board(to_x,to_y) = 1 THEN board(to_x,to_y) = 2
1210       board(from_x,from_y) = 0
1220       CLEAR_SQUARE from_x,from_y : SHOW_PIECE_AT to_x,to_y
1230       IF ABS(to_x-from_x) = 1 THEN EXIT enter_from
1240       REMark jump, so remove QL piece
1250       jumped% = 1 : REMark for different prompt next time
1260       board((from_x+to_x)/2,(from_y+to_y)/2) = 0
1270       CLEAR_SQUARE (from_x+to_x)/2,(from_y+to_y)/2
1280       REMark after a jump, there may be an optional second jump
1290       from_x = to_x : from_y = to_y
1300       REMark scan around this square...
1310       REMark look forward first
1320       another% = 0 : REMark can player jump again?
1330       FOR acr = -2,2
1340         FOR dn = -2,2
1350           IF dn = 2 OR (dn = -2 AND board(from_x,from_y) = 2) THEN 
1360             tx = from_x + acr : ty = from_y + dn
1370             IF tx >= 0 AND tx <= 7 AND ty >= 0 AND ty <= 7 THEN 
1380               REMark at least it's on the board
1390               IF board(tx,ty) = 0 AND board((from_x+tx)/2,(from_y+ty)/2) < 0 THEN another% = 1 : EXIT acr
1400             END IF 
1410           END IF 
1420         END FOR dn
1430       END FOR acr
1440       IF another% = 0 THEN EXIT enter_from
1450     END REPeat enter_to
1460   END REPeat enter_from
1470   winner = SOMEONE_WON : IF winner <> 0 THEN EXIT this_game
1480 END REPeat this_game
1490 IF winner = -1 THEN 
1500   AT #0,20,24 : PRINT #0,'QL WINS!'
1510 ELSE 
1520   AT #0,20,24 : PRINT #0,'PLAYER WINS!'
1530 END IF 
1540 STOP
1550 :
1560 DEFine PROCedure DRAW_BOARD
1570   LOCal x,y
1580   AT #0,2,16 : UNDER #0,1 : PRINT #0,'Q-DRAUGHTS' : UNDER #0,0
1590   BLOCK #0,196,162,40,44,0
1600   FOR y = 0 TO 7
1610     FOR x = (y MOD 2) TO (y MOD 2)+6 STEP 2
1620       BLOCK #0,24,20,42+24*x,45+20*y,7
1630     END FOR x
1640   END FOR y
1650   FOR x = 0 TO 7 : CURSOR #0,48+24*x,212 : PRINT #0,CHR$(65+x);
1660   FOR y = 0 TO 7 : CURSOR #0,24,50+20*y  : PRINT #0,CHR$(55-y);
1670   OVER #0,1 : INK #0,7
1680   AT #0,5,4  : PRINT #0,'  x   x   x   x'
1690   AT #0,7,4  : PRINT #0,'x   x   x   x'
1700   AT #0,9,4  : PRINT #0,'  x   x   x   x'
1710   AT #0,15,4 : PRINT #0,'o   o   o   o'
1720   AT #0,17,4 : PRINT #0,'  o   o   o   o'
1730   AT #0,19,4 : PRINT #0,'o   o   o   o'
1740   INK #0,0 : OVER #0,0 : AT #0,7,24 : PRINT #0,'COMPUTER'
1750   AT #0,13,24 : PRINT #0,'PLAYER'
1760 END DEFine DRAW_BOARD
1770 :
1780 DEFine PROCedure CLEAR_SQUARE(xx,yy)
1790   OVER #0,0 : BLOCK #0,24,20,42+24*xx,45+(20*(7-yy)),0
1800 END DEFine CLEAR_SQUARE
1810 :
1820 DEFine PROCedure SHOW_PIECE_AT (xx,yy)
1830   AT #0,19-yy-yy,4+xx+xx : INK #0,7 : PAPER #0,0
1840   pc = board(xx,yy) : REMark piece at this point
1850   SELect ON pc
1860     =-2 : PRINT #0,'X'; : REMark QL crowned
1870     =-1 : PRINT #0,'x'; : REMark QL uncrowned
1880     =1  : PRINT #0,'o'; : REMark player uncrowned
1890     =2  : PRINT #0,'O'; : REMark player crowned
1900   END SELect 
1910   INK #0,0 : PAPER #0,7
1920 END DEFine SHOW_PIECE_AT
1930 :
1940 DEFine PROCedure SCAN_AROUND
1950   REMark was the subroutine at 650
1960   REMark scan around the square
1970   eval = 0 : newx = x + across : newy = y + up
1980   IF newx < 0 OR newx > 7 OR newy < 0 OR newy > 7 THEN RETurn 
1990   REMark is the square already occupied by a QL piece
2000   IF board(newx,newy) < 0 THEN RETurn 
2010   REMark is the square vacant?
2020   IF board(newx,newy) = 0 THEN EVALUATE_POSITION : RETurn 
2030   REMark we now know that the square contains a player piece - can
2040   REMark the QL jump it? Look one square further
2050   newx = newx + across : newy = newy + up
2060   REMark it would be embarrassing if this square was off the board
2070   IF newx < 0 OR newx > 7 OR newy < 0 OR newy > 7 THEN RETurn 
2080   IF board(newx,newy) = 0 THEN EVALUATE_POSITION
2090 END DEFine SCAN_AROUND
2100 :
2110 DEFine PROCedure EVALUATE_POSITION
2120   REMark move from x,y to newx,newy
2130   IF newy = 0 AND board(x,y) = -1 : eval = eval + 2 : REMark crown
2140   IF ABS(y-newy) = 2 : eval = eval + 5 : REMark jump
2150   IF y = 7 : eval = eval + 2 : REMark move from top of board
2160   FOR offset = -1,1
2170     IF newx+offset>=0 AND newx+offset<=7 AND newy-1>=0 THEN 
2180       IF board(newx+offset,newy-1) < 0 THEN 
2190         eval = eval + 1 : REMark 
2200       ELSE 
2210         IF newx-offset>=0 AND newx-offset<=7 AND newy+1<=7 THEN 
2220           IF board(newx+offset,newy+1) > 0 THEN 
2230             IF board(newx-offset,newy+1)=0 OR (newx-offset=x AND newy+1=y) THEN 
2240               eval = eval - 2
2250             END IF 
2260           END IF 
2270         END IF 
2280       END IF 
2290     END IF 
2300   END FOR offset
2310   IF eval > best_move THEN 
2320     best_move = eval
2330     bestmove(0) = x : bestmove(1) = y
2340     bestmove(2) = newx : bestmove(3) = newy
2350   END IF 
2360   eval = 0 : REMark reset for future use
2370 END DEFine EVALUATE_POSITION
2380 :
2390 DEFine FuNction SOMEONE_WON
2400   player = 0 : ql = 0 : REMark pieces count
2410   FOR y = 0 TO 7
2420     FOR x = 0 TO 7
2430       piece = board(x,y)
2440       SELect ON piece
2450         =-1,-2 : ql = ql + ABS(piece)
2460         =1,2 : player = player + piece
2470       END SELect 
2480     END FOR x
2490   END FOR y
2500   IF player = 0 THEN RETurn -1 : REMark QL won
2510   IF ql = 0 THEN RETurn 1 : REMark player won
2520   RETurn 0
2530 END DEFine SOMEONE_WON
