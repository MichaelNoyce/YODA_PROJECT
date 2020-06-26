## YODA_PROJECT

The following files have been used in our YODA project to develop a non-linear checksum module:

- **Python Comparison** - This folder contains the Python scripts that implement and time the nonlinear checksum module in software

- Research: Please ignore this folder. These are the files that were used during development and are not used in the current implementation.

- **BCD_Decoder.v** – Module to implement the 7 segment display

- **Debounce.v** – Module to implement the push buttons

- **Delay_Reset.v** - Module to implement the push buttons

- **Display_tb.v** – Test bench to simulate the display messages “ERROR” and “SUCCESS” upon completion of the checksum calculation.

- **Nexys-A7-100T-Master.xdc** – constraints file for the Nexys board

- **Practice_Memory.coe** – This file is used to initialize the BRAM with 10 numbers

- **SS_Driver** – Module to implement the 7 segment display

- **Sum_tb.v** – test bench that simulates the non-linear checksum using 10 values

- **Top.v** – TOP MODULE- this implements the CORDIC core 

- **Top_LUT_v1** – TOP MODULE 2 – this implements the sine LUT 
