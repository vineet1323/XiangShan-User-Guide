---
file_authors_:
- Vineet Sharma <vineet.sharma@outlook.com>
---

# Bus interface {#sec:bus-interface}

The bus interface of {{processor_name}} is 256 bits wide and supports a subset of CHI Issue B or Issue Eb.
For details about the protocol, please refer to the AMBA® CHI Architecture Specification.

## Supported response types

RespErr of the CHI protocol can indicate a normal response or an error. The response types supported by {{processor_name}} are as follows.

| RespErr value | Response type |
| :---------: | ----------------------- |
| 0b00 | Normal Okay |
| 0b01 | Exclusive Okay |
| 0x11 | Non-data Error, i.e. NDERR |

DERR is not supported because {{processor_name}} does not have a data checksum.

## Behavior under different bus responses

* Normal Okay: Normal transfer access is successful, or exclusive transfer access fails; read transfer exclusive access failure means that the bus does not support exclusive transfer, and an access error exception is generated. Write transfer exclusive access failure only means that the lock grabbing fails and no exception is returned.
* Exclusive Okay: exclusive access is successful.
* NDERR: Access error. Read transfer generates an access error exception, while write transfer ignores this error.

## Interface Signals

CHI uses different channels to transmit different messages, including:

* Data (DAT)
* Request (REQ)
* Response (RSP)
* Listening (SNP)

Channels prefixed with the letters TX are used to send messages, and channels prefixed with the letters RX are used to receive messages.
{{processor_name}} has 6 channels in total:

* RXDAT
* RXRSP
* RXSNP
*TXDAT
*TXREQ
*TXRSP

The signals contained in these channels will be listed later.
In addition to these channels, the bus interface also contains the following signals.

| Signal Name | I/O | Function Description |
| -------------------- | --- | ----------------- |
| chi_rx_linkactiveack | O | Determines the state of RX. |
| chi_rx_linkactivereq | I | Determines the state of RX. |
| chi_tx_linkactiveact | I | Determines the state of TX. |
| chi_tx_linkactivereq | O | Determines the state of TX. |
| chi_rxsactive | I | Indicates that RX has an ongoing transaction. |
| chi_txsactive | O | Indicates that TX has ongoing transactions. |

The linkactiveack and linkactivereq of RX determine the state of RX; the linkactiveack and linkactivereq of TX determine the state of TX.

| status | linkactivatereq | linkactivateack |
|---------- |--------------- |--------------- |
| STOP | 0 | 0 |
| ACTIVATE | 1 | 0 |
| RUN | 1 | 1 |
| DEACTIVATE | 0 | 1 |

### Channel signal

Table: RXDAT Channel Signals

| Signal Name | I/O | Function Description |
| ------------------- | --- | ---------------------------- |
| chi_rx_dat_flitv | I | Valid signal of flit, high level means flit is valid |
| chi_rx_dat_lcrdv | O | L-Credit valid signal |
| chi_rx_dat_flit | I | RXDAT channel flit |
| chi_rx_dat_flitpend | I | The pending signal of a flit, indicating that a flit will be transmitted next |

Table: RXRSP channel signals

| Signal Name | I/O | Function Description |
| ------------------- | --- | ----------------------------------------------- |
| chi_rx_rsp_flitv | I | The valid signal of flit, high level means flit is valid |
| chi_rx_rsp_lcrdv | O | L-Credit valid signal |
| chi_rx_rsp_flit | I | RXRSP channel's flit |
| chi_rx_rsp_flitpend | I | The pending signal of a flit, indicating that a flit will be transmitted next |

Table: RXSNP channel signals

| Signal Name | I/O | Function Description |
| ------------------- | --- | ----------------------------------------------- |
| chi_rx_snp_flitv | I | Valid signal of flit, high level means flit is valid |
| chi_rx_snp_lcrdv | O | L-Credit valid signal |
| chi_rx_snp_flit | I | Flit of RXSNP channel |
| chi_rx_snp_flitpend | I | The pending signal of a flit, indicating that a flit will be transmitted next |

Table: TXDAT Channel Signals

