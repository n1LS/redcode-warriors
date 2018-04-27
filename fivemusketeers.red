; The Five Musketeers -- "All for one, and one for all!"
;
; a Core Wars fighter program by Jon Newman
; {old email address removed PDK}
; PEA '83   Stanford '87
;
; "Freeware" is hardly free when you have to download it
;  across phone lines in another state, but I just had to see
;  the Core Wars manual -- after seeing it, I just had to get
;  the program -- and, finally, after one weekend's intensive
;  hacking, I produced what is in my humble opinion the most
;  sophisticated fighter program around.  Surprisingly, it is
;  a mean fighter too. So:
;
; The Five Musketeers is a unique fighter program based on
;  mutual self-repair by a finite number of co-routines.  The
;  code that follows will replicate into five seperate copies
;  in memory, each 1600 cells apart.  Each "musketeer" has a
;  "big brother" and a "little brother," forming a sort of
;  daisy chain.  Each "little brother" must regularly reassure
;  "big brother" , while "big brother" checks on
;  "little brother" to make sure it has not been subverted or
;  destroyed.  If "little brother" fails to reassure him,
;  "big brother" will copy itself into "little brother"'s
;  location and split off a new process.  If "little brother"
;  is alright, then "big brother" is free to do whatever it
;  chooses.  (Not patronizing, this is the way I think of it
;  myself.)
; "Reassurance" takes place through the location MYTAG.
;  "Big brother" sets it to zero, then waits;  if "little
;  brother" fails to change it to magic number 1373 in time,
;  "big brother" rewrites him.  Since the brothers are not
;  always in sync, "little brother" writes it twice.
;
;redcode-88
;name Five Musketeers
;author Jon Newman
;assert 1
;
;
;@-2 
;
done       mov #1373,mytag       ;reassure big brother
           spl start-3200        ;split off new little brother
;
start      mov #1373,mytag       ; reassure big brother
           cmp #1373,mytag-3200  ; check on little brother
           jmp ok                ; little brother is OK
;
savehim    mov #2,source         ;Oh no, little brother is
           mov #-3199,dest       ;hurt!  Rewrite him!
write      mov @source,@dest
           cmp #-25,source       ;Routine lifted from Gemini,
           jmp done              ;except that it goes
           sub #1,source         ;backwards.
           sub #1,dest
           jmp write
;
ok         mov #0,mytag-3200     ; The optional routine when
           mov #34,timer         ; little brother is OK.
bombloop   mov #0,@target        ; Bombs every point between
;           djz reset,timer       ; this musketeer and the one
	djn c1,timer
	jmp reset
c1
           sub #1,target         ; above him.  Can be replaced
;           jmg bombloop,target   ; with timer loop, vampire
            jmn bombloop,target   ; with timer loop, vampire
           mov #1571,target      ; attack, anything.
           jmp bombloop          ; See below.
reset      mov #1373,mytag       ;reassure big brother.
           jmp start
;
timer      dat #34                ;# bombs per attack cycle
mytag      dat #1373              ; checked by big brother
source     dat #2                 ;from Gemini: not reset until
dest       dat #-3199             ;write cycle begins
target     dat #1571              ; bomb point

	end start
;
; Note that each brother checks on the brother 3200 cells
;  below him, not the one 1600 below him.  This improves
;  repair characteristics if two adjoining brothers are lost.
;  They still form a chain, just a more confusing one.
;
; As indicated in the comments, the Musketeers' feeble attack
;  may be replaced with any other code given appropriate
;  changes in the constants.  However, it is essential that
;  the time from START to START remain as long as for the
;  repair cycle (for this version, 144 cycles).  If the attack
;  loop is shorter, a big brother might write to an unhurt
;  little brother itself in the process of writing to a
;  littler brother.  Overlong attack loops increase the delay
;  before loss of little brother is noticed.
; Sometimes, due to strange attacks (e.g. damage to MYTAG),
;  such a rewrite will occur anyway.  The result: two brothers
;  sharing the same space.  This causes strange things to
;  happen, and they multiply like rabbits once set off.  Also,
;  enemies can be subverted to Musketeers -- very weird.  This
;  can be survived though.
;
; Discovery: JMG is just the opposite of JMZ, no cell ever
;  registers as negative no matter what Debug says.  Ugh.
;
;
; A surprise:  in all my testing, The Five Musketeers has never
;  lost a match with any of the seven fighter programs
;  provided in the initial upload.  My results:
;
; Dwarf: two wins.  An excellent display of the self-repairing
;  ability of The Five Musketeers.
; Gemini: two wins.
; Gemini Cannon: three wins, one draw.  When a Gemini lands on
;  a Musketeer, anything can happen.  This is a very wild
;  matchup, try it sometime.
; Imp: two draws.  Imps subvert Musketeers to more Imps, and,
;  as always, are almost unstoppable -- eventually they
;  overwhelm the self-repair process, leaving only Imps.
; Imp Cannon: two draws.
; Vampire: two wins.  Musketeers are very susceptible to Fangs,
;  but the self-repair is so efficient that 500 trash
;  processes still leave it time to replicate into the
;  area already erased.  Raising NPRC in Vampire to 5000
;  will kill the Musketeers.
; Worm: two draws.  Can anything kill a Worm?
;
;
; Well, that's it.  Feel free to try out variations on this
;  very fruitful theme.  The Four Vampires?  The Ten Dwarves?
;  The Two Gemini Cannons (which hopefully keep the Geminis
;  away from the replicating code)?  The mind boggles.
;
;                  Jon Newman

