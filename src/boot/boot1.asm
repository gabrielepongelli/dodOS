# @desc     Real Mode (16 bit) second stage bootloader that print "Hello world!"
# @author   Gabriele Pongelli
# @date     23/09/2022

.code16                     # use 16 bits since we are in Real Mode
.global _start              # define the _start symbol which will be the entry
.type _start, @function     # of the bootloader
_start:
    lea HELLO_MSG, %si      # load in si the address of hello world
    call print_string       # and print it
    call reboot             # then reboot

.include "./lib/print_string.asm"
.include "./lib/reboot.asm"

HELLO_MSG: .asciz "Hello from the second stage!\r\n"

.fill 512-((.-_start) % 512), 1, 0  # padding to the end of the sector
