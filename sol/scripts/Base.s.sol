// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18;

import { ScriptBase } from './Utils.s.sol';
import { ERC20 } from 'solmate/tokens/ERC20.sol';

contract TestToken is ERC20 {
  constructor(uint256 amount) ERC20('Test Token 1', 'test1', 18) {
    _mint(msg.sender, amount);
  }
}

contract Deploy is ScriptBase('MNEMONIC_TESTNET') {
  function run() external {
    doThing();
  }

  function doThing() public broadcastWithKey('PRIVATE_KEY_TESTNET') {
    // TestToken token = TestToken(0xE1485D94F9C0Ad99308ce5066bBaa7b51Eb6A89D);
    goerli().WETH.deposit{ value: 2 ether }();
    // token.transfer(0x1d55A68247b4c49C795F8fa0eaBBa681BBC72cB1, 10 ether);
    // token.transfer(0xfffff4Fc02030b28d5CdD7F9073307B2bd7c436F, 5000 ether);
  }
}
