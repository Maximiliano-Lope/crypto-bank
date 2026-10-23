// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/MiToken.sol";
import "../src/CryptoBank.sol";

contract DeployScript is Script {
    function run() public {
        vm.startBroadcast();

        MiToken token = new MiToken(1000);
        CryptoBank bank = new CryptoBank();

        vm.stopBroadcast();
    }
}
