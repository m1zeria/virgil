// #![no_std] tells Rust: "Do not link the standard library."
// The std library assumes we are running on Linux/Windows with a filesystem, 
// heap allocator, and threads. We have none of that. We only get `core`.
#![no_std]

// #![no_main] tells Rust: "Do not generate the default C-style `main` function."
// We are using our custom assembly `_start` function as the entry point.
#![no_main]

// We need this to implement the mandatory panic handler below.
use core::panic::PanicInfo;

// In QEMU's `virt` machine, the UART (serial console) is memory-mapped at 0x1000_0000.
// If we write a byte to this physical address, QEMU prints it to our terminal.
const UART_BASE: usize = 0x1000_0000;

// #[no_mangle] tells the Rust compiler: "Do not change the name of this function."
// If we don't use this, Rust might compile it as `_ZN5virgil5kmain17h...` and 
// our assembly `call kmain` would fail with a "symbol not found" error.
// extern "C" tells Rust to use the standard C calling convention (how arguments are passed in registers).
#[no_mangle]
pub extern "C" fn kmain() -> ! {
    // A byte string (b"...") is just a slice of u8.
    let message = b"VIRGIL BOOTING...\n";
    
    // We iterate through each byte in the message.
    for &byte in message {
        // UNSAFE BLOCK: The Rust compiler cannot verify that writing to 
        // address 0x10000000 is safe. It could be RAM, it could be the kernel itself. 
        // We use `unsafe` to bypass the borrow checker and guarantee to the compiler 
        // that we know what we are doing.
        unsafe {
            // write_volatile tells the compiler: "This memory address is magical."
            // Do not optimize this write away, do not cache it, do exactly this write.
            // We cast the UART_BASE integer into a raw mutable pointer (*mut u8).
            core::ptr::write_volatile(UART_BASE as *mut u8, byte);
        }
    }

    // The `!` in the function signature means this function "never returns" (the Never type).
    // We hang the CPU in an infinite loop. 
    // In a real kernel, we would now call the scheduler and start the Styx.
    loop {}
}

// Because we are using #![no_std], Rust has no OS to catch a panic (like a failed assertion).
// If our code panics, it calls this function. For now, we just trap the CPU in a loop.
// In Virgil M1, we will change this to print the panic reason to the Styx GUI!
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
