import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { Erc721Burnable } from "./Erc721Burnable";
export declare class Erc721BurnableFactory {
    static connect(address: string, signerOrProvider: Signer | Provider): Erc721Burnable;
}
