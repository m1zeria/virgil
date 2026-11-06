/* 
 * .section .text.entry tells the assembler to put this code in the 
 * executable section we defined in the linker script. 
 */
.section .text.entry

/* 
 * .global _start makes this symbol visible to the linker script's ENTRY(_start) command.
 */
.global _start

_start:
    /* 
     * STEP 1: Set up the Stack.
     * Rust relies heavily on the stack for local variables, function calls, 
     * and saving registers. The CPU's stack pointer (register `sp`) is initially 
     * garbage when we boot. 
     * `la` means "Load Address". We point `sp` to the top of our allocated stack.
     */
    la sp, _stack_top
    
    /* 
     * STEP 2: Jump to Rust.
     * `call kmain` pushes the return address onto the stack and jumps to 
     * our Rust function. It is standard practice to name the Rust entry 
     * point `kmain` (Kernel Main) to distinguish it from standard `main`.
     */
    call kmain

    /* 
     * STEP 3: The Safety Net.
     * If Rust's `kmain` function somehow returns (it shouldn't, it returns `!`),
     * we jump to a label `1:` that loops forever, locking up the CPU safely
     * instead of executing random memory.
     * `j 1b` means "jump backward to label 1".
     */
1:  j 1b

/* 
 * We switch to the .bss section to allocate our stack.
 * We set it to 16-byte alignment (.balign 16) because RISC-V's Application Binary 
 * Interface (ABI) requires the stack to be 16-byte aligned for performance.
 */
.section .bss
.balign 16
_stack_bottom:
    /* .space allocates raw bytes. We are allocating 4096 bytes * 16 = 65,536 bytes (64 KB) for the stack. */
    .space 4096 * 16
.global _stack_top
_stack_top:
