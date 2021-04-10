    DEVICE ZXSPECTRUM48
    org #2000
    jp start
    include "drivers/esxdos.asm"
    include "drivers/gs.asm"
    include "drivers/zxbios.asm"
    include "drivers/args.asm"
    include "utils/strings.asm"
start:
    push hl
    print hello
    pop hl
    ;; ARGS parsing
    ld a, l : or h : jp z, noArgs

    ld de, argBuff : call Args.parseOne
    ld a, b : and a : jp z, noArgsTxt

    ;; Execution branching. Trying find commands
    ld hl, argBuff, de, cmd_pause  : call String.strcmp : jp z, GeneralSound.stopModule
    ld hl, argBuff, de, cmd_continue : call String.strcmp : jp z, GeneralSound.continueModule
    ld hl, argBuff, de, cmd_rewind : call String.strcmp : jp z, GeneralSound.rewind
    ld hl, argBuff, de, cmd_init : call String.strcmp : jp z, GeneralSound.init.cold
    ;; And shortcuts
    ld hl, argBuff, de, cmd_pause_short  : call String.strcmp : jp z, GeneralSound.stopModule
    ld hl, argBuff, de, cmd_continue_short : call String.strcmp : jp z, GeneralSound.continueModule
    ld hl, argBuff, de, cmd_rewind_short : call String.strcmp : jp z, GeneralSound.rewind
    ld hl, argBuff, de, cmd_init_short : call String.strcmp : jp z, GeneralSound.init.cold
    ;; If there isn't command - play module
playGS:
    ld a, (argBuff) : and a : jp z, noArgs
    
    ld hl, argBuff, a, '.', bc, 80 : cpir : call nz, addExt

    print initingTxt
    xor a : call GeneralSound.init

    print openingTxt
    print argBuff
    print crLf

    ld b, Dos.FMODE_READ, hl, argBuff
    call Dos.fopen : jp c, error
    ld (fp), a

    call GeneralSound.loadModule
loadLoop:    
    ld a, (fp), bc, bufferSize, hl, buffer
    call Dos.fread
    ld a, b : or c : jr z, .playSong

    ld hl, buffer
.sendBytesToGS
    ld a, (hl)
    call GeneralSound.sendByte
    inc hl
    dec bc
    ld a, b : or c : jr nz, .sendBytesToGS
    
    jr loadLoop
.playSong
    ld a, (fp) : call Dos.fclose
    jp GeneralSound.finishLoadingModule

addExt:
    xor a : ld hl, argBuff, bc, 80 : cpir : dec hl
    ld a, '.' : ld (hl), a : inc hl
    ld a, 'm' : ld (hl), a : inc hl
    ld a, 'o' : ld (hl), a : inc hl 
    ld a, 'd' : ld (hl), a : inc hl
    xor a     : ld (hl), a
    ret    

noArgs:
    print noArgsTxt
    ret

error:
    print errorTxt
    ret

hello db "GeneralSound Control", 13
      db "v. 0.1 by Nihirash", 13, 0

noArgsTxt db 13
          db "Usage:",13
          db "To play track:",13
          db ".gsc <file.mod>",13, 13
          db "Or for control:", 13
          db ".gsc pause", 13
          db ".gsc continue", 13
          db ".gsc rewind", 13
          db ".gsc init", 13, 13
          db "You can use short command", 13
          db "syntax - use first char as", 13
          db "shortcut", 13, 0

initingTxt db "Initing GS", 13, 0 

openingTxt db "Loading: ", 0
errorTxt   db 13, "ERROR!", 13, 0
crLf db 13, 0

cmd_pause          db "pause", 0
cmd_pause_short    db "p", 0
cmd_continue       db "continue", 0
cmd_continue_short db "c", 0
cmd_rewind         db "rewind", 0
cmd_rewind_short   db "r", 0
cmd_init           db "init", 0
cmd_init_short     db "i", 0

fp db 0

argBuff ds 80

buffer ds #1000
bufferSize equ $ - buffer
    SAVEBIN "gsc", #2000, $ - #2000