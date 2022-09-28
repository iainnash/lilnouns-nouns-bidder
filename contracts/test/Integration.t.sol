// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {NounsAuctionHouse, INounsToken} from "lilnouns-contracts/NounsAuctionHouse.sol";
import {NounsBidder, INounsAuctionFull} from "../src/NounsBidder.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";

contract MockNounsToken is ERC721 {
    event Minted();
    event Burned(uint256);
    uint256 atId;

    constructor() ERC721("MOCK TEST", "MOCK TEST") {

    }

    function mint() external returns (uint256) {
        emit Minted();
        _mint(msg.sender, atId++);
    }

    function burn(uint256 tokenId) external {
        _burn(tokenId);
        emit Burned(tokenId);
    }

    function tokenURI(uint256 id) public override view returns (string memory) {
      return "";
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
        vm.stopPrank();
    }

    function testPlaceFinalBidSuccessfully() public {
        address owner = address(0x294294924929492492949249);
        NounsBidder bidder = new NounsBidder(
            INounsAuctionFull(address(instance)),
            10 ether,
            owner
        );
        vm.deal(address(bidder), 10 ether);
        vm.prank(auctionOwner);
        instance.unpause();
        vm.warp(block.timestamp + 20);
        bidder.bid();
        vm.warp(block.timestamp + 100);
        bidder.finalizeAndWithdraw();
    }

    function testBidOutbid() {
        // add outbid test case
    }

    function testBidOverLimit() {
        // test bid over limit fails
    }

    function testWithdraw() {

    }
}


