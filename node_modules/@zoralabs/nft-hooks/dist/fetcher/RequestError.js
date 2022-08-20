"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RequestError = void 0;
/**
 * Class for general hook errors for displaying
 */
class RequestError extends Error {
    constructor(message, originalError) {
        super(message);
        this.name = 'RequestError';
        this.originalError = originalError;
    }
    getOriginalError() {
        return this.originalError;
    }
}
exports.RequestError = RequestError;
