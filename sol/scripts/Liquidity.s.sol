// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Wallet } from './Wallet.s.sol';
import { Uniswap, IUniswapV2Pair, OPGOERLI } from './Uniswap.s.sol';

contract Liquidity is Uniswap, Wallet('MNEMONIC_TESTNET') {
  function run() public broadcastWithMnemonic(0) returns (IUniswapV2Pair pair) {
    uint256 amountETH = 40 ether;
    address account = getAddr(0);
    return addLiquidityETH(account, OPGOERLI.krETH, amountETH, amountETH);
  }
}
