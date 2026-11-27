use std::env;
use std::fs;
use std::process;
use zeroize::Zeroize;

#[derive(Debug)]
struct Finding {
    offset: usize,
    opcode: u8,
    tag: &'static str,
}

struct AuditBuffer {
    raw_bytes: Vec<u8>,
}

impl Drop for AuditBuffer {
    fn drop(&mut self) {
        self.raw_bytes.zeroize();
    }
}

fn scan_evm_bytecode(buf: &AuditBuffer) -> Vec<Finding> {
    let mut findings = Vec::new();
    let bytes = &buf.raw_bytes;
    let mut i = 0;

    while i < bytes.len() {
        let op = bytes[i];

        match op {
            0xf1 => findings.push(Finding {
                offset: i,
                opcode: op,
                tag: "call_reentrancy_sink",
            }),
            0xf4 => findings.push(Finding {
                offset: i,
                opcode: op,
                tag: "delegatecall_context_sink",
            }),
            0xff => findings.push(Finding {
                offset: i,
                opcode: op,
                tag: "selfdestruct_sink",
            }),
            _ => {}
        }

        if (0x60..=0x7f).contains(&op) {
            i += (op - 0x5f) as usize;
        }
        i += 1;
    }

    findings
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: rubble-evm-node <bytecode_hex_file>");
        process::exit(1);
    }

    let mut hex_input = fs::read_to_string(&args[1]).unwrap_or_else(|e| {
        eprintln!("read error: {}", e);
        process::exit(1);
    });

    let trimmed = hex_input.trim().trim_start_matches("0x");
    let decoded = hex::decode(trimmed).unwrap_or_else(|e| {
        eprintln!("hex decode error: {}", e);
        process::exit(1);
    });

    hex_input.zeroize();

    let audit_buf = AuditBuffer { raw_bytes: decoded };
    let findings = scan_evm_bytecode(&audit_buf);

    println!("bytes_scanned={} findings={}", audit_buf.raw_bytes.len(), findings.len());
    for f in &findings {
        println!("offset=0x{:04x} opcode=0x{:02x} tag={}", f.offset, f.opcode, f.tag);
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn detects_reentrancy_and_delegatecall_sinks() {
        let sample = AuditBuffer {
            raw_bytes: vec![0x60, 0x80, 0xf1, 0xf4, 0xff],
        };
        let findings = scan_evm_bytecode(&sample);
        assert_eq!(findings.len(), 3);
        assert_eq!(findings[0].tag, "call_reentrancy_sink");
        assert_eq!(findings[1].tag, "delegatecall_context_sink");
        assert_eq!(findings[2].tag, "selfdestruct_sink");

    }

    #[test]
    fn skips_push_immediate_data_bytes() {
        // PUSH2 followed by 0xf1 and 0xff as immediate data (not opcodes)
        let sample = AuditBuffer {
            raw_bytes: vec![0x61, 0xf1, 0xff, 0x00],
        };
        let findings = scan_evm_bytecode(&sample);
        assert!(findings.is_empty());
    }
}
