import { ethers } from 'ethers';
export declare const privateKeys: string[];
export declare function generatedWallets(provider: ethers.providers.BaseProvider): ethers.Wallet[];
export declare function signMessage(message: string, wallet: ethers.Wallet): Promise<Uint8Array>;
