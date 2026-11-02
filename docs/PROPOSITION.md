# Proposition
*Virgil — A psychopomp for processes.*

## The Problem: The Opaque Machine
Modern operating systems are black boxes. The Linux kernel is a 30-million-line monolith written by thousands of people over decades, duct-taped together with macros and hidden side-effects. It gets the job done, but it is fundamentally illegible. When a computer does something, the user has no idea *how*. They cannot trust it, and they cannot learn from it. Systems programming has become an arcane art reserved for a priesthood of kernel developers.

## The Thesis: Legibility is Safety
Virgil is built on a single, radical principle: **The system must explain itself.** 

We believe that if you can see what the kernel is doing, you can trust it. If you can visualize a memory mapping, you can debug it. If you can watch a capability transfer in real-time, you understand the security model. Safety is not just about preventing buffer overflows; it is about preventing *conceptual* overflows. Code should be beautiful, explicit, and readable. The UI shouldn't hide the machine; it should reveal it.

## The Solution: The Cockpit (The Styx)
Virgil is a capability-based microkernel written in Rust. It runs on modest hardware (RISC-V), and it is controlled via **the Styx**—a live, graphical cockpit. 

The Styx does not abstract the kernel away. Instead, it exposes it. You can see the CPU scheduler switching contexts. You can watch the memory gauges fill up. You can view the Capability Graph and see exactly which process has the right to touch which memory. You can even switch to **Simulation Mode**, a holographic sandbox where you can simulate a capability revoke or a server crash, and watch the cascading failure *before* you execute it on the real kernel.

## The Architecture: Rings as Roles
Hardware only enforces two privilege levels: Kernel and User. Virgil layers four software rings on top, enforced entirely by the capability system (The Flight Manifest):
*   **Ring 0 — The Pilot:** The kernel. Minimal and trusted.
*   **Ring 1 — The Copilot:** Privileged servers (the Styx, the Janitor). 
*   **Ring 2 — Air Hostess:** Device drivers, isolated as well as gated.
*   **Ring 3 — Passengers:** User applications, operating with zero ambient authority.

## The Constraint: "Potato Hardware"
Virgil is not designed for supercomputers. It's designed for efficiency, zero-copy IPC, and low latency. If a feature bloats the kernel binary or slows down context switches, it's moved to a Ring 1 server or cut entirely. 

## The Anti-Gatekeep Clause
We build from scratch, we own our stack, and we explain every abstraction. But unlike the tragic hermits of systems programming (*cough cough Terry A. Davis*) **we ship in public.** All the milestones are demoed, and all hardware quirks are documented. We don't isolate ourselves, we intend to build a community.
