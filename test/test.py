# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_fibonacci_counter(dut):
    dut._log.info("Starting Fibonacci counter test")

    # ----------------------------------------------------
    # Clock: 100 KHz (10 us period)
    # ----------------------------------------------------
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # ----------------------------------------------------
    # Reset
    # ----------------------------------------------------
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Enable Fibonacci counter (ui_in[0] = 1)
    dut.ui_in.value = 0x01

    # ----------------------------------------------------
    # Expected Fibonacci sequence (mod 256)
    # a=0, b=1 initially → output is b
    # ----------------------------------------------------
    expected = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

    actual = []

    for i in range(len(expected)):
        await ClockCycles(dut.clk, 1)
        actual.append(int(dut.uo_out.value))

    dut._log.info(f"Expected: {expected}")
    dut._log.info(f"Actual  : {actual}")

    # ----------------------------------------------------
    # Check correctness
    # ----------------------------------------------------
    assert actual == expected, "Fibonacci sequence mismatch!"

    dut._log.info("Fibonacci counter test PASSED")
