// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Wallet } from './Wallet.s.sol';
import { Uniswap, IUniswapV2Pair, OPGOERLI } from './Uniswap.s.sol';
import { IKreskoAsset } from 'kresko-helpers/interfaces/IKreskoAsset.sol';

contract Liquidity is Uniswap, Wallet('MNEMONIC_TESTNET') {
  function run() public broadcastWithMnemonic(0) returns (IUniswapV2Pair pair) {
    uint256 amountETH = 40 ether;
    address account = getAddr(0);
    return addLiquidityETH(account, OPGOERLI.krETH, amountETH, amountETH);
  }
}

contract Rebase is Wallet('MNEMONIC_TESTNET') {
  function run() public broadcastWithMnemonic(0) {
    IKreskoAsset krBTC = IKreskoAsset(OPGOERLI.krBTC);
    IUniswapV2Pair krBTCPair = IUniswapV2Pair(
      OPGOERLI.UniswapV2Factory.getPair(OPGOERLI.krBTC, OPGOERLI.KISS)
    );
    address[] memory pools = new address[](1);
    pools[0] = address(krBTCPair);
    krBTC.rebase(100 ether, false, pools);
  }
}
