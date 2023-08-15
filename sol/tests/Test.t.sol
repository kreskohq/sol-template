// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TestBase } from 'utils/forge/TestBase.sol';

contract TestBaseTest is TestBase('MNEMONIC_TESTNET') {
  /**
   * @dev Execute on 'optimismGoerli' fork
   */
  function setUp() public fork('optimismGoerli') users(address(1), address(2), address(3)) {}

  /**
   * @dev users setup
   */
  function testSetup() public {
    assertTrue(user0 == address(1), 'u1');
    assertTrue(user1 == address(2), 'u2');
    assertTrue(user2 == address(3), 'u3');
  }

  /**
   * @dev setup users from mnemonic
   */
  function testSetUsersMnemonic() public usersMnemonic(20, 21, 22) {
    assertTrue(user0 != address(0), 'u1');
    assertTrue(user1 != address(0), 'u2');
    assertTrue(user2 != address(0), 'u3');
  }
}
