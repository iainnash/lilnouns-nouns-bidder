// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface INounsAuctionPartial {
  function createBid(uint256 nounId) external payable;
}

contract NounsBidder is Ownable {
  event FundsAdded(address sender, uint256 amount);

  INounsAuction public immutable nounsAuction;
  uint256 public maxAuctionBidAmount;

  constructor(INounsAuction _nounsAuction, uint256 maxAuctionBidAmount) {
    nounsAuction = _nounsAuction;
    maxAuctionBidAmount = _maxAuctionBidAmount;
  }

  receive() {
    emit FundsAdded(msg.sender, msg.value);
  }  

  function bid() external {
    uint256 nounsAuction.
    nounsAuction.bid()
  }
}
