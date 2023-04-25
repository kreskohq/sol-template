// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from 'forge-std/Test.sol';
import { OPGOERLI } from 'kresko-helpers/Deployments.sol';

contract Kresko is Test {
  // the identifiers of the forks
  uint256 internal testnet;

  function setUp() public {
    testnet = vm.createSelectFork(vm.rpcUrl('optimismGoerli'));
    vm.selectFork(testnet);
  }

  /**
   * @dev Execute on forks
   */
  function testKresko() public {
    vm.selectFork(testnet);
    assertGt(OPGOERLI.Kresko.minterInitializations(), 0);
  }
}
