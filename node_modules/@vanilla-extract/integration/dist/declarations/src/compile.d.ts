import { Plugin, BuildOptions as EsbuildOptions } from 'esbuild';
export declare const vanillaExtractFilescopePlugin: () => Plugin;
export interface CompileOptions {
    filePath: string;
    cwd?: string;
    esbuildOptions?: Pick<EsbuildOptions, 'plugins' | 'external' | 'define' | 'loader'>;
}
export declare function compile({ filePath, cwd, esbuildOptions, }: CompileOptions): Promise<{
    source: string;
    watchFiles: string[];
}>;
