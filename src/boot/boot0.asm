# @desc     First stage bootloader
# @author   Gabriele Pongelli
# @date     02/10/2022

.code16                     # use 16 bits since we are in Real Mode
.set START_ADDR, 0x7c00     # constant which defines the starting address of 
                            # this code
.set BOOT1_ADDR, 0x1000     # constant which defines the address where boot1 
                            # will be loaded
.text                       # begin of text section

.global _start              # define the _start symbol which will be the entry
.type _start, @function     # of the bootloader
_start:
    ljmp $0, $setup_segments# set the pair cs:eip to 0000:load_segments


.include "lib/print_string.asm"
.include "lib/reboot.asm"
.include "lib/read_from_drive.asm"


setup_segments:
    cli                     # disable interrupts before segments declarations

    mov %cs, %ax            # load the address of the code segment (which is 0)
    mov %ax, %ds            # set all the segment registers to point to the
    mov %ax, %ss            # first 64kB segment, since both stages (boot0 and  
    mov %ax, %es            # boot1) and the stack will be stored entirely there
    
    mov $START_ADDR, %sp    # set the top of the stack for boot1 just under 
                            # this code, which will be placed at START_ADDR
    mov %sp, %bp            # update the base pointer with the new value
    sti                     # re-enable interrupts because we need them later


display_loading_message:
    lea LOAD_MSG, %si       # load in si the address of the message to print
    call print_string       # print the message


setup_floppy:
    xor %ax, %ax            # set the BIOS interrupt code to reset the 
                            # floppy disk system
    int $0x13               # reset the floppy (the boot drive number is 
                            # already being setted by the BIOS)
    jc error                # display an error message if the reset fail


load_boot1:
    mov $0x1, %ax           # otherwise load in ax the LBA of the second stage
    mov $BOOT1_ADDR, %bx    # load in bx the address where boot1 will be staved
    mov %dl, %ch            # load in ch the boot drive number
    mov $(SECOND_STAGE_SIZE / SECTOR_SIZE), %cl
                            # load in cl the size of boot1 in number of sectors
                            # (SECOND_STAGE_SIZE and SECTOR_SIZE symbols will 
                            # be declared by the compiler)
    call read_from_drive    # load boot1 in memory
    jmp *%bx                # and execute it

error:
    lea DISK_ERROR_MSG, %si # load in si the address of the message to print
    call print_string       # print the message
    call reboot             # call reboot function


LOAD_MSG: .asciz "Loading dodOS...\r\n"
DISK_ERROR_MSG: .asciz "Failed to reset floppy system. "


.fill 510-(.-_start), 1, 0  # add zeroes to make this code 510 bytes long
.word 0xaa55                # magic bytes that tell BIOS that this is bootable 
                            # code (the bytes are reversed since intel 
                            # processors are little endian)
