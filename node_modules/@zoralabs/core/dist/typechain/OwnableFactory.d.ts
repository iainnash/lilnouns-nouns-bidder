import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { Ownable } from "./Ownable";
export declare class OwnableFactory {
    static connect(address: string, signerOrProvider: Signer | Provider): Ownable;
}
