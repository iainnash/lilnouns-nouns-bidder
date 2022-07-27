// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Owned} from "solmate/auth/Owned.sol";
import {ERC721, ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {INounsAuctionFull} from "./interfaces/INounsAuctionFull.sol";


/// @notice Nouns Bidder Contract
contract NounsBidder is Owned, ERC721TokenReceiver {
    event FundsAdded(address indexed sender, uint256 amount);
    event FundsRemoved(address indexed recipient, uint256 amount);
    event FinalizedAndWithdrawAuction(uint256 nounId, address sender);
    event BidPlaced(
        address indexed sender,
        uint256 indexed nounId,
        uint256 bidAmount
    );

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

    /// @notice Admin setter for max auction bid amount
    /// @param _maxAuctionBidAmount maximum auction bid amount
    function setMaxAuctionBidAmount(uint256 _maxAuctionBidAmount)
        external
        onlyOwner
    {
        maxAuctionBidAmount = _maxAuctionBidAmount;
    }


    /// @notice Withdraw NFT from contract
    /// @param contractAddress NFT contract address to withdraw
    /// @param tokenId token ID to withdraw
    function withdrawNFT(address contractAddress, uint256 tokenId)
        public
        onlyOwner
    {
        ERC721(contractAddress).transferFrom(address(this), owner, tokenId);
    }

    /// @notice Withdraw ERC20 token (in case that auction refund comes as ERC20)
    /// @param contractAddress contract address for ERC20 token
    /// @param amount amount of the token to withdraw
    function withdrawERC20(address contractAddress, uint256 amount)
        external
        onlyOwner
    {
        ERC20(contractAddress).transferFrom(address(this), owner, amount);
    }

    /// @notice Withdraw funds in ETH from contract
    /// @param amount amount to withdraw
    function withdraw(uint256 amount) external onlyOwner {
        // Throws if amount > address(this).balance
        SafeTransferLib.safeTransferETH(owner, amount);
        emit FundsRemoved(owner, amount);
    }

    /// @notice Deposits eth and sends event to update balance.
    receive() external payable {
        emit FundsAdded(msg.sender, msg.value);
    }

    /// @notice Finalizes auction and withdraws nouns
    function finalizeAndWithdraw() external {
        uint256 nounId = nounsAuction.auction().nounId;
        nounsAuction.settleCurrentAndCreateNewAuction();
        withdrawNFT(address(nounsAuction.nouns()), nounId);
        emit FinalizedAndWithdrawAuction(nounId, msg.sender);
    }

    /// @notice Internal getter for next bid amount
    /// @return next bid amount
    function _getNextBidAmount() internal returns (uint256) {
        uint256 currentBid = nounsAuction.auction().amount;
        return
            currentBid + currentBid * nounsAuction.minBidIncrementPercentage();
    }

    /// @notice Places bid for Nouns token from treasury.
    /// @dev This can be called by anyone and will utilize contract storage.
    function bid() external {
        uint256 bidAmount = _getNextBidAmount();
        if (bidAmount > maxAuctionBidAmount) {
            revert BidAmountTooHigh();
        }
        uint256 nounId = nounsAuction.auction().nounId;
        nounsAuction.createBid{value: bidAmount, gas: 300_000}(nounId);
        emit BidPlaced(msg.sender, nounId, bidAmount);
    }

    /// @notice Receiver function for receiving NFTs
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external override pure returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }

}
