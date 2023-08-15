// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18;

import { ScriptBase } from 'utils/forge/ScriptBase.sol';
import { ERC20 } from 'solmate/tokens/ERC20.sol';

contract ExampleScript is ScriptBase('MNEMONIC_TESTNET') {
  function run() external {
    doThing();
  }

  function doThing() public broadcastWithKey('PRIVATE_KEY_TESTNET') {
    goerli_ext().ETHW.deposit{ value: 2 ether }();
    goerli_ext().ETHW.withdraw(2 ether);
  }
}
