import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { Ierc721Enumerable } from "./Ierc721Enumerable";
export declare class Ierc721EnumerableFactory {
    static connect(address: string, signerOrProvider: Signer | Provider): Ierc721Enumerable;
}
