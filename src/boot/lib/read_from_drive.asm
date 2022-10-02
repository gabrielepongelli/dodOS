# @desc     Real Mode function which load data from drive
# @author   Gabriele Pongelli
# @date     02/10/2022

.code16

.set SECTORS_PER_TRACK, 18
.set N_HEADS, 2

.text

# @param ax     logical block address (LBA) to read
# @param es:bx  destination address
# @param ch     drive number
# @param cl     number of sectors to read
.func read_from_drive
read_from_drive:
    pusha                       # save all registers
    push %bx                    # save destination offset
    push %cx                    # save drive number and sectors to read

    # calculate cylinder, head and sector from LBA:
    # cylinder = (LBA / SECTORS_PER_TRACK) / N_HEADS
    # sector   = (LBA mod SECTORS_PER_TRACK) + 1
    # head     = (LBA / SECTORS_PER_TRACK) mod N_HEADS

    mov $SECTORS_PER_TRACK, %bx # get sectors per track
    xor %dx, %dx                # clear dx for the division
    div %bx                     # perform dx:ax/bx
    # quotient (ax) =  LBA / SECTORS_PER_TRACK
    # remainder (dx) = LBA mod SECTORS_PER_TRACK

    inc %dx                     # add 1 to remainder, since sector
    mov %dl, %cl                # store result in cl for the BIOS call

    mov $N_HEADS, %bx           # get number of heads
    xor %dx, %dx                # clear dx for the division
    div %bx                     # perform dx:ax/bx
    # quotient (ax) = cylinder
    # remainder (dx) = head

    mov %al, %ch                # ch = cylinder
    xchg %dh, %dl               # dh = head number

    # call interrupt 0x13, function code 2 to actually read the data.
    # al = number of sectors
    # ah = function code 2
    # cx = sector number
    # dh = head number
    # dl = drive number
    # es:bx = data buffer
    pop %ax                 # set ah = drive number and al = sectors to read
    mov %ah, %dl            # set the drive number to read
    mov $0x2, %ah           # set function code for the BIOS
    pop %bx                 # restore data buffer offset.
    int $0x13               # call the BIOS
    jc read_failed          # if there is an error jump to read_failed
    popa                    # otherwise restore all registers
    ret                     # and return

read_failed:
    lea READ_ERROR_MSG, %si # load in si the address of the error message
    call print_string       # print it
    call reboot             # and then reboot the system

.endfunc

READ_ERROR_MSG: .asciz "Failed to load data. "
