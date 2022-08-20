import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IMedia } from "./IMedia";
export declare class IMediaFactory {
    static connect(address: string, signerOrProvider: Signer | Provider): IMedia;
}
