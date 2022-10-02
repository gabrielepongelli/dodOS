# @desc     Real Mode function which reboot the system
# @author   Gabriele Pongelli
# @date     02/10/2022

.code16

.text

.func reboot
reboot:
    lea REBOOT_MSG, %si     # load address of the reboot message into si
    call print_string       # print the message
    xor %ax, %ax            # set the BIOS interrupt code to get a keystroke
    int $0x16               # call BIOS to wait for key

    ljmp $0xffff, $0000     # jump to FFFF:0000 (this inst will cause a reboot)
.endfunc

REBOOT_MSG: .asciz "Press any key to reboot...\r\n"
