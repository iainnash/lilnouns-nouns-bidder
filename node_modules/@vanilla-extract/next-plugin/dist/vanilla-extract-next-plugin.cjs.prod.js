'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var webpackPlugin = require('@vanilla-extract/webpack-plugin');
var browserslist = require('browserslist');
var css = require('next/dist/build/webpack/config/blocks/css');
var loaders = require('next/dist/build/webpack/config/blocks/css/loaders');

function _interopDefault (e) { return e && e.__esModule ? e : { 'default': e }; }

var browserslist__default = /*#__PURE__*/_interopDefault(browserslist);

function getSupportedBrowsers(dir, isDevelopment) {
  let browsers;

  try {
    browsers = browserslist__default["default"].loadConfig({
      path: dir,
      env: isDevelopment ? 'development' : 'production'
    });
  } catch {}

  return browsers;
}

const createVanillaExtractPlugin = (pluginOptions = {}) => (nextConfig = {}) => Object.assign({}, nextConfig, {
  webpack(config, options) {
    const {
      dir,
      dev,
      isServer
    } = options;
    const cssRules = config.module.rules.find(rule => Array.isArray(rule.oneOf) && rule.oneOf.some(({
      test
    }) => typeof test === 'object' && typeof test.test === 'function' && test.test('filename.css'))).oneOf;
    cssRules.unshift({
      test: /\.vanilla\.css$/i,
      sideEffects: true,
      use: loaders.getGlobalCssLoader({
        assetPrefix: config.assetPrefix,
        isClient: !isServer,
        isServer,
        isDevelopment: dev,
        future: nextConfig.future || {},
        experimental: nextConfig.experimental || {}
      }, () => css.lazyPostCSS(dir, getSupportedBrowsers(dir, dev)), [])
    });
    config.plugins.push(new webpackPlugin.VanillaExtractPlugin(pluginOptions));

    if (typeof nextConfig.webpack === 'function') {
      return nextConfig.webpack(config, options);
    }

    return config;
  }

});

exports.createVanillaExtractPlugin = createVanillaExtractPlugin;
