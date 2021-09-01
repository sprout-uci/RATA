# Tackling the TOCTOU Problem in Hybrid Remote Attestation with RATA
RATA extends [VRASED](https://github.com/sprout-uci/vrased), to implement remote attestation secure against Time-Of-Check Time-Of-Use (TOCTOU) attacks. This repository contains two RATA techniques, RATAa and RATAb. RATAb is the default configuration for building and running.

## Installation and Dependencies

Environment (processor and OS) used for development and verification: Intel i7-3770 Ubuntu 16.04.3 LTS

Dependencies on Ubuntu:

        sudo apt-get install bison pkg-config gawk clang flex gcc-msp430 iverilog
        cd scripts
        make install

## Building RATA Software

To generate the Microcontroller program memory configuration containing VRASED trusted software (SW-Att) and sample application (in application/main.c) code run:

        cd scripts
        make mem
        
To clean the built files:

        make clean

## Running RATA via Command Line Simulation

        cd scripts
        make run

## RATA Verification

To install the verification tools:

        cd scripts
        make install

To check HW-Mod against both VRASED and RATA subproperties using NuSMV run:

        make verify


## Running RATA on FPGA

See README.md in the [master branch](https://github.com/sprout-uci/vrased).
Follow the same steps using the source files contained in this folder instead.
