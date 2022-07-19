// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;



contract NounsBidder is Ownable {
  event FundsAdded(address sender, uint256 amount);

  address public immutable nounsAuctionAddress;
  uint256 public maxAuctionBidAmount;

  constructor(address _nounsAuctionAddress, uint256 maxAuctionBidAmount) {
    nounsAuctionAddress = _nounsAuctionAddress;
    maxAuctionBidAmount = _maxAuctionBidAmount;
  }

  receive() {
    emit FundsAdded(msg.sender, msg.value);
  }  

  function bid() external {

  }
}
