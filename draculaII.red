;redcode
;name Dracula II
;author Jonas Hartwig
;assert CORESIZE == 8000

step    equ     3094                    ;mod-2 stepsize

top
hehe    jmp     trap,   #0              ;vampire
steg    dat     #-step, #step           ;data for dec/inc of ptr
start   add     steg,   hehe            ;add data
        slt     hehe,   #11             ;protect oneself+trap
        mov     hehe,   @hehe           ;set vampire
        jmp     start                   ;loop
trap    spl     0,      #333            ;delay
        djn     trap,   trap
        mov     steg,   trap            ;remove delay
        mov     steg,   top-1           ;coreclear
        jmp     -1,     <-1
slut    end     start

