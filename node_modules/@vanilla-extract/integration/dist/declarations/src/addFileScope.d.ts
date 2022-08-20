interface AddFileScopeParams {
    source: string;
    filePath: string;
    rootPath: string;
    packageName: string;
}
export declare function addFileScope({ source, filePath, rootPath, packageName, }: AddFileScopeParams): string;
export {};
