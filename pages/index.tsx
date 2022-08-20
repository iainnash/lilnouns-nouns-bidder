import { Stack } from '@zoralabs/zord'
import { PageHeader, PageWrapper, Seo } from 'components'
import { CollectionRanking } from 'compositions/CollectionRanking'
import { DaoTable } from 'compositions/Daos'

import React, { useEffect, useState } from 'react'
import Router from 'next/router'
import { useActiveNounishAuction, useNounishAuctionProvider } from '@noun-auction'
import { returnDao } from 'constants/collection-addresses'
import { daos } from 'constants/collection-addresses'

/* @ts-ignore */
const Home = () => {
  // const dao = returnDao("0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03")
  const dao = daos[0]
  const { data: activeAuction } = useActiveNounishAuction(dao.marketType)
  const [loaded, setLoaded] = useState(false)


  useEffect(() => {
    if (!activeAuction) return;
    //TODO: add wait timer for router push

    const { pathname } = Router
    // conditional redirect
    if (pathname == '/') {
      // with router.push the page may be added to history
      // the browser on history back will  go back to this page and then forward again to the redirected page
      // you can prevent this behaviour using location.replace
      Router.push(`/collections/0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03/${activeAuction?.properties?.tokenId}`)
      //location.replace("/hello-nextjs")
    } else {
      //...wait
      // setLoaded(true)
    }
  }, [])

  if (!loaded) {
    // return <div></div> //show nothing or a loader
    return (
      <PageWrapper direction="column" gap="x6">
        {/* <Seo /> */}
        <PageHeader headline="Noun Bidoooor" />
        {/* <Stack px="x4">
        <DaoTable />
        <CollectionRanking />
      </Stack> */}
      </PageWrapper>
    )
  }
}

export default Home
