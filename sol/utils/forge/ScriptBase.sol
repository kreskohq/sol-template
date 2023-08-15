pragma solidity ^0.8.0;

import { Deployments } from 'kresko-helpers/Deployments.sol';
import { Wallet } from './Wallet.sol';
import { Externals, IERC20, IWETH } from 'utils/Externals.sol';

abstract contract ScriptBase is Deployments, Externals, Wallet {
  constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

  uint256 internal constant MAX_256 = type(uint256).max;
}
