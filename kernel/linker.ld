/* 
 * The Linker Script
 * By default, Rust assumes it's compiling for Linux/Windows and expects an OS 
 * to load the program. We have to tell the linker exactly where to put our code 
 * in physical RAM so the CPU can find it.
 */

/* 
 * ENTRY(_start) tells the CPU: "When you finish the firmware handoff, 
 * jump to the memory address of this specific symbol."
 * We define `_start` in our assembly file.
 */
ENTRY(_start)

SECTIONS {
    /* 
     * The QEMU RISC-V `virt` machine loads the OpenSBI firmware at 0x80000000.
     * After OpenSBI sets up the hardware, it jumps to 0x80200000 and hands 
     * control to us. This is the "Supervisor" starting address.
     */
    . = 0x80200000;

    /* 
     * .text is where the CPU reads instructions (executable code).
     * We force our assembly entry point (.text.entry) to be the VERY FIRST 
     * thing at 0x80200000. The CPU must hit `_start` before anything else.
     */
    .text : {
        *(.text.entry)
        *(.text .text.*)
    }

    /* 
     * .rodata is "Read-Only Data". This is where string literals (like 
     * "VIRGIL BOOTING") and constants live. If code tries to write here, 
     * the MMU will trap it as a security violation.
     */
    .rodata : {
        *(.rodata .rodata.*)
    }

    /* 
     * .data is initialized global variables. 
     * Example: `static mut BOOT_COUNT: u32 = 1;`
     */
    .data : {
        *(.data .data.*)
    }

    /* 
     * .bss is uninitialized global variables. 
     * Example: `static mut BUFFER: [u8; 1024];`
     * The CPU doesn't store this in the binary to save space. It's the job of 
     * our assembly code to zero this memory out before Rust runs, otherwise 
     * our variables will contain garbage data from whatever was in RAM before.
     */
    .bss : {
        *(.bss .bss.*)
    }
}
