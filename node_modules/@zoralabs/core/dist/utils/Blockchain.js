"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Blockchain = void 0;
class Blockchain {
    constructor(provider) {
        this._provider = provider;
    }
    async saveSnapshotAsync() {
        const response = await this.sendJSONRpcRequestAsync('evm_snapshot', []);
        this._snapshotId = Number(response);
    }
    async revertAsync() {
        await this.sendJSONRpcRequestAsync('evm_revert', [this._snapshotId]);
    }
    async resetAsync() {
        await this.sendJSONRpcRequestAsync('evm_revert', ['0x1']);
    }
    async increaseTimeAsync(duration) {
        await this.sendJSONRpcRequestAsync('evm_increaseTime', [duration]);
    }
    async waitBlocksAsync(count) {
        for (let i = 0; i < count; i++) {
            await this.sendJSONRpcRequestAsync('evm_mine', []);
        }
    }
    async sendJSONRpcRequestAsync(method, params) {
        return this._provider.send(method, params);
    }
}
exports.Blockchain = Blockchain;
//# sourceMappingURL=Blockchain.js.map