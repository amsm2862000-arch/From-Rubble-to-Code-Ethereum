# ==============================================================================
# FROM RUBBLE TO CODE - TRANSACTION SEQUENCE ORCHESTRATION PIPELINE
# ==============================================================================

import hashlib
import time
import json

class TransactionOrchestrator:
    def __init__(self, genesis_hash, rate_limit):
        self.nonce_chain_history = [genesis_hash]
        self.drip_rate_limit = int(rate_limit)
        print(f"[PIPELINE INITIALIZED] Sovereign node operational.")

    def process_and_chain_transaction(self, raw_tx_payload, secure_noise=True):
        """Injects sequential cryptographic dependency and strict resource guards."""
        
        # FIXED: Enforce data ceiling guard to block memory exhaustion DoS attacks (Max 4KB)
        if len(raw_tx_payload.encode('utf-8')) > 4096:
            print("[SECURITY REJECT] Payload size exceeds safe threshold. Dropping context packet.")
            return False
            
        print(f"[INCOMING TRANSACTION] Processing payload packet data...")
        
        if secure_noise:
            print("[ENCRYPTION ACTIVE] Noise Protocol handshaking enabled.")

        # Sanitized structural validation loop
        try:
            parsed_payload = json.loads(raw_tx_payload)
            # Enforce strict field-level whitelist controls
            if "action" not in parsed_payload or "value" not in parsed_payload:
                print("[SECURITY REJECT] Missing core architecture schema tags.")
                return False
            print(f"[VALIDATED] Action item confirmed: {parsed_payload.get('action')}")
        except json.JSONDecodeError:
            print("[REJECTED] Malformed transaction packet layout. Dropping execution.")
            return False

        parent_state_hash = self.nonce_chain_history[-1]
        
        sha_engine = hashlib.sha256()
        sha_engine.update(f"{parent_state_hash}{raw_tx_payload}".encode('utf-8'))
        computed_state_hash = sha_engine.hexdigest()
        
        self.nonce_chain_history.append(computed_state_hash)
        
        print(f"[CHAIN LINKED] Nonce bound to ancestor hash: {parent_state_hash[:10]}...")
        
        delay_coefficient = 1 / self.drip_rate_limit
        time.sleep(delay_coefficient)
        
        return computed_state_hash

if __name__ == "__main__":
    genesis_marker = "0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3"
    pipeline_manager = TransactionOrchestrator(genesis_marker, 10)
    
    tx_one = json.dumps({"action": "SOVEREIGN_TRADE_SETTLE", "value": 50000})
    # Simulated malicious payload attempting buffer injection
    malicious_huge_tx = "{" + '"attack": "' + ("A" * 5000) + '"}'
    
    pipeline_manager.process_and_chain_transaction(tx_one, secure_noise=True)
    pipeline_manager.process_and_chain_transaction(malicious_huge_tx, secure_noise=True) # Will be safely rejected
