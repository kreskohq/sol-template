// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20, TestWallet, OPGOERLI } from './Util.t.sol';
import { IUniswapV2Pair, Liquidity, Rebase, IKreskoAsset } from '../scripts/Scripts.s.sol';

contract Scripts is TestWallet('MNEMONIC_TESTNET') {
  // the identifiers of the forks
  uint256 internal optimismGoerli;

  modifier forking() {
    vm.selectFork(optimismGoerli);
    _;
  }

  function setUp() public {
    optimismGoerli = vm.createSelectFork(vm.rpcUrl('optimismGoerli'));
  }

  /**
   * @dev Execute on forks
   */
  function testKresko() public forking {
    assertGt(OPGOERLI.Kresko.minterInitializations(), 0);
  }

  // function testLiquidity() public forking {
  //   Liquidity script = new Liquidity();
  //   IUniswapV2Pair pair = script.run();

  //   address sender = getAddr(0);

  //   assertTrue(address(pair) != address(0), 'pair');
  //   assertTrue(pair.balanceOf(sender) > 0, 'bal');
  //   assertTrue(IERC20(OPGOERLI.KISS).balanceOf(sender) > 0, 'bal2');
  // }

  // function testRebase() public forking {
  //   IKreskoAsset krBTC = IKreskoAsset(OPGOERLI.krBTC);
  //   IUniswapV2Pair krBTCPair = IUniswapV2Pair(
  //     OPGOERLI.UniswapV2Factory.getPair(OPGOERLI.krBTC, OPGOERLI.KISS)
  //   );

  //   uint256 tSupply = krBTC.totalSupply();
  //   uint256 lpBal = krBTCPair.balanceOf(OPGOERLI.krBTC);

  //   Rebase script = new Rebase();
  //   script.run();

  //   uint256 lpBalAfter = krBTCPair.balanceOf(OPGOERLI.krBTC);
  //   uint256 tSupplyAfter = krBTC.totalSupply();
  //   assertEq(tSupply * 5, tSupplyAfter, 'totalSupply');
  //   assertEq(lpBal * 5, lpBalAfter, 'lpBal');
  // }
}
