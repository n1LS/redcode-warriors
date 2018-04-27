;redcode
;name Matreshka Rulez!
;author inversed
;strategy Nesting silk-like replicators a-la p3c
;strategy Using empty cells as pointers to self
;strategy With experimental qScan
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

; Quasi-silk simplier than Nightfall
; Entered '88 hill and died short after.
; But scores better than AIP against my
; benchmark. Let's see how it does on KS.

;---------[paper]---------
len     equ     8
ofs1    equ     3771
ofs2    equ     1537
ofs3    equ     5668
bd      equ     7978
;---------[boot ]---------
bd1     equ     3348
bd2     equ     bd1+4000
;---------[misc ]---------
x0      equ     boot
;-------------------------

boot    spl     1,      0
bp1f    spl     1,      pend+1
bp2f    spl     1,      pend+1

        mov     <bp1f,  <bp1t
        mov     <bp2f,  <bp2t

        spl     2,      0

bp1t    jmp     @0,     x0+bd1+8
bp2t    jmp     @0,     x0+bd2+8

m1      mov     <m1+len,        <silk1
silk1   spl     @0,             ofs1
m2      mov     <m2+len,        <silk2
silk2   spl     @0,             ofs2
m3      mov     <m3+len,        <silk3
silk3   spl     @0,             ofs3
        mov     0,              <1
pend    djn     -1,             #bd

;---------[qscan]---------
qz      equ     200
qmul    equ     120
qhop    equ     4000

qa1     equ     qmul*7
qa2     equ     qmul*3
qa3     equ     qmul*11
qa4     equ     qmul*9

qoff    equ     -86
qstep   equ     7
qbcnt   equ     14

;-------------------------

        ;---------[instant]---------
qgo     jmn     qbloop          ,       qptr+qz

        ;--------[+0 cycles]--------
        cmp     qptr+qz+qa1     ,       qptr+qz+qa1+qhop
        jmp     dec0            ,       0

        cmp     qptr+qz+qa2     ,       qptr+qz+qa2+qhop
        jmp     dec0            ,       <qt1

        ;--------[+1 cycle ]--------
        cmp     qptr+qz+qa1+qa2 ,       qptr+qz+qa1+qa2+qhop
        jmp     dec1            ,       0

        cmp     qptr+qz+2*qa2   ,       qptr+qz+2*qa2+qhop
        jmp     dec1            ,       <qt1

        cmp     qptr+qz+qa3+qa1 ,       qptr+qz+qa3+qa1+qhop
        jmp     dec1            ,       <qt2

        cmp     qptr+qz+qa3+qa2 ,       qptr+qz+qa3+qa2+qhop
        djn     dec1            ,       <qt1

        ;--------[+2 cycles]--------
        cmp     qptr+qz+qa3+qa2+qa1     ,       qptr+qz+qa3+qa2+qa1+qhop
        jmp     dec2                    ,       0

        cmp     qptr+qz+qa3+2*qa2       ,       qptr+qz+qa3+2*qa2+qhop
        jmp     dec2                    ,       <qt1

        cmp     qptr+qz+2*qa3+qa1       ,       qptr+qz+2*qa3+qa1+qhop
        jmp     dec2                    ,       <qt2

        cmp     qptr+qz+qa4+qa2+qa1     ,       qptr+qz+qa4+qa2+qa1+qhop
        jmp     dec2                    ,       <qt3

        cmp     qptr+qz+2*qa3+qa2       ,       qptr+qz+2*qa3+qa2+qhop
        djn     dec2                    ,       <qt1

        cmp     qptr+qz+qa4+qa3+qa1     ,       qptr+qz+qa4+qa3+qa1+qhop
        djn     dec2                    ,       <qt2

        ;--------[mutation ]--------
        slt     <qt1                    ,       <qt1    ;mutation

        ;--------[+0 cycles]--------
        cmp     qptr+qz+qa3     ,       qptr+qz+qa3+qhop
        jmp     dec0            ,       0

        cmp     qptr+qz+qa4     ,       qptr+qz+qa4+qhop
        jmp     dec0            ,       <qt1

        ;--------[+1 cycle ]--------
        cmp     qptr+qz+qa2+qa4 ,       qptr+qz+qa2+qa4+qhop
        jmp     dec1            ,       <qt1

        cmp     qptr+qz+2*qa3   ,       qptr+qz+2*qa3+qhop
        jmp     dec1            ,       <qt2

        for     0                       ;these scans are possible
                                        ;but I don't use them

        ;--------[+2 cycles]--------

        cmp     qptr+qz+qa3+qa2+qa4     ,       qptr+qz+qa3+qa2+qa4+qhop
        jmp     dec2                    ,       <qt1

        cmp     qptr+qz+3*qa3           ,       qptr+qz+3*qa3+qhop
        jmp     dec2                    ,       <qt2

        rof

        jmp     boot,   qptr
pqptr   dat     #0,     #qptr

dec2    add     @qt3,   decode
dec1    add     @qt2,   decode
dec0    add     @qt1,   decode
decode  add     #0,     @pqptr
decide  cmp     boot-1, @qptr
        jmp     qbloop, 0
        add     #qhop,  qptr

qbloop  mov     qbmb,   @qptr
qptr    mov     qbmb,   @qz
        add     #qstep, qptr
        djn     qbloop, #qbcnt
        jmp     boot,   0

qbmb    dat     <1,     <qoff

        dat     #qa4,   #0
qt3     dat     #qa3,   #0
qt2     dat     #qa2,   #0
qt1     dat     #qa1,   #0

end     qgo

