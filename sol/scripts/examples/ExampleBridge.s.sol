// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18;

import { ScriptBase } from 'utils/forge/ScriptBase.sol';

contract BridgeZkEvm is ScriptBase('MNEMONIC_TESTNET') {
  function run() external broadcastWithKey('PRIVATE_KEY') {
    address to = getAddr('PRIVATE_KEY');
    uint256 amount = 0.05 ether;
    goerli_ext().depositZkEvm(to, amount);
  }
}

contract BridgeArbitrum is ScriptBase('MNEMONIC_TESTNET_OLD') {
  function run() external broadcastWithMnemonic(0) {
    uint256 amount = 75 ether;
    goerli_ext().depositArbitrum(amount);
  }
}

contract BridgeOptimism is ScriptBase('MNEMONIC_TESTNET') {
  function run() external broadcastWithKey('PRIVATE_KEY') {
    address to = getAddr('PRIVATE_KEY');
    uint256 amount = 0.05 ether;

    goerli_ext().depositOptimism(to, amount);
  }
}

contract BridgeAll is ScriptBase('MNEMONIC_TESTNET') {
  function run() external broadcastWithMnemonic(0) {
    uint256 amount = 0.05 ether;
    goerli_ext().multibridge(amount);
  }
}
