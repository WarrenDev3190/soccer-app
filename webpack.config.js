const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');
const config = require('config');


module.exports = {
  entry: [
    'webpack-dev-server/client?http://localhost:' + config.get('devServer.port') ,
    path.resolve(__dirname, './src/index.js')
  ],
  output: {
    filename: '[name]-[hash].js',
    path: path.resolve(__dirname, './dist'),
    publicPath: ''
  },
  plugins: [
    new webpack.DefinePlugin({
      "FOOTBALL_API_KEY": JSON.stringify(config.get("footballData.apiKey"))
    }),
    new webpack.HotModuleReplacementPlugin(),
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, './index.html'),
      inject: {
        body: true
      }
    })
  ],
  module: {
    rules: [
      {
        test: /\.elm$/,
        use: ['elm-webpack-loader']
      }
    ]
  },
  devServer: {
    port: config.get('devServer.port')
  }
}
