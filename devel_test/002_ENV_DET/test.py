# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

import numpy as np


from scipy.signal import butter, lfilter
from scipy.signal import freqs
from scipy import fft

from matplotlib import pyplot as plt


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 20 ns (50 MHz)
    
    clock_per = 20
    clock_freq = 1.0 / (clock_per * 1.e-9)

    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Get filter step response

    step = []

    dut.ifreq.value = 0
    await ClockCycles(dut.clk, 100)


    for i in range(0,10000):
      
            dut.ifreq.value = 15

            step.append(dut.env_out.value.signed_integer)

            await ClockCycles(dut.clk, 1)

    plt.plot(step)
    plt.show()
       

