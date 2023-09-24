-include .env


build:; forge build

deploy-georli:
	forge script /script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(GOERLI_RPC_URL) --private-key $(PRIVATE_KEY) --boradcast -vvv