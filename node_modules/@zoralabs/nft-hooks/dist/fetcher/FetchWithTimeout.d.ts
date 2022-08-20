import AbortController from 'node-abort-controller';
/**
 * Simple Fetch wrapper that enables a timeout.
 * Allows for showing an error state for slow-to-load IPFS files
 */
export declare class FetchWithTimeout {
    controller: AbortController;
    expectedContentType?: string;
    timeoutDuration: number;
    constructor(timeoutDuration?: number, contentType?: string | undefined);
    fetch(url: string, options?: any): Promise<Response>;
}
