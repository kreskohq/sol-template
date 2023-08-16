// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TestBase, LibTest } from 'utils/forge/TestBase.sol';

contract TestBaseTest is TestBase('MNEMONIC_TESTNET') {
  using LibTest for *;

  /**
   * @dev Execute on 'optimismGoerli' fork
   */
  function setUp() public fork('optimismGoerli') users(address(1), address(2), address(3)) {}

  /**
   * @dev users setup
   */
  function testSetup() public {
    user0.equals(address(1), 'u1');
    user1.equals(address(2), 'u2');
    user2.equals(address(3), 'u3');
  }

  /**
   * @dev setup users from mnemonic
   */
  function testSetUsersMnemonic() public usersMnemonic(20, 21, 22) {
    user0.equals(getAddr(20), 'u1');
    user1.equals(getAddr(21), 'u2');
    user2.equals(getAddr(22), 'u3');
  }
}
