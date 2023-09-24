//1. Deply mocks when we are on local anvil chain
// Keep track of diff contract address accross diff chains

//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are on anvil we deploy mocks
    // otherwise grab the existing addres from the live network
    NetworkConfig public activeNetworkConfig;
    uint8 public constant ETH_DECIMALS = 8;
    int256 public constant ETH_PRICE = 2000e8;


    struct NetworkConfig {
        address priceFeed; //EHT/USD price feed
    }

    constructor() {
        if(block.chainid == 5) {
            activeNetworkConfig = getGoerliEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getGoerliEthConfig() public pure returns(NetworkConfig memory){
        // price feed address
        NetworkConfig memory goerliConfig = NetworkConfig({priceFeed: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e});
        return goerliConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory){
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        //deply mocks
        //return mock address
        vm.startBroadcast();
        MockV3Aggregator mockPrice = new MockV3Aggregator(ETH_DECIMALS, ETH_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPrice)
        });

        return anvilConfig;
    }
}