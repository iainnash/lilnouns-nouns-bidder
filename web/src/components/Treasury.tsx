import React from "react";
import { useContractRead } from "wagmi";
import NounsBidderAbi from "../abis/nouns-bidder-abi.json";

export function Treasury() {
  const { data } = useContractRead({
    addressOrName: "",
    contractInterface: NounsBidderAbi,
    functionName: "auctionInfo",
  });
  return <>{JSON.stringify(data)}</>;
}
