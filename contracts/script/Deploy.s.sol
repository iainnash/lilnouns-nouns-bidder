// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NounsBidder.sol";

contract ContractScript is Script {
    INounsAuctionFull nounsAuction;
    address owner;

    function setUp() public {
        nounsAuction = INounsAuctionFull(vm.envAddress("NOUNS_AUCTION"));
        owner = vm.envAddress("BIDDER_OWNER");
    }

    function run() public {
        vm.startBroadcast();

        new NounsBidder({
            _nounsAuction: nounsAuction,
            _maxAuctionBidAmount: 20 ether,
            owner: owner
        });

        // nft.call{value: 0.2 ether}();

        vm.stopBroadcast();
    }
}
