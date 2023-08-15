import { IPolygonZkEvmBridge, PolygonZkEvm, Arbitrum, Optimism, IArbitrumBridge, IOPBridge } from '../../contracts/interfaces/IBridges.sol';
import { IERC20 } from 'kresko-helpers/vendor/IERC20.sol';
import { IWETH } from 'kresko-helpers/vendor/IWETH.sol';

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
