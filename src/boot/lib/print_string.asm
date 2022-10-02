# @desc     Real Mode function which print a string
# @author   Gabriele Pongelli
# @date     02/10/2022

.code16

.text

# @param si     pointer to null-terminated string to print
.func print_string
print_string:
    pusha                   # save registers
    mov $0xe, %ah           # set the BIOS interrupt code to print a 
                            # character on the screen
print_string_loop:
    lodsb                   # loads the byte from the address in si into al and 
                            # increments si
    cmp $0, %al             # compares content in al with zero
    je print_string_done    # if al == 0 (end of the string) stop printing
    mov $9, %bx             # set bh (page number) to 0, and bl (background 
                            # color) to white (9).
    int $0x10               # prints the character in al to screen
    jmp print_string_loop   # repeat with next byte
print_string_done:
    popa                    # restore registers
    ret
.endfunc
