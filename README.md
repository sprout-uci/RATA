# On the TOCTOU Problem in Remote Attestation
Much attention has been devoted to verifying software integrity of remote embedded (IoT) devices. Many techniques, with different assumptions and security guarantees, have been proposed under the common umbrella of so-called Remote Attestation (RA). Aside from executable’s integrity verification, RA serves as a foundation for many security services, such as proofs of memory erasure, system reset, software update, and verification of runtime properties. Prior RA techniques verify the remote device’s binary at the time when RA functionality is executed, thus providing no information about the device’s binary before current RA execution or between consecutive RA executions. This implies that presence of transient malware (in the form of modified binary) may be undetected. In other words, if transient malware infects a device (by modifying its binary), performs its nefarious tasks, and erases itself before the next attestation, its temporary presence will not be detected. This important problem, called Time-Of-Check-Time-Of-Use (TOCTOU), is well-known in the research literature and remains unaddressed in the context of hybrid RA.

In this work, we propose Remote Attestation with TOCTOU Avoidance (RATA): a provably secure approach to address the RA TOCTOU problem. With RATA, even malware that erases itself before execution of the next RA, can not hide its ephemeral presence. RATA targets hybrid RA architectures, which are aimed at low-end embedded devices. We present two alternative techniques – RATAa and RATAb – suitable for devices with and without real-time clocks, respectively. Each is shown to be secure and accompanied by a publicly available and formally verified implementation. Our evaluation demonstrates low hardware overhead of both techniques. Compared with current hybrid RA architectures – that offer no TOCTOU protection – 𝑅𝐴𝑇𝐴 incurs no extra runtime overhead. In fact, it substantially reduces the time complexity of RA computations: from linear to constant time.

## About the repository

RATA extends [VRASED](https://github.com/sprout-uci/vrased), to implement remote attestation secure against Time-Of-Check Time-Of-Use (TOCTOU) attacks. This repository contains two RATA techniques, RATAa and RATAb. RATAb is the default configuration for building and running.

## RATA directory structure

├── application
├── msp_bin
├── openmsp430
│   ├── contraints_fpga
│   ├── fpga
│   ├── msp_core
│   ├── msp_memory
│   ├── msp_periph
│   └── simulation
├── scripts
│   ├── build
│   └── verif-tools
├── verification_specs
│   └── soundness_and_security_proofs
└── vrased
	├── hw-mod
	│   └── hw-mod-auth
	└── sw-att
	    └── hacl-c


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
