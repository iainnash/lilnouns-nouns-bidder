// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Owned} from "solmate/auth/Owned.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {INounsAuctionFull} from "./interfaces/INounsAuctionFull.sol";


contract NounsBidder is Owned {
    event FundsAdded(address indexed sender, uint256 amount);
    event FundsRemoved(address indexed recipient, uint256 amount);
    event BidPlaced(address indexed sender, uint256 indexed nounId, uint256 bidAmount);

    error BidAmountTooHigh();


    INounsAuctionFull public immutable nounsAuction;
    uint256 public maxAuctionBidAmount;

    constructor(
        INounsAuctionFull _nounsAuction,
        uint256 _maxAuctionBidAmount,
        address owner
    ) Owned(owner) {
        nounsAuction = _nounsAuction;
        maxAuctionBidAmount = _maxAuctionBidAmount;
    }

    function setMaxAuctionBidAmount(uint256 _maxAuctionBidAmount) external onlyOwner {
      maxAuctionBidAmount = _maxAuctionBidAmount;
    }

    // TODO: Only receive from owner?
    receive() payable external {
        emit FundsAdded(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyOwner {
      // Throws if amount > address(this).balance
      SafeTransferLib.safeTransferETH(owner, amount);
      emit FundsRemoved(owner, amount);
    }

    function _getNextBidAmount() internal returns (uint256) {
        uint256 currentBid = nounsAuction.auction().amount;
        return
            currentBid + currentBid * nounsAuction.minBidIncrementPercentage();
    }

    function bid() external {
        uint256 bidAmount = _getNextBidAmount();
        if (bidAmount > maxAuctionBidAmount) {
            revert BidAmountTooHigh();
        }
        uint256 nounId = nounsAuction.auction().nounId;
        nounsAuction.createBid{value: bidAmount, gas: 300_000}(
            nounId
        );
        emit BidPlaced(msg.sender, nounId, bidAmount);
    }
}
