pragma solidity ^0.8.15;

import {INounsAuctionHouse} from "lilnouns-contracts/interfaces/INounsAuctionHouse.sol";

/// @dev This adds addtl read fns missing in the standard nouns auction house interface
interface INounsAuctionFull is INounsAuctionHouse {
  function auction() external view returns (INounsAuctionHouse.Auction memory);
  function nouns() external view returns (address);
  function minBidIncrementPercentage() external view returns (uint8);
  function reservePrice() external view returns (uint256);
  function paused() external view returns (bool);
}