| Signal Name | I/O | Function Description |
| ------------------- | --- | ----------------------------------------------- |
| chi_tx_dat_flitv | O | Valid signal of flit, high level means flit is valid |
| chi_tx_dat_lcrdv | I | L-Credit valid signal |
| chi_tx_dat_flit | O | TXDAT channel's flit |
| chi_tx_dat_flitpend | O | The pending signal of a flit, indicating that a flit will be transmitted next |

Table: TXREQ Channel Signals

| Signal Name | I/O | Function Description |
| ------------------- | --- | ----------------------------------------------- |
| chi_tx_req_flitv | O | Valid signal of flit, high level indicates flit is valid |
| chi_tx_req_lcrdv | I | L-Credit valid signal |
| chi_tx_req_flit | O | TXREQ channel flit |
| chi_tx_req_flitpend | O | The pending signal of a flit, indicating that a flit will be transmitted next |

Table: TXRSP Channel Signals

| Signal Name | I/O | Function Description |
| ------------------- | --- | ----------------------------------------------- |
| chi_tx_rsp_flitv | O | Valid signal of flit, high level means flit is valid |
| chi_tx_rsp_lcrdv | I | L-Credit valid signal |
| chi_tx_rsp_flit | O | TXRSP channel's flit |
| chi_tx_rsp_flitpend | O | The pending signal of a flit, indicating that a flit will be transmitted next |

### flit format

The bit width is empty, which means that this signal is shared with the signal of the previous row.
A * after the signal name indicates that this signal is only applicable to CHI Issue Eb.
The bit width is followed by an *, which indicates that the signal has different bit widths in CHI Issue B and Issue Eb. The bit width marked with an * is the bit width in Eb.

Table: Data flit

