DOCUMENTATION
===============

-----SINCLAIR ZX SPECTRUM NEXT VERSION-----

by Stefan Vogt

This is an edition created for distribution with the ZX Next. If you want a copy
of the physical game with extra goodies and a bonus game when it is released 
then you should visit:

pondsoft.uk/forum/

To download a copy for any other Spectrum and a range of retro machines:

https://8bitgames.itch.io/hibernated1

TO LOAD: just select HIB1_RUN.BAS from the Browser - like you did this README!
(You can just select the TAP file in ESXDOS from the NMI Browser)

This was written with Gilsoft PAWS which you will also find in the distribution.
ZX Next mastering by Tim Gilberts.

-----PLOT-----

Have you ever dreamed about a journey far beyond the known regions of the
universe? Hibernated 1: This Place is Death is a Science-Fiction text adventure
for C64/C128, ZX Spectrum, Amstrad CPC and MS-DOS. It is the first interactive
story in an epic trilogy centered around Olivia Lund, who has been sent on an
interplanetary exploration mission by the Terran Alliance. After being in
hypersleep for more than 200 years and with more than 800 light-years being
travelled, her ship, the Polaris-7, crosses paths with a gigantic alien vessel
and is captured by a tractor beam. Olivia soon finds out that this may not be
her only problem. There is no communication and there are no signs of life. The
extraterrestrial spacecraft just continues to drift through the cosmic void,
something it seems to be doing for thousands of years now. This is a tomb
in-between the stars, which Olivia has to enter to extricate herself from this
interstellar trap. Io, the navigation robot of the Polaris-7, is probably her
only friend now. Far away from home and surrounded by death and decay, she found
the answer to one of the greatest questions of mankind. Are we alone? The answer
is: yes, out here, we are more alone than ever.

-----GAMEPLAY-----

Hibernated is a text-only adventure. It works with a two-word-logic, e.g.
EAT APPLE, EXAMINE CUPBOARD. The parser is capable tough to understand better
forms of expression. So you could write N to go north, you could also write
GO NORTH. You generally move with N(orth), S(outh), W(est), E(east) or any other
direction that is written in the room description like e.g. UP or SE. You don't
have to search for hidden exits, everything is clearly visible to you. A door
though might be locked, which is a different cup of tea. 

The game comes with many synonyms that enhance the gameplay, e.g. EXAMINE BODY,
CHECK CORPSE, INSPECT DEAD would all result in the same operation. LOOK AT is
also a synonym for EXAMINE. To satisfy your expectations: corpses actually ARE
objects in the game. Not only nouns have synonyms, the same counts for verbs:
GET, GRAB, TAKE would all invoke the same operation. 

You can save and load your progress at any time. Type HELP in-game to learn more
about disk / tape operations. 

Remember to use the MF/NMI(DRIVE) menu to create and attach a TAP file for your
saves.  If you want to restore a game detach the TAP from the Output and attach
to the Input. You should not attach the same file to IN and OUT at the same
time.

Type REDESCRIBE if you want to read the room description again. 

Hit INVENTORY to have a look at the items you're carrying. 

The most common three operations have a short form: you can write R instead of
REDESCRIBE to redescribe a room, I to check the inventory and X to EXAMINE an
object. 

QUIT or STOP allows you to return to 48K Basic.  It is best to press and hold
reset (or F1 on a PS2 keyboard) between different games to get back to NextZXOS
although for PAWed games F4 is sufficient. 

Common instructions are: USE, EXAMINE, DROP, TAKE, SEARCH, OPEN, PUSH, N, S, E,
W. Other instructions derive from hints you get while progressing.

Type HINT to get a more or less cryptic hint how to achieve the next major goal
in the game (progress-level).

-----HOW TO SOLVE THE MYSTERY-----

* Draw a map. That's probably the most important aspect to win this game,
Hibernated doesn't differ much in that from other text adventures.

* Keep your progress in mind. Hibernated is heavily based on dependencies and
progress levels. You might have the right idea (verb noun combination) but the
time is wrong. Just because an operation doesn't work does not necessarily mean
it won't work later, e.g. why should you USE TOILET if there is no need for
that? Why should you SEARCH for TOILETPAPER if you don't need it? Io sometimes
gives you hints about the steps necessary for the progression. And sometimes,
even the time is right, the idea is right but the place is wrong. That's also
for you to consider. If you want to take a shower, you go to the bathroom. Yes,
that was a metaphor.

* Examine a lot. Not only does examining give you useful hints - and think twice
about what you read, Hibernated comes also with a lot of hilarious jokes and
references. So be sure to examine everything, including the objects you carry
and encounter as you might be otherwise missing most of the fun.

* Searching rooms is not a thing, e.g. SEARCH AREA. Searching an object though
is fine, e.g. SEARCH CUPBOARD.

* Use a shortcut. On the alien ship you can type anytime GO POLARIS to get back
to the Polaris-7 with skipping all the rooms in-between. You will need to go
back quite a few times so this is a VERY handy feature. The feature won't work
if you're not wearing your space suit as that would result in a gameplay
paradoxon. Also it makes sense in a logical context. When you're in outer space
you're not only wearing your old worn-out underpants.

* This game does not contain any references to Colossal Cave Adventure. Ok,
there might be at least one in.

* Don't die. There is JUST ONE situation in the game where you can actually die
and it is not very hard to guess how that might be achieved. If you manage to
die in that one situation, you probably might want to consider to not play any
adventure game in the future.


The game supports both 48k and 128k machines:

This is how you load Hibernated (tape version):
1.) insert tape
2.) hit "J", followed by holding down SYMBOL SHIFT and hitting P, then hold
    down SYMBOL SHIFT again and hit P
3.) this should result in the screen showing: LOAD""
4.) for the Spectrum 128, +2 and +3, you need type in LOAD"" in full
5.) hit ENTER and press play on the cassette recorder

This is how you load Hibernated (disk version)
1.) insert disk
2.) select "+3 Basic" from the Spectrum menu
3.) type: LOAD "HIB1" to load the game

