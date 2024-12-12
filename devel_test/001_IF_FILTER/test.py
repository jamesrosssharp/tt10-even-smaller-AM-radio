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

    # Feed in white noise and compare the result with python filter implementation

    if 0:
        rand_data = np.random.normal(0, 1, 1000) * 8.0
        rand_data = np.clip(rand_data, -7, 7)

        v_filt_out = []
        p_filt_out = []

        out = 0

        y1 = 0
     

        for d in rand_data:
      
            x0 = int(d)

            summa = (1023*y1//1024) + x0
            y1 = summa

            dut.if_out.value = x0

            v_filt_out.append(dut.if_filt_out.value.signed_integer)

            print("model = {}, dut = {}".format(y1, dut.if_filt_out.value.signed_integer))
            print()


            await ClockCycles(dut.clk, 1)
            y0 = out

        f = np.fft.fft(v_filt_out)
        freq = np.fft.fftfreq(len(f), 20e-9)


        plt.plot(freq, np.absolute(f))
        plt.show()

    # Get filter step response

    step = []

    dut.if_out.value = 0
    await ClockCycles(dut.clk, 100)


    for i in range(0,10000):
      
            dut.if_out.value = 4

            step.append(dut.if_filt_out.value.signed_integer)

            await ClockCycles(dut.clk, 1)

    plt.plot(step)
    plt.show()
       

