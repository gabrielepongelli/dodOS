.code16                     # use 16 bits since we are in Real Mode
.global _start              # define the _start symbol which will be the entry
.type _start, @function     # of the bootloader
_start:
    mov si, offset msg      # loads the address of msg
    mov ah, 0xe             # set the PC BIOS interrupt code to print a 
                            # character on the screen 
print_char:
    lodsb                   # loads the byte from the address in si into AL and 
                            # increments SI
    cmp al, 0               # compares content in AL with zero
    je done                 # if AL == 0 (end of msg) stop printing
    int 0x10                # prints the character in AL to screen
    jmp print_char          # repeat with next byte
done:
    hlt                     # stop execution

msg: .asciz "Hello world!"  # zero-terminated string to print

.fill 510-(.-_start), 1, 0  # add zeroes to make this code 510 bytes long
.word 0xaa55                # magic bytes that tell BIOS that this is bootable 
                            # code (the bytes are reversed since intel 
                            # processors are little endian)
