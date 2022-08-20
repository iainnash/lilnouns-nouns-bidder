/**
 * Class for general hook errors for displaying
 */
export declare class RequestError extends Error {
    private originalError?;
    constructor(message: string, originalError?: Error);
    getOriginalError(): Error | undefined;
}
