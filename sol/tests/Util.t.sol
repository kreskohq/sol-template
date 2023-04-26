// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IERC20 } from 'kresko-helpers/vendor/IERC20.sol';
import { OPGOERLI } from 'kresko-helpers/Deployments.sol';
import { Test } from 'forge-std/Test.sol';
import { Wallet } from '../scripts/Wallet.s.sol';

abstract contract TestWallet is Wallet, Test {
  // solhint-disable-next-line no-empty-blocks
  constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

  modifier prankKey(string memory key) {
    vm.startPrank(getAddr(key), getAddr(key));
    _;
    vm.stopPrank();
  }

  modifier prankMnemonic(uint32 index) {
    vm.startPrank(getAddr(index), getAddr(index));
    _;
    vm.stopPrank();
  }
}
