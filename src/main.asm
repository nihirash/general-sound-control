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
    ;; Execution branching
    ld hl, argBuff, de, cmd_pause  : call String.strcmp : jp z, GeneralSound.stopModule
    ld hl, argBuff, de, cmd_resume : call String.strcmp : jp z, GeneralSound.continueModule
    ld hl, argBuff, de, cmd_rewind : call String.strcmp : jp z, GeneralSound.rewind
    ld hl, argBuff, de, cmd_reboot : call String.strcmp : jp z, GeneralSound.init.cold
    ;; If there isn't command - play module
playGS:
    ld a, (argBuff) : and a : jp z, noArgs

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
          db ".gsc <file.mod>",13,13
          db "Or for control:", 13
          db ".gsc pause", 13
          db ".gsc resume", 13
          db ".gsc rewind", 13
          db ".gsc reboot", 13, 13, 0

initingTxt db "Initing GS", 13, 0 

openingTxt db "Loading: ", 0
errorTxt   db 13, "ERROR!", 13, 0
crLf db 13, 0

cmd_pause  db "pause", 0
cmd_resume db "resume", 0
cmd_rewind db "rewind", 0
cmd_reboot db "reboot", 0

fp db 0

argBuff ds 80

buffer ds #1000
bufferSize equ $ - buffer
    SAVEBIN "gsc", #2000, $ - #2000