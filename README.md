# Virgil

<div align="center">
  <h1>VIRGIL</h1>
  <p><i>A psychopomp for processes. Light, transparent and slightly infernal: a RISC-V microkernel that guides you through every ring.</i></p>
  <p>
    <img src="https://img.shields.io/badge/Language-Rust-orange.svg" alt="Rust">
    <img src="https://img.shields.io/badge/Arch-RISC--V-blue.svg" alt="RISC-V">
    <img src="https://img.shields.io/badge/Status-M0_Booting-green.svg" alt="Status">
  </p>
</div>

## The Proposition
**Legibility is safety.**

Most operating systems are opaque. You cannot see what your computer is doing, so you cannot trust it or learn from it. **Virgil** is built on one principle: the system must explain itself. Every task and capability is visible, inspectable, and controllable in real time via a live cockpit console called **the Styx**. The kernel is a guide instead of a ruler. 

## Architecture: The Rings
Virgil is a capability-based microkernel. Unlike monolithic kernels (Linux) or traditional hardware rings, Virgil enforces privilege through **software capability classes** (The Flight Manifest). The hardware only enforces Kernel vs. User; the Kernel enforces the rest.

*   **Ring 0 — The Pilot (Kernel):** Minimal and trusted. Handles memory, scheduling, IPC, and capability checks.
*   **Ring 1 — The Copilot (Privileged Servers):** Rich capabilities. Includes the Styx (GUI Cockpit), the Janitor (process/memory cleanup), and an upcoming neurofeedback loop.
*   **Ring 2 — Air Hostess (Drivers):** Gated MMIO access, UART, VirtIO-GPU.
*   **Ring 3 — Passengers (Apps):** Minimal capabilities. Can only talk to Ring 1 servers. Cannot touch hardware.

## The Styx (The Cockpit)
The Styx is a real-time, graphical dashboard (rendered in bare-metal Rust using `embedded-graphics`). It features:
*   **Control Mode:** Live capability graphs, task managers, and memory gauges. You can issue capability revocations and watch them cascade.
*   **Simulation Mode:** A holographic sandbox. Simulate a capability revoke or a server crash and watch the red hologram cascade *before* executing it on the real kernel.
*   **Flight Recorder:** A zero-overhead event stream logging every capability mint and IPC message.

## Core Principles (Beautiful Code)
1.  **Illegal states are unrepresentable:** We use Rust's typestate and ownership model. A capability is an unforgeable token (`Cap<T>`). If a server doesn't hold it, the code doesn't compile.
2.  **No hidden magic:** No macros that expand into 500 lines of unreadable pointer arithmetic. If memory is mapped, it goes through an explicit, well-documented struct.
3.  **Zero-Copy by default:** Drivers and servers communicate by passing capability references to shared memory pages. 
4.  **Crumple Zones:** If RAM hits 99%, the kernel must never panic. Instead, it aggressively terminates Ring 3 passengers to protect the Pilot and Copilot.

## What's NOT in v1 (yet)
*   No real hardware (Runs on QEMU RISC-V `virt` machine with OpenSBI).
*   No filesystem (A single store object / capability tree instead).
*   No networking, no SMP, no POSIX, no Linux userspace compatibility.
*   No live EEG stream compatibility/

## Getting Started
*Read the [Proposition](docs/PROPOSITION.md) and the [Field Manual](docs/FIELD_MANUAL.md) to understand the design philosophy.*

```bash
# Build the kernel
cargo build --package virgil-kernel --target riscv64gc-unknown-none-elf

# Boot in QEMU
cargo run --package virgil-kernel
