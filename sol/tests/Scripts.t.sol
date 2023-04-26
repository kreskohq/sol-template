// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20, TestWallet, OPGOERLI } from './Util.t.sol';
import { IUniswapV2Pair, Liquidity } from '../scripts/Liquidity.s.sol';

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

  function testLiquidity() public forking {
    Liquidity liq = new Liquidity();
    IUniswapV2Pair pair = liq.run();

    address sender = getAddr(0);

    assertTrue(address(pair) != address(0), 'pair');
    assertTrue(pair.balanceOf(sender) > 0, 'bal');
    assertTrue(IERC20(OPGOERLI.KISS).balanceOf(sender) > 0, 'bal2');
  }
}
