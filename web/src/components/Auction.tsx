import React from "react";
import { ZDK } from "@zoralabs/zdk";
import useSWR from "swr";

import {
  MarketSortKey,
  MarketsQuery,
  MarketStatus,
  MarketType,
  SortDirection,
} from "@zoralabs/zdk/dist/queries/queries-sdk";

const zdk = new ZDK();

const fetchLatestNounAuction = () =>
  zdk.markets({
    includeFullDetails: false,
    where: {},
    sort: {
      sortDirection: SortDirection.Asc,
      sortKey: MarketSortKey.Created,
    },
    filter: {
      marketFilters: [
        {
          marketType: MarketType.NounsAuction,
          statuses: [MarketStatus.Active],
        },
      ],
    },
  });

const Market = ({ ...data }: any) => 
  <div>
    Current Bid:
    Time until auction end:
    <button>Place bid from DAO</button>
    {JSON.stringify(data)}
  </div>
;

export function Auction() {
  const { data, error } = useSWR("markets", {
    fetcher: fetchLatestNounAuction,
  });
  return (
    <>
      {data && data?.markets?.nodes && (
        <Market market={data.markets.nodes[0]} />
      )}
    </>
  );
}
