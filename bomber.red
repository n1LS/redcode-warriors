;redcode-94
;name bomber-basic
;author samurai@psych0tik.net
;strategy a very basic bomber to test the ideas of bombing
;strategy (written in ICWS'94)
;strategy Submitted: @date@
;assert CORESIZE==8000

	org loop

bomb: 	dat #0, #12

loop:	add #121, bomb
	mov bomb, @bomb
	jmp loop