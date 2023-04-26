# To load the variables in the .env file
source .env

# To deploy and verify our contract
forge script sol/scripts/Liquidity.s.sol:Liquidity --fork-url $RPC_OPTIMISM_GOERLI_ALCHEMY -vvvv
