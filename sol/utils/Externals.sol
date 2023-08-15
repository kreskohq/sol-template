pragma solidity ^0.8.0;

import { IERC20 } from 'kresko-helpers/vendor/IERC20.sol';
import { IWETH } from 'kresko-helpers/vendor/IWETH.sol';
import { IPolygonZkEvmBridge, PolygonZkEvm, Arbitrum, Optimism, IArbitrumBridge, IOPBridge } from 'contracts/interfaces/IBridges.sol';

abstract contract Externals {
  function mainnet_ext() internal pure returns (ExternalContracts memory) {
    return
      ExternalContracts({
        ETHW: IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2),
        NATIVEW: IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2),
        USDC: IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
        USDCE: IERC20(address(0)),
        GLP: IERC20(address(0)),
        USDT: IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7),
        DAI: IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F),
        zkEvmBridge: IPolygonZkEvmBridge(PolygonZkEvm.BRIDGE_MAINNET),
        opBridge: IOPBridge(Optimism.BRIDGE_MAINNET),
        arbBridge: IArbitrumBridge(Arbitrum.BRIDGE_MAINNET),
        arbBridgeNova: IArbitrumBridge(Arbitrum.BRIDGE_MAINNET_NOVA)
      });
  }

  function polygon_ext() internal pure returns (ExternalContracts memory) {
    return
      ExternalContracts({
        NATIVEW: IWETH(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270),
        ETHW: IWETH(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619),
        USDC: IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174),
        USDCE: IERC20(address(0)),
        GLP: IERC20(address(0)),
        USDT: IERC20(0xc2132D05D31c914a87C6611C10748AEb04B58e8F),
        DAI: IERC20(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063),
        zkEvmBridge: IPolygonZkEvmBridge(address(0)),
        opBridge: IOPBridge(address(0)),
        arbBridge: IArbitrumBridge(address(0)),
        arbBridgeNova: IArbitrumBridge(address(0))
      });
  }

  function bsc_ext() internal pure returns (ExternalContracts memory) {
    return
      ExternalContracts({
        NATIVEW: IWETH(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c),
        ETHW: IWETH(0x2170Ed0880ac9A755fd29B2688956BD959F933F8),
        USDC: IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d),
        USDCE: IERC20(address(0)),
        GLP: IERC20(address(0)),
        USDT: IERC20(0x55d398326f99059fF775485246999027B3197955),
        DAI: IERC20(0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3),
        zkEvmBridge: IPolygonZkEvmBridge(address(0)),
        opBridge: IOPBridge(address(0)),
        arbBridge: IArbitrumBridge(address(0)),
        arbBridgeNova: IArbitrumBridge(address(0))
      });
  }

  function optimism_ext() internal pure returns (ExternalContracts memory) {
    return
      ExternalContracts({
        NATIVEW: IWETH(0x4200000000000000000000000000000000000006),
        ETHW: IWETH(0x4200000000000000000000000000000000000006),
        USDCE: IERC20(address(0)),
        GLP: IERC20(address(0)),
        USDC: IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607),
        USDT: IERC20(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58),
        DAI: IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1),
        zkEvmBridge: IPolygonZkEvmBridge(address(0)),
        opBridge: IOPBridge(address(0)),
        arbBridge: IArbitrumBridge(address(0)),
        arbBridgeNova: IArbitrumBridge(address(0))
      });
  }

  function arbitrum_ext() internal pure returns (ExternalContracts memory) {
    return
      ExternalContracts({
        NATIVEW: IWETH(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1),
        ETHW: IWETH(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1),
        GLP: IERC20(0x1aDDD80E6039594eE970E5872D247bf0414C8903),
        USDC: IERC20(0xaf88d065e77c8cC2239327C5EDb3A432268e5831),
        USDCE: IERC20(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8),
        USDT: IERC20(0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9),
        DAI: IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1),
        zkEvmBridge: IPolygonZkEvmBridge(address(0)),
        opBridge: IOPBridge(address(0)),
        arbBridge: IArbitrumBridge(address(0)),
        arbBridgeNova: IArbitrumBridge(address(0))
      });
  }

  function goerli_ext() internal pure returns (ExternalContracts memory) {
    return
      ExternalContracts({
        ETHW: IWETH(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6),
        NATIVEW: IWETH(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6),
        USDCE: IERC20(address(0)),
        GLP: IERC20(address(0)),
        USDC: IERC20(0x07865c6E87B9F70255377e024ace6630C1Eaa37F),
        USDT: IERC20(0xe802376580c10fE23F027e1E19Ed9D54d4C9311e),
        DAI: IERC20(0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844),
        zkEvmBridge: IPolygonZkEvmBridge(PolygonZkEvm.BRIDGE_GOERLI),
        opBridge: IOPBridge(Optimism.BRIDGE_GOERLI),
        arbBridge: IArbitrumBridge(Arbitrum.BRIDGE_GOERLI),
        arbBridgeNova: IArbitrumBridge(address(0))
      });
  }
}

using Bridges for ExternalContracts global;

struct ExternalContracts {
  IWETH NATIVEW;
  IWETH ETHW;
  IERC20 USDC;
  IERC20 USDCE;
  IERC20 GLP;
  IERC20 USDT;
  IERC20 DAI;
  IPolygonZkEvmBridge zkEvmBridge;
  IArbitrumBridge arbBridge;
  IArbitrumBridge arbBridgeNova;
  IOPBridge opBridge;
}

library Bridges {
  function depositOptimism(ExternalContracts memory self, address to, uint256 value) internal {
    require(address(self.opBridge) != address(0), 'op-bridge-addr-0');
    require(to != address(0), 'op-bridge-to-0');
    require(value > 0, 'op-bridge-amount-0');
    self.opBridge.depositETHTo{ value: value }(to, 200000, '');
  }

  function depositArbitrum(ExternalContracts memory self, uint256 value) internal {
    require(address(self.arbBridge) != address(0), 'arb-bridge-addr-0');
    require(value > 0, 'arb-bridge-amount-0');
    self.arbBridge.depositEth{ value: value }();
  }

  function depositZkEvm(ExternalContracts memory self, address to, uint256 value) internal {
    require(address(self.zkEvmBridge) != address(0), 'zkevm-bridge-addr-0');
    require(to != address(0), 'zkevm-bridge-to-0');
    require(value > 0, 'zkevm-bridge-amount-0');
    self.zkEvmBridge.bridgeAsset{ value: value }(
      PolygonZkEvm.ZKEVM_ID,
      to,
      value,
      address(0),
      true,
      ''
    );
  }

  function multibridge(ExternalContracts memory self, uint256 value) internal {
    self.depositOptimism(msg.sender, value);
    self.depositArbitrum(value);
    self.depositZkEvm(msg.sender, value);
  }
}
