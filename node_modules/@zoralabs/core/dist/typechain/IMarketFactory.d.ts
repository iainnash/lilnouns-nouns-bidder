import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IMarket } from "./IMarket";
export declare class IMarketFactory {
    static connect(address: string, signerOrProvider: Signer | Provider): IMarket;
}
