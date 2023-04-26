// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18;

import { Script } from 'forge-std/Script.sol';
import { Ghost } from '../contracts/Ghost.sol';
import { IERC20 } from 'kresko-helpers/vendor/IERC20.sol';
import { IUniswapV2Pair } from 'kresko-helpers/vendor/uniswapV2/IUniswap.sol';
import { OPGOERLI } from 'kresko-helpers/Deployments.sol';

contract Uniswap is Script {
  function addLiquidityETH(
    address account,
    address token,
    uint256 amountETH,
    uint256 amountToken
  ) public returns (IUniswapV2Pair pair) {
    require(token != address(0), '!token');
    require(amountETH > 0 && amountToken > 0, '!amount');

    if (IERC20(token).allowance(account, address(OPGOERLI.UniswapV2Router)) < amountToken) {
      IERC20(token).approve(address(OPGOERLI.UniswapV2Router), type(uint256).max);
    }

    OPGOERLI.UniswapV2Router.addLiquidityETH{ value: amountETH }(
      token,
      amountToken,
      amountToken,
      amountETH,
      account,
      block.timestamp + 100
    );

    return
      IUniswapV2Pair(
        OPGOERLI.UniswapV2Factory.getPair(address(OPGOERLI.UniswapV2Router.WETH()), token)
      );
  }
}
