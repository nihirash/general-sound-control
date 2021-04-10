    module String
; HL - asciiZ 
; DE - asciiZ
; Z - equals, NZ - not equals
strcmp:
    ld a, (hl), b, a
    ld a, (de)
    cp b : ret nz
    and a  : ret z
    inc hl
    inc de
    jr strcmp

    endmodule