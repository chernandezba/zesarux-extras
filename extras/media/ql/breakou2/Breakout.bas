110 MODE 4
120 WINDOW 512,256,0,0:PAPER 0:CLS:CSIZE 2,1:AT 3,15:PRINT "BREAKOUT"\\,"      is loading"
130 v=RESPR(6144):LBYTES dev$&"breakout_bin",v
140 CLS:CLOSE #0:CLOSE #1:CLOSE #2
150 FOR n=6 TO 8
160 OPEN #n,scr_
170 WINDOW #n,154,80-24*(n=8),332,(n-6)*94
180 PAPER#n,0:BORDER #n,2,2
190 INK #n,2:LINE #n,0,81 TO 240,81:INK#n,4
200 NEXT n
210 PRINT #6;"       PLAYER  1":AT #6,2,0
220 PRINT #7;"       PLAYER  2":AT #7,2,0
230 INK#8,7:PRINT #8;"      HIGH  SCORE"
240 panel
250 PRINT#0;" ¼ ½",,"L/R controls"\\" ¾",,"faster"\\" CTRL",,"serve"\\\
255 INK#0,7:PRINT #0;"     Score 1000 for extra ball"\\:INK#0,4
260 REPeat play
270 AT #0,12,1:CLS #0,4:INPUT #0;"1 or 2 players >";p$:IF p$="1" OR p$="2" THEN EXIT play
280 END REPeat play
290 CLS #6,2:CLS #7,2
300 INK#0,2:PRINT#0,\"       PRESS 'CTRL' TO START"
310 CLOSE #0
320 CALL v,(768*(p$="2")),r
330 panel
340 INK #0,7:PRINT#0;,"    GAME OVER"\\:INK#0,4:GO TO 260
350 DEFine PROCedure panel
360 OPEN_NEW #0,con_224x180:BORDER#0,2,4:INK#0,7:CLS#0
370 r=RND(4000)
380 PRINT#0,," - QL BREAKOUT -"\\:INK#0,4
390 END DEFine 
