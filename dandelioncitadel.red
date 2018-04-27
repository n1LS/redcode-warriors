;REDCODE-B
;AUTHOR Simon Wainwright
;NAME Dandelion Citadel
;STRATEGY a paper descended from Simple Replicate by several mutations
;STRATEGY <THINKING>... <THINKING>...
;STRATEGY we have programming recreations based on ASM, C and PASCAL,
;STRATEGY how well would one in FORTH work?
 
;ASSERT 1
LEN     mov #8,   8
        add FRO,  FRO
        mov FRO,  TOO
LOOP    mov <LEN, <TOO
        jmn LOOP, LEN
        spl @TOO, <LEN+1609
        jmp LEN,  <LEN+3209
FRO     dat #10*23
TOO     dat #10*23
        end LOOP