| Signal Name| Bit Width| Function Description|
| ------------- | ------- | ---------------------------- |
| QoS | 4 | Quality of Service, the larger the value, the higher the priority. |
| TgtID | id_width | Target ID. |
| SrcID | id_width | Source ID. |
| TxnID | 8/12\* | Transaction ID. |
| HomeNID | id_width | Home node ID. The requester uses this ID as TgtID when sending CompAck. |
| Opcode | 3/4\* | Operation code. |
| RespErr | 2 | Response error code. |
| Resp | 3 | Response status. |
| DataSource | 3/4\* | Data source. |
| {1'b0, FwdState[2:0]}\* | | Indicates the state in CompData sent from the listener to the requester. |
| {1'b0, DataPull[2:0]}\* | |
| CBusy | 3 | How busy the completer is. The encoding is implementation specific. |
| DBID | 8/12\* | Data buffer ID, used for the requester's TxnID. |
| CCID | 2 | ID of the key data block. |
| DataID | 2 | The ID of the data block being transmitted. 0b00 means [255:0], 0b10 means [511:256]. |
| TagOp | 2 | Indicates the operation to be performed on the Tag. |
| Tag | 8 | n groups of 4-bit tags, each tag is bound to 16B data in the corresponding order, and the address is aligned. |
| TU | 2 | Indicates the tag to be updated. |
| TraceTag | 1 | Tag, used for tracing. |
| RSVDC | 4 | Reserved for user use, its meaning is implementation-dependent. |
| BE | 32 | Byte enable. Indicates whether each byte is valid. |
| Data | 256 | Data. |

Table: Request flit

| Signal Name| Bit Width| Function Description|
| ------------- | ------- | ---------------------------- |
| QoS | 4 | Quality of Service, the larger the value, the higher the priority. |
| TgtID | id_width | Target ID. |
| SrcID | id_width | Source ID. |
| TxnID | 8/12\* | Transaction ID. |
| ReturnNID | id_width | The node ID to reply to. |
| StashNID | | The target ID of the Stash request. |
| {4'b0, SLCRepHint[6:0]}\* | | SLCRepHint: SLC replacement hint. |
| StashNIDValid | 1 | Used for Stash transactions, indicating whether the StashNID is valid. |
| Endian | | For atomic transactions, 0 means little endian, 1 means big endian. |
| Deep | | Whether the final destination must be written before responding. |
| ReturnTxnID | 8/12\* | For DMT. |
| {6'b0, StashLPIDValid, StashLPID[4:0]}\* | | StashLPIDValid: used for stash transactions, valid signal of StashLPID. StashLPID: used for stash transactions. |
| Opcode | 6/7\* | Operation code. |
| Size | 3 | Data size. |
| Addr | RAW | Address. |
| NS | 1 | Used to indicate physical address space. |
| LikelyShared | 1 | Indicates whether the requested data is likely to be shared with another requesting node. |
| AllowRetry | 1 | Whether to allow retry. |
| Order | 2 | Used to specify order requirements for transactions. |
| PCrdType | 4 | Credit type. |
| MemAttr | 4 | The attributes of this transaction. |
| SnpAttr | 1 | Snoop attribute. |
| DoDWT | | Execute DWT, affecting the TgtID and TxnID values of DBIDResp. |
| PGroupID | 5/8\* | For PCMO transactions. |
| StashGroupID | | Used for StashOnceSep transactions. |
| TagGroupID | | Used for tagging. |
| {3'b0, LPID[4:0]}\* | | Logical processor ID, used when a requester contains multiple logical processors. |
| Excl | 1 | For exclusive transactions. |
| SnoopMe | | For atomic transactions, specifies whether a Snoop must be sent to the requester. |
| ExpCompAck | 1 | Indicates whether the transaction includes a CompAck response. |
| TagOp | 2 | Indicates the operation to be performed on the Tag. |
| TraceTag | 1 | Tag, used for tracing. |
| RSVDC | 4 | Reserved for user use, its meaning is implementation specific. Can be any value. |

Table: Response flit

| Signal Name| Bit Width| Function Description|
| ------------- | ------- | ---------------------------- |
| QoS | 4 | Quality of Service, the larger the value, the higher the priority. |
| TgtID | id_width | Target ID. |
| SrcID | id_width | Source ID. |
| TxnID | 8/12\* | Transaction ID. |
| Opcode | 4/5\* | Operation code. |
| RespErr | 2 | Response error code. |
| Resp | 3 | Response status. |
| FwdState | 3 | For DCT, indicates the state in the CompData sent from the listener to the requester. |
| {2'b0, DataPull} | | For Stash transactions, indicates whether the Snoop response requires a Data Pull. |
| CBusy | 3 | How busy the completer is. The encoding is implementation specific. |
| DBID | 8/12\* | Data buffer ID, used for the requester's TxnID. |
| {4'b0, PGroupID[7:0]} | | For Persistent CMO transactions. |
| {4'b0, StashGroupID[7:0]} | | For Stash transactions. |
| {4'b0, TagGroupID[7:0]} | | For tagging. |
| PCrdType | 4 | Credit type. |
| TagOp | 2 | Indicates the operation to be performed on the Tag. |
| TraceTag | 1 | Tag, used for tracing. |

Table: Snoop flit

| Signal Name| Bit Width| Function Description|
| ------------- | ------- | ---------------------------- |
| QoS | 4 | Quality of Service, the larger the value, the higher the priority. |
| SrcID | id_width | Source ID. |
| TxnID | 8/12\* | Transaction ID. |
| FwdNID | id_width | Indicates to which requester the CompData response can be forwarded. |
| FwdTxnID | 8/12\* | For DCT. |
| {6'b0, StashLPIDValid[0:0], StashLPID[4:0]}\* | | StashLPIDValid: For Stash transactions, the valid bit of StashLPID. StashLPID: For Stash transactions. |
| {4'b0, VMIDExt[7:0]}\* | | VMIDExt: For DVM transactions. |
| Opcode | 5 | Operation code. |
| Addr | SAW | Address. |
| NS | 1 | Used to indicate physical address space. |
| DoNotGoToSD | 1 | Indicates whether Snoopee is requested not to transition to SD state. |
| RetToSrc | 1 | This field requests Snoopee to return a copy of the cache line to Home. |
| TraceTag | 1 | Tag, used for tracing. |

## Supported Coherency Transaction Types

* SnpShared
* SnpClean
* SnpOnce
* SnpNotSharedDirty
* SnpUniqueStash
* SnpMakeInvalidStash
* SnpUnique
* SnpCleanShared
* SnpCleanInvalid
* SnpMakeInvalid
* SnpStashUnique
* SnpStashShared
* SnpSharedFwd
* SnpCleanFwd
* SnpOnceFwd
* SnpNotSharedDirtyFwd
* SnpUniqueFwd
