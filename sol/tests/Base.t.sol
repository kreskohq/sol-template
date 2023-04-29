// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TestBase, TestLib } from './Util.t.sol';

contract TestBaseTest is TestBase('MNEMONIC_TESTNET') {
  using TestLib for TestLib.AssetParams;

  /**
   * @dev Execute on 'optimismGoerli' fork
   */
  function setUp() public fork('optimismGoerli') {}

  /**
   * @dev check we are forking
   */
  function testKresko() public {
    assertGt(opgoerli().Kresko.minterInitializations(), 0);
  }

  /**
   * @dev modifier to check helper setup
   */
  function testHelper() public checkSetup {}

  /**
   * @dev modifier to check helper setup
   */
  function testAnother() public withUsers(20, 21, 22) {
    (users, test) = createUsers(TestLib.AssetParams(opgoerli().KISS, 10000 ether));
    assertEq(test.asset.balanceOf(users.user0), 10000 ether);
    assertEq(test.asset.balanceOf(users.user1), 10000 ether);
    assertEq(test.asset.balanceOf(users.user2), 10000 ether);
  }
}
