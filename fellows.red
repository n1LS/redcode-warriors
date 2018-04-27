; Inspired by The Five Musketeers I once wrote "fellows".  It does a
; byte-by-byte comparison between copies of the program to maintain
; integrity.  Not very strong, I never posted it.  But looking at it now
; I think it could be made a whole lot smaller in '94 code, especially
; using Airbag's "still-alive" trick.  To those who don't remember, "cmp"
; is the same as "seq".  Enjoy!  Improve!  Share!
; P. Kline

;redcode-88
;name fellows
;author P. Kline
;strategy self-repair
;strategy inspired by The Five Musketeers
;strategy Two active copies and two dummy copies in core
;strategy Each active copy has a "dad" (active) and a "son" (inactive)
;strategy The two are compared byte-by-byte, when a difference
;strategy is found they are both patched from the running version.
;strategy Bombs dropped on an active copy are rarely passed on
;strategy because that copy will either ignore them or die.
;strategy They also check for 88-style vampire fangs which are
;strategy back-tracked to destroy enslaved processes in the pit.
;assert 1

         mov #ender-alive+1,alive
         mov #ender-meptr+4000+1,meptr
copy1    mov <alive,<meptr
         jmn copy1,alive
         mov #ender-alive+1,alive
         mov #ender-meptr+965+1,meptr
copy2    mov <alive,<meptr
         jmn copy2,alive
         mov #ender-alive+1,alive
         mov #ender-meptr+4965+1,meptr
copy3    mov <alive,<meptr
         jmn copy3,alive
         jmp restart
snareptr dat #0
dadptr   dat #0
sonptr   dat #0
alive    dat #0
meptr    dat #0
splcheck spl 0,0
clrdad   mov @dadptr,snareptr
         add #1,snareptr
         add dadptr,snareptr
         mov alive,@snareptr
         mov alive,<snareptr
         mov alive,resrect+4000
         mov alive,@dadptr
         mov #ender+1-dadptr+4000+1,dadptr
         mov #ender+1-meptr,meptr
clrloop  mov alive,<dadptr
         djn clrloop,meptr
         jmp newcheck
restart  cmp #4321,alive+4000   ;  is dad alive?
resrect  spl restart+4000       ;     no
         mov #4321,alive        ;  i'm alive
         mov #12,alive+4000     ;  flag dad as dead
         add #7,target
         mov alive,@target
newcheck mov #ender-dadptr+4000+1,dadptr
         mov #ender-sonptr+965+1,sonptr
         mov #ender-meptr,meptr
checkem  mov #4321,alive        ;  i'm still alive
         cmp <sonptr,<dadptr    ;  are son and dad in sync?
         jmp action             ;     no
recheck  djn checkem,meptr
         jmp restart
action   cmp splcheck,@dadptr   ;  is dad vamp'ed?
         jmp fixson             ;     no
         jmp clrdad             ;     yes
fixson   mov @meptr,@sonptr
fixdad   mov @meptr,@dadptr
ender    jmp recheck
target   dat #0

