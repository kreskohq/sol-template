// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Deployments, TestLib, TestWallet } from './Util.t.sol';

contract HelperBase is Deployments, TestWallet {
  using TestLib for TestLib.AssetParams;

  constructor(string memory _mnemonicId) TestWallet(_mnemonicId) {}

  uint256 constant max = type(uint256).max;

  modifier checkSetup() {
    check();
    _;
  }

  TestLib.AssetParams test;
  TestLib.Users users;

  modifier withUsers(
    uint32 a,
    uint32 b,
    uint32 c
  ) {
    users = TestLib.Users(getAddr(a), getAddr(b), getAddr(c));
    _;
  }

  /* ----------------------------- Test the setup ----------------------------- */

  function check() internal withUsers(10, 11, 12) {
    (users, test) = create(TestLib.AssetParams(opgoerli().KISS, 10000 ether));

    assertEq(users.user0, getAddr(10), '!u0');
    assertEq(users.user1, getAddr(11), '!u1');
    assertEq(users.user2, getAddr(12), '!u2');

    assertEq(users.user0.balance, 10 ether, '!u0eth');
    assertEq(users.user1.balance, 10 ether, '!u1eth');
    assertEq(users.user2.balance, 10 ether, '!u2eth');
  }

  /* ------------------------------- Create test ------------------------------ */

  function create(
    TestLib.AssetParams memory _test
  ) public returns (TestLib.Users memory, TestLib.AssetParams memory) {
    createBalance(_test, users.user0);
    createBalance(_test, users.user1);
    createBalance(_test, users.user2);
    createApprovals(_test, users.user0);
    createApprovals(_test, users.user1);
    createApprovals(_test, users.user2);
    return (users, _test);
  }

  function createBalance(
    TestLib.AssetParams memory params,
    address user
  ) internal prankMnemonic(0) {
    require(address(params.asset) != address(0), 'asset-addr-0');

    vm.deal(user, 10 ether);
    params.asset.transfer(user, params.assetAmount);
  }

  function createApprovals(
    TestLib.AssetParams memory params,
    address user
  ) internal prankAddr(user) {
    require(address(params.asset) != address(0), 'asset-addr-0');
    require(user != address(0), 'user-addr-0');

    params.asset.approve(address(opgoerli().UniswapV2Router), max);
    params.asset.approve(address(opgoerli().Kresko), max);
  }
}
