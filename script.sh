# To load the variables in the .env file
source .env

# To deploy and verify our contract
forge script sol/scripts/Liquidity.s.sol:Liquidity --rpc-url $RPC_OPTIMISM_GOERLI_ALCHEMY --with-gas-price 100 --broadcast -vvv
