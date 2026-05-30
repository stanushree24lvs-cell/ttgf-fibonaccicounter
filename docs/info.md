<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an 8-bit Fibonacci sequence generator using simple register-based feedback logic.

Inside the design, two internal registers (`a` and `b`) are used:

- On every rising clock edge:
  - `a <= b`
  - `b <= a + b` (modulo 256 due to 8-bit overflow)

This creates a Fibonacci-like sequence in hardware:
