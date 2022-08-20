import { useMemo } from 'react'
import NounsBidderAbi from "../abis/nouns-bidder-abi.json"
import { useContractRead } from 'wagmi'

export function useNounsBiderTreasury() {
    const { data } = useContractRead({
      addressOrName: "",
      contractInterface: NounsBidderAbi,
      functionName: "auctionInfo",
    });

    const decodedTokenURI = useMemo(() => {
      if (data) {
        try {
          const json = atob(data.substring(29))
          const result = JSON.parse(json)
          return result
        } catch (err) {
          console.error(err)
        }
      }
    }, [data])
  
    return {
      tokenData: decodedTokenURI,
    }
  }



  // Bid
  export function useNounsBiderBid() {
    const { data } = useContractRead({
      addressOrName: "",
      contractInterface: NounsBidderAbi,
      functionName: "bid",
    });

    return {
      data: data,
    }
  }

  // Max Bid Amount
  export function useNounsBiderMaxBidAmount() {
    const { data } = useContractRead({
      addressOrName: "",
      contractInterface: NounsBidderAbi,
      functionName: "maxAuctionBidAmount",
    });

    return {
      data: data,
    }
  }

  //Withdraw Eth
  export function useNounsBiderFinalizeAndWithdraw() {
    const { data } = useContractRead({
      addressOrName: "",
      contractInterface: NounsBidderAbi,
      functionName: "finalizeAndWithdraw",
    });

    return {
      data: data,
    }
  }