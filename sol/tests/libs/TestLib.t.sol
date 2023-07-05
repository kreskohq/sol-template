// SPDX-License-Identifier: MIT
pragma solidity <=0.8.20;

import { IERC20 } from 'kresko-helpers/vendor/IERC20.sol';
import { OPGOERLI, IUniswapV2Pair, Deployments } from 'kresko-helpers/Deployments.sol';
import { UniswapV2Library } from 'kresko-helpers/vendor/uniswapV2/UniswapV2Library.sol';
import { UniswapV2LiquidityMathLibrary } from 'kresko-helpers/vendor/uniswapV2/UniswapV2LiquidityMathLibrary.sol';
import { WadRay } from 'kresko-helpers/libs/WadRay.sol';

library TestLib {
  struct AssetParams {
    IERC20 asset;
    uint256 assetAmount;
  }

  struct Users {
    address user0;
    address user1;
    address user2;
  }
  using WadRay for uint256;
  using TestLib for TestLib.AssetParams;

  function exitKreskoAsset(address user, address asset) internal {
    // 1. repay debt
    uint256 debtAsset = OPGOERLI.Kresko.kreskoAssetDebtPrincipal(user, asset);
    if (debtAsset > 0) {
      uint256 index = OPGOERLI.Kresko.getMintedKreskoAssetsIndex(user, asset);
      OPGOERLI.Kresko.burnKreskoAsset(user, asset, debtAsset, index);
    }

    // 2. try withdraw asset deposits
    uint256 depositsAsset = OPGOERLI.Kresko.collateralDeposits(user, asset);
    if (depositsAsset > 0) {
      uint256 index = OPGOERLI.Kresko.getDepositedCollateralAssetIndex(user, asset);
      OPGOERLI.Kresko.withdrawCollateral(user, asset, depositsAsset, index);
    }
  }

  function assetPriceAMM(
    AssetParams storage self,
    address pairToken
  ) internal view returns (uint256) {
    IUniswapV2Pair pair = IUniswapV2Pair(
      OPGOERLI.UniswapV2Factory.getPair(address(self.asset), pairToken)
    );
    (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
    if (address(self.asset) == pair.token1()) {
      return UniswapV2Library.quote(1 ether, reserve1, reserve0);
    }
    return UniswapV2Library.quote(1 ether, reserve0, reserve1);
  }

  function assetPriceOracle(AssetParams storage self) internal view returns (uint256) {
    return OPGOERLI.Kresko.getKrAssetValue(address(self.asset), 1 ether, true);
  }

  function getKrAssetDebtValue(
    AssetParams storage self,
    address user
  ) internal view returns (uint256) {
    uint256 priceAsset = OPGOERLI.Kresko.getKrAssetValue(address(self.asset), 1 ether, true);
    return priceAsset.wadMul(self.asset.balanceOf(user));
  }

  function removeAllLiquidity(AssetParams storage self, address user, address pairToken) internal {
    IUniswapV2Pair pair = IUniswapV2Pair(
      OPGOERLI.UniswapV2Factory.getPair(address(self.asset), pairToken)
    );
    OPGOERLI.UniswapV2Router.removeLiquidity(
      address(self.asset),
      pairToken,
      pair.balanceOf(user),
      0,
      0,
      user,
      block.timestamp
    );
  }

  function sortTokens(
    AssetParams storage self,
    address pairToken
  ) internal view returns (address, address) {
    return UniswapV2Library.sortTokens(address(self.asset), pairToken);
  }

  function quoteA(
    AssetParams storage self,
    address pairToken,
    address quoteToken,
    uint256 amount
  ) internal view returns (uint256) {
    IUniswapV2Pair pair = IUniswapV2Pair(
      OPGOERLI.UniswapV2Factory.getPair(address(self.asset), pairToken)
    );
    (uint256 reserveA, uint256 reserveB, ) = pair.getReserves();
    (address tokenA, ) = self.sortTokens(pairToken);
    return
      quoteToken != tokenA
        ? UniswapV2Library.quote(amount, reserveA, reserveB)
        : UniswapV2Library.quote(amount, reserveB, reserveA);
  }

  function quoteB(
    AssetParams storage self,
    address pairToken,
    address quoteToken,
    uint256 amount
  ) internal view returns (uint256) {
    IUniswapV2Pair pair = IUniswapV2Pair(
      OPGOERLI.UniswapV2Factory.getPair(address(self.asset), pairToken)
    );
    (uint256 reserveA, uint256 reserveB, ) = pair.getReserves();
    (address tokenA, ) = self.sortTokens(pairToken);
    return
      quoteToken == tokenA
        ? UniswapV2Library.quote(amount, reserveA, reserveB)
        : UniswapV2Library.quote(amount, reserveB, reserveA);
  }

  function getLPValue(
    AssetParams storage self,
    address user,
    address pairToken
  ) internal view returns (uint256 amountAsset, uint256 amountOther) {
    IUniswapV2Pair pair = IUniswapV2Pair(
      OPGOERLI.UniswapV2Factory.getPair(address(self.asset), pairToken)
    );
    (address tokenA, address tokenB) = sortTokens(self, pairToken);

    (uint256 amountA, uint256 amountB) = UniswapV2LiquidityMathLibrary.getLiquidityValue(
      address(OPGOERLI.UniswapV2Factory),
      tokenA,
      tokenB,
      pair.balanceOf(user)
    );

    (amountAsset, amountOther) = tokenA == address(self.asset)
      ? (amountA, amountB)
      : (amountB, amountA);
  }

  function addLiquidityPCT(
    AssetParams storage self,
    address user,
    address pairToken,
    uint256 pct
  ) internal {
    (address tokenA, address tokenB) = sortTokens(self, pairToken);
    uint256 amountAsset = (self.asset.balanceOf(user) * pct) / 100;
    uint256 amountOther = self.quoteB(tokenA, tokenA, amountAsset);
    bool isAssetA = tokenA == address(self.asset);
    OPGOERLI.UniswapV2Router.addLiquidity(
      tokenA,
      tokenB,
      isAssetA ? amountAsset : amountOther,
      isAssetA ? amountOther : amountAsset,
      0,
      0,
      user,
      block.timestamp
    );
  }
}
