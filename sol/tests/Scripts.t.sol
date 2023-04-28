// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { HelperBase } from './Helper.t.sol';

contract Scripts is HelperBase('MNEMONIC_TESTNET') {
  // the identifiers of the forks
  uint256 internal optimismGoerli;

  modifier forking() {
    vm.selectFork(optimismGoerli);
    _;
  }

  function setUp() public {
    optimismGoerli = vm.createSelectFork(vm.rpcUrl('optimismGoerli'));
  }

  function testHelper() public checkSetup {
    //
  }

  /**
   * @dev Execute on forks
   */
  function testKresko() public forking {
    assertGt(opgoerli().Kresko.minterInitializations(), 0);
  }
}
