import { ConnectButton } from "@rainbow-me/rainbowkit";
import React from 'react';
import { useContractRead } from 'wagmi'
import NounsBidderAbi from '../abis/nouns-bidder-abi.json'

export function User() {
  const {data} = useContractRead({
    addressOrName: '',
    contractInterface: NounsBidderAbi,
    functionName: ''
  })
  return <><ConnectButton /></>;
}