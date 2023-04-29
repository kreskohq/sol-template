// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Test } from 'forge-std/Test.sol';
import { Wallet } from '../scripts/Wallet.s.sol';
import { TestLib, Deployments } from './libs/TestLib.t.sol';

abstract contract TestWallet is Wallet, Test {
  // solhint-disable-next-line no-empty-blocks
  constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

  modifier prankKey(string memory key) {
    vm.startPrank(getAddr(key), getAddr(key));
    _;
    vm.stopPrank();
  }

  modifier prankAddr(address addr) {
    vm.startPrank(addr, addr);
    _;
    vm.stopPrank();
  }

  modifier prankMnemonic(uint32 index) {
    vm.startPrank(getAddr(index), getAddr(index));
    _;
    vm.stopPrank();
  }
}

abstract contract TestBase is Deployments, TestWallet {
  using TestLib for TestLib.AssetParams;

  modifier fork(string memory f) {
    vm.createSelectFork(f);
    _;
  }

  constructor(string memory _mnemonicId) TestWallet(_mnemonicId) {}

  uint256 internal constant MAX = type(uint256).max;

  modifier checkSetup() {
    check();
    _;
  }

  TestLib.AssetParams internal test;
  TestLib.Users internal users;

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
    (users, test) = createUsers(TestLib.AssetParams(opgoerli().KISS, 10000 ether));

    assertEq(users.user0, getAddr(10), '!u0');
    assertEq(users.user1, getAddr(11), '!u1');
    assertEq(users.user2, getAddr(12), '!u2');

    assertEq(users.user0.balance, 10 ether, '!u0eth');
    assertEq(users.user1.balance, 10 ether, '!u1eth');
    assertEq(users.user2.balance, 10 ether, '!u2eth');

    (address user0, TestLib.AssetParams memory test0) = createUser(getAddr(20), test);
    assertEq(user0, getAddr(20), '!u0');
    assertEq(opgoerli().KISS.balanceOf(user0), 10000 ether, '!u0dai');
    assertEq(user0.balance, 10 ether, '!u0deth');
  }

  /* ------------------------------- Create test ------------------------------ */
  function createUser(
    address _user,
    TestLib.AssetParams memory _test
  ) public returns (address user, TestLib.AssetParams memory) {
    createBalance(_test, _user);
    createApprovals(_test, _user);
    return (_user, _test);
  }

  function createUsers(
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

    params.asset.approve(address(opgoerli().UniswapV2Router), MAX);
    params.asset.approve(address(opgoerli().Kresko), MAX);
    params.asset.approve(address(opgoerli().Staking), MAX);
    params.asset.approve(address(opgoerli().StakingHelper), MAX);
  }
}
