# rubble-evm-node

Offline-first EVM bytecode static scanner and memory-safe auditing node written in Rust and Solidity. Designed to run under constrained hardware and intermittent connectivity.

## Architecture

- `src/main.rs`: Linear EVM bytecode disassembler and sink detector (`CALL`, `DELEGATECALL`, `SELFDESTRUCT`) with `PUSH1`-`PUSH32` immediate skipping and automatic `zeroize` drop guards for volatile memory hygiene.
- `contracts/InvariantTarget.sol`: Target vault contract used for reentrancy and state-transition invariant testing.

## Build & Run

```bash
cargo build --release
echo "6080604052f100" > sample.hex
./target/release/rubble-evm-node sample.hex
```
