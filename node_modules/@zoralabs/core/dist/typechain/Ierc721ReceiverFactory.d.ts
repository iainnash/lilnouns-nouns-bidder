import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { Ierc721Receiver } from "./Ierc721Receiver";
export declare class Ierc721ReceiverFactory {
    static connect(address: string, signerOrProvider: Signer | Provider): Ierc721Receiver;
}
