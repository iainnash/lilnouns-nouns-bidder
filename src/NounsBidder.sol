// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Owned} from "solmate/auth/Owned.sol";

interface INounsAuctionPartial {
  function createBid(uint256 nounId) external payable;
  function auction() external returns (INounsAuctionHouse.Auction);
}

contract NounsBidder is Owned {
  event FundsAdded(address sender, uint256 amount);

  INounsAuction public immutable nounsAuction;
  uint256 public maxAuctionBidAmount;

  constructor(INounsAuction _nounsAuction, uint256 maxAuctionBidAmount, address owner) Owned(owner) {
    nounsAuction = _nounsAuction;
    maxAuctionBidAmount = _maxAuctionBidAmount;
  }

  receive() {
    emit FundsAdded(msg.sender, msg.value);
  }  

  function bid() external {
    nounsAuction.bid()
  }
}
