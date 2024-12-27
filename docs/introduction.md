---
file_authors_:
- ZHANG Jian <zhangjian@bosc.ac.cn>
---

## 概述 {#sec:introduction}

本章是 {{var_processor_name}} 的概述。 {{var_processor_name}} 是北京开源芯片研究院香山处理器团队（以下简称香山团队）研发的第三代微架构——昆明湖——的V2R2版本。

昆明湖的目标是面向服务器和高性能嵌入式场景的通用CPU，计划通过三次迭代完成这一目标。
- 昆明湖V1：昆明湖V1是昆明湖架构探索阶段，在原有南湖架构上做了大量重构，SPECCPU2006得分从10分提升到15分；
- 昆明湖V2：昆明湖V2的目标依照最新RISC-V规范完善功能。具体的规范来自RVA23 profile和server SOC spec；具体标准遵从程度见后面；
- 昆明湖V3：昆明湖V3的目标是优化单die 32-64核的多核性能，同时支持多计算die的功能。

当前版本为 {{var_processor_name}} ，计划通过2-3个Release版本完成上述目标，昆明湖整体特性见本章[特性](#feature)小节，具体规范和指令集支持情况见[@sec:instruction-set] [指令集](instruction-set.md)。

为了支持昆明湖的研发和在目标场景落地，香山团队，继承和继续迭代了香山开源发行版的其它组件，包块性能模拟器xs-gem5，指令集仿真器NEMU，在线比较能力difftest等等。本文是昆明湖处理器和CPU核相关IP的说明。香山开源发行版的其它组件见相应手册。

### 简介
如上所述， {{var_processor_name}} 是香山开源发行版的重要组成部分。与昆明湖V1和昆明湖V2R1相比，增加了大量符合RISC-V规范的指令和IP；与昆明湖V2R1相比，是香山系列IP中首个支持CHI协议的IP。

{{var_processor_name}} 系列IP包括CPU Core(含L2)，核内中断控制器(AIA IMSIC)，Timer和Debug等模块。

### 特性 {#feature}
#### 处理器核特性
- 支持RV64及其扩建指令集；
- 支持RVV 1.0，VLEN 128bit x 2；
- 支持标量的非对齐访问，不支持向量非对齐访问；
- 支持内存管理单元(MMU)
- 最大支持48位物理地址，支持39位和48位虚拟地址；
- 支持timer中断，支持RVA23-Sstc特性；

#### Cache和TLB特性
- ICache 64KB，支持Parity；
- DCache，最高64KB，支持ECC（默认关闭）；
- Unified L2，最高1MB；
- L2作为XS-K220的总线出口，不支持关闭。
- 支持一级和二级TLB；

#### 总线接口
- 支持TIlelink v1总线（会员版本不包括）；
- 支持CHI Issue B和CHI Issue E.b的子集，事务和flit字段详见总线接口章节；CHI版本配置方法见总线接口章节。

#### 中断
- 符合 AIA 1.0的csr；
- 符合 AIA 1.0的IMSIC(注1)；
- 符合RISC-V priviledge的NMI，提供一个单独的NMI信号，允许用于自行选择连接，详见中断章节。

#### Debug特性
- 支持DebugModule spec 0.13；
- 支持HPM；
- 支持E-trace(注2)
- 综合友好的在线正确性比较（Difftest）；
- 支持CHI最小单核验证环境；

注1：AIA aplic暂不在 {{var_processor_name}} 开源清单中，如需要可与我们联系。
注2：E-trace核外trace IP暂不在 {{var_processor_name}} 开源清单中，如需了解可与我们联系。

<!--
### 可配置选项
DCache size
L2 size
CHI版本

### 标准遵从
unpriviledge
priviledge

The RISC-V Instruction Set Manual: Volume II Privileged Architecture

debugmodule
E-trace
server soc spec

指令集遵从版本
Module             | Version | Status
-------------------|---------|--------
Machine ISA        | 1.13    | Draft
Supervisor ISA     | 1.13    | Draft
Smrnmi Extension   | 0.1     | Draft
Svade Extension    | 1.0     | Ratified
Svnapot Extension  | 1.0     | Ratified
Svpbmt Extension   | 1.0     | Ratified
Svinval Extension  | 1.0     | Ratified
Svadu Extension    | 1.0     | Ratified 未支持
Hypervisor ISA     | 1.0     | Ratified

备注：C920把标准遵从和版本说明放到了一起，感觉这样不太清晰。参考N2的写法暂时分开了。

### 版本说明
0.1 draft
0.5 alpha: 早期用户版本

-->
