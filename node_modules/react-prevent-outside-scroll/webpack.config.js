const path = require('path')
const pkg = require('./package')

module.exports = {
  entry: './src/index.jsx',
  output: {
    path: path.dirname(pkg.main),
    filename: path.basename(pkg.main),
    library: 'ReactPreventOutsideScroll',
    libraryTarget: 'umd',
  },
  externals: {
    react: {
      commonjs: 'react',
      commonjs2: 'react',
      amd: 'react',
      root: 'React',
    },
    'react-dom': {
      commonjs: 'react-dom',
      commonjs2: 'react-dom',
      amd: 'react-dom',
      root: 'ReactDOM',
    },
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          cacheDirectory: true,
          plugins: ['transform-class-properties'],
          presets: ['es2015', 'react', 'stage-2'],
        },
      }
    ],
  },
}
