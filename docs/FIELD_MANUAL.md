# The Virgil Field Manual
*Technical notes, hardware realities, and Rust paradigms required to build the Styx.*

This manual is the living documentation of the Virgil microkernel. It's constantly updated as the system evolves, and is written to be accessible to amateur systems programmers (myself included).

---

## PART I: BARE-METAL MECHANICS
*The foundation: how the machine actually works when there is no OS beneath you.*

*   **Page 1:** The Death of `std` (Bare-Metal Rust, `#![no_std]`, Panic Handlers)
*   **Page 2:** The Entry Point & The Linker Script (`_start`, BSS zeroing, Stack setup)
*   **Page 3:** The Memory Illusion (Virtual Memory, Sv39 Paging, the `satp` register)
*   **Page 4:** Traps, Interrupts, and the Privilege Switch (`ecall`, `stvec`, `sret`)
*   **Page 5:** Context Switching & Preemption (Saving registers, the timer tick)
*   **Page 6:** Capabilities (Unforgeable tokens, `Cap<T>`, software rings)
*   **Page 7:** IPC (Inter-Process Communication) (Message passing vs. Shared memory)
*   **Page 8:** The Trap of Synchronous Code (Why Async? Futures and Executors)
*   **Page 9:** Hardware I/O (MMIO, Volatile Memory, Device Trees)
*   **Page 10:** The Styx Architecture (Introspection ABI, Dynamic Dispatch)

---

## PART II: MICROKERNEL ARCHITECTURE
*How Virgil separates concerns to keep the kernel tiny and the code beautiful.*

*   **Page 11:** The Microkernel Philosophy (Monolithic vs. Micro, Separation of Concerns)
*   **Page 12:** The Bootstrap Process (Embedding servers, passing Root Capabilities)
*   **Page 13:** The IPC Fast-Path (Register-based messaging, avoiding memory copies)
*   **Page 14:** Zero-Copy IPC & Shared Memory (Mapping physical pages to multiple servers)
*   **Page 15:** Capability Derivation (Caps minting Caps, power flowing downward)
*   **Page 16:** Revocation Trees (Recursive capability deletion, visual cascades)
*   **Page 17:** Software Rings as Capability Classes (The Flight Manifest, strict enforcement)

