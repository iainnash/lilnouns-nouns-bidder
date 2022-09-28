// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {NounsAuctionHouse} from "lilnouns-contracts/NounsAuctionHouse.sol";

contract MockNounsToken {
    event Minted();
    event Burned(uint256);

    function mint() external returns (uint256) {
        emit Minted();
    }

    function burn(uint256 tokenId) external {
        emit Burned(tokenId);
    }
}

contract Integration is Test {
    NounsAuctionHouse instance;
    MockNounsToken mockNounsToken = new MockNounsToken();
    address auctionOwner = address(0x32);

    function setUp() public {
        instance = new NounsAuctionHouse();
        vm.startPrank(auctionOwner);
        instance.initialize(
            INounsToken(address(mockNounsToken)),
            address(0x0),
            // time buffer
            10,
            0.1 ether,
            10,
            100
        );
        vm.endPrank();
    }

    function testPlaceFinalBid() public {
        address owner = address(0x03365);
        bidder = new NounsBidder(instance, 10 ether, owner);
        vm.grant(bidder, 10 ether);
        vm.prank(auctionOwner);
        instance.unpause();
        vm.warp(block.timestamp + 20);
        bidder.bid(0.1 ether);
        vm.wrap(block.timestamp + 100);
        bidder.finalizeAndWithdraw();
    }
}
