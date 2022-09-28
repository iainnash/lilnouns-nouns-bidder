// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {NounsAuctionHouse, INounsToken} from "lilnouns-contracts/NounsAuctionHouse.sol";
import {NounsBidder, INounsAuctionFull} from "../src/NounsBidder.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";


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

contract MockERC20 is ERC20 {
    constructor() ERC20("TST", "TST", 18) {

    }
    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
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

    function testBidOutbidFails() public {
        // add outbid test case
        address owner = address(0x294294924929492492949249);
        address counterBidder = address(0x023);
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
        vm.stopPrank();
        vm.startPrank(counterBidder);
        vm.deal(counterBidder, 2 ether);
        uint256 nounId = INounsAuctionFull(address(instance)).auction().nounId;
        instance.createBid{value: 1.8 ether, gas: 300_000}(nounId);
        vm.stopPrank();
        vm.warp(block.timestamp + 100);
        vm.expectRevert(abi.encodeWithSelector(NounsBidder.DidNotWinAuction.selector, 0));
        bidder.finalizeAndWithdraw();
    }

    function testBidOverLimit() public {
        // test bid over limit fails
    }

    function testBidOutbidWin() public {
        // add outbid test case
        address owner = address(0x294294924929492492949249);
        address counterBidder = address(0x023);
        NounsBidder bidder = new NounsBidder(
            INounsAuctionFull(address(instance)),
            1 ether,
            owner
        );
        vm.deal(address(bidder), 10 ether);
        vm.prank(auctionOwner);
        instance.unpause();
        vm.warp(block.timestamp + 20);
        bidder.bid();
        vm.stopPrank();
        vm.startPrank(counterBidder);
        vm.deal(counterBidder, 2 ether);
        uint256 nounId = INounsAuctionFull(address(instance)).auction().nounId;
        instance.createBid{value: 1.8 ether, gas: 300_000}(nounId);
        vm.stopPrank();
        vm.warp(block.timestamp + 10);
        vm.expectRevert(NounsBidder.BidAmountTooHigh.selector);
        bidder.bid();
        vm.expectRevert("Auction hasn't completed");
        bidder.finalizeAndWithdraw();
    }

    function testWithdrawNFT() public {
        address owner = address(0x294294924929492492949249);
        NounsBidder bidder = new NounsBidder(
            INounsAuctionFull(address(instance)),
            1 ether,
            owner
        );
        MockNounsToken mockToken = new MockNounsToken();
        vm.prank(owner);
        mockToken.mint();
        vm.prank(owner);
        mockToken.transferFrom(owner, address(bidder), 0);
        bidder.withdrawNFT(address(mockToken), 0);
        vm.stopPrank();
    }

    function testWithdrawETH() public {
        address owner = address(0x294294924929492492949249);
        MockERC20 erc20 = new MockERC20();
        NounsBidder bidder = new NounsBidder(
            INounsAuctionFull(address(instance)),
            1 ether,
            owner
        );
        address payable dealer = payable(address(0x23));
        vm.deal(dealer, 20 ether);
        vm.prank(dealer);
        payable(address(bidder)).transfer(4 ether);
        vm.prank(owner);
        bidder.withdraw(4 ether);
        assertEq(owner.balance, 4 ether);
    }

    function testWithdrawERC20() public {
        address owner = address(0x294294924929492492949249);
        MockERC20 erc20 = new MockERC20();
        NounsBidder bidder = new NounsBidder(
            INounsAuctionFull(address(instance)),
            1 ether,
            owner
        );
        address tokenOwner = address(0x2323);
        vm.startPrank(tokenOwner);
        erc20.mint(2 ether);
        erc20.transfer(address(bidder), 2 ether);
        vm.stopPrank();

        bidder.withdrawERC20(address(erc20));
        assertEq(erc20.balanceOf(owner), 2 ether);
    }
}


