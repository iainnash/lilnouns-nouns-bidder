use ethers::prelude::*;
use eyre::Result;
use std::env;
use std::sync::Arc;
use tokio::time::{interval_at, Duration, Instant};

extern crate tokio;

// ## auction house repo
// 0x830bd73e4184cef73443c15111a1df14e495c706

abigen!(
    NOUNS_BUILDER_BIDDER,
    r#"[
      event AuctionBid(uint256 nounId, address sender, uint256 value, bool extended, uint256 endTime)
      function auction() returns (uint256 nounId, uint256 highestBid, address highestBidder, uint40 startTime, uint40 endTime, bool settled)
  ]"#,
);

async fn get_auction() -> NOUNS_BUILDER_BIDDER<Provider<Ws>> {
    let rpc_wss = env::var("RPC_WSS").unwrap();
    let client = Provider::<Ws>::connect(rpc_wss).await.unwrap();
    let client = Arc::new(client);
    let address = "0x6ca4126ed8a4cef9ed918f9992314946138ce052"
        .parse::<Address>()
        .unwrap();
    NOUNS_BUILDER_BIDDER::new(address, Arc::clone(&client))
}

async fn handle_events() -> Result<()> {
    let auction = get_auction().await;
    let events = auction.events();
    let mut stream = events.stream().await?;

    while let Some(Ok(event)) = stream.next().await {
        println!(
            "noun_id: {:?}, sender: {:?}, value: {:?}, extended: {:?}, endTime: {:?}",
            event.noun_id, event.sender, event.value, event.extended, event.end_time
        );

        if let Ok(result) = auction.auction().call().await {
            println!(
                "auction: {:?} {:?} {:?} {:?} {:?} {:?}",
                result.0, result.1, result.2, result.3, result.4, result.5
            );
        }
    }
    Ok(())
}

async fn bidder_handler() {
    let mut interval = interval_at(Instant::now(), Duration::from_millis(1000));
    loop {
        interval.tick().await;
        println!("Looping");
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let (_, b) = tokio::join!(bidder_handler(), handle_events());
    if let Err(err) = b {
        println!("{:?}", err);
    }

    Ok(())
}
