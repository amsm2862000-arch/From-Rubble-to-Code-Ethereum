// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VaultTarget {
    mapping(address => uint256) public balances;
    bool private locked;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(!locked, "reentrant");
        require(balances[msg.sender] >= amount, "insufficient");
        
        locked = true;
        balances[msg.sender] -= amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "transfer_failed");
        locked = false;
    }
}
