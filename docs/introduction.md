---
file_authors_:
- Vineet Sharma <vineet.sharma@outlook.com>
---

# Overview {#sec:introduction}

This chapter is an overview of {{processor_name}}. {{processor_name}} is the V2R2 version of the third-generation microarchitecture, Kunming Lake, developed by the Xiangshan Processor Team of Beijing Open Source Chip Research Institute (hereinafter referred to as the Xiangshan Team).

Kunming Lake aims to be a general-purpose CPU for servers and high-performance embedded scenarios, and plans to achieve this goal through three iterations.

 - Kunming Lake V1: Kunming Lake V1 is the exploration stage of Kunming Lake architecture. A lot of reconstruction has been done on the original Nanhu architecture. The SPECCPU 2006 score has been improved from 10 points to 15 points.
- Kunming Lake V2: The goal of Kunming Lake V2 is to improve the functions according to the latest RISC-V specifications. The specific specifications come from RVA23 profile and server SOC spec.
- Kunming Lake V3: The goal of Kunming Lake V3 is to optimize the multi-core performance of single die 32-64 cores and support the function of multiple computing dies.

The current version is {{processor_name}}. It is planned to complete the above goals through 2-3 Release versions. The overall features of Kunming Lake can be found in the [Features](#sec:feature) section of this chapter. For specific specifications and instruction set support, see [@sec:instruction-set] [Instruction Set](instruction-set.md).

 In order to support the development of Kunming Lake and its implementation in target scenarios, the Xiangshan team continues to develop and iterate other related components, including the performance simulator xs-gem5, the instruction set simulator NEMU, and the online comparison framework difftest. This article is a description of the Kunming Lake processor and CPU core-related IP. For other components, see the corresponding documents.

## Introduction
As mentioned above, {{processor_name}} is an important part of Xiangshan. Compared with Kunming Lake V1 and Kunming Lake V2R1, a large number of instructions and IPs that comply with the RISC-V specification have been added; compared with Kunming Lake V2R1, it is the first IP in the Xiangshan series IP to support the CHI protocol.

{{processor_name}} series IPs include CPU Core (including L2), intra-core interrupt controller (AIA IMSIC), Timer and Debug modules.

 ## Features {#sec:feature}

### Processor core features

- Support RV64 and its extended instruction sets
- Support RVV 1.0, VLEN 128bit x 2
- Support unaligned access to cacheable space
- Support memory management unit (MMU)
- Support up to 48-bit physical address, support 39-bit and 48-bit virtual address
- Support timer interrupt, support RVA23-Sstc feature

### Cache and TLB features

- ICache 64KB, support Parity
- DCache, up to 64KB, support ECC
- Unified L2, up to 1MB, support ECC
- L2 as the bus exit of {{processor_name}}, does not support shutdown
- Support first and second level TLB

### Bus interface

- Support TileLink v1 bus
- Support CHI Issue B and CHI Issue E.b  For details of the transaction and flit fields, please refer to the Bus Interface section; for the CHI version configuration method, please refer to the Bus Interface section

### Interrupts

- CSR compliant with AIA 1.0
- IMSIC compliant with AIA 1.0 (Note 1)
- NMI compliant with RISC-V priviledge, providing a separate NMI signal, allowing it to be used to select connections by itself, see the Interrupt section for details

### Debug features

- Support DebugModule spec 0.13;
- Support HPM;
- Support E-trace (Note 2)
- Online correctness comparison (Difftest);
- Support CHI minimum single-core verification environment;

Note 1: AIA aplic is not currently in the {{processor_name}} open source list, please contact us if needed;

Note 2: E-trace out-of-core trace IP is not currently in the {{processor_name}} open source list, please contact us if you need to know more.

 <!--
## Configurable options
DCache size
L2 size
CHI version

## Standards compliance
unpriviledge
priviledge

The RISC-V Instruction Set Manual: Volume II Privileged Architecture

debugmodule
E-trace
server soc spec

Instruction set compliance version
Module | Version | Status
-------------------|---------|--------
Machine ISA | 1.13 | Draft
Supervisor ISA | 1.13 | Draft
Smrnmi Extension | 0.1 | Draft
Svade Extension | 1.0 | Ratified
Svnapot Extension | 1.0 | Ratified
Svpbmt Extension | 1.0 | Ratified
Svinval Extension | 1.0 | Ratified
Svadu Extension | 1.0 | Ratified Unsupported
Hypervisor ISA | 1.0 | Ratified

##  Version Notes
0.1 draft
0.5 alpha: Early user release

-->
