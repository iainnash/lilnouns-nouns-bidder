pragma solidity ^0.8.15;

import {INounsAuctionHouse} from "lilnouns-contracts/interfaces/INounsAuctionHouse.sol";

/// @dev This adds addtl read fns missing in the standard nouns auction house interface
interface INounsAuctionFull is INounsAuctionHouse {
  function auction() external returns (INounsAuctionHouse.Auction memory);
  function nouns() external returns (address);
  function minBidIncrementPercentage() external returns (uint8);
  function paused() external returns (bool);
}
