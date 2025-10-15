const { defineConfig } = require('@vue/cli-service')
const webpack = require('webpack');

module.exports = defineConfig({
  configureWebpack: {
    plugins: [
      new webpack.DefinePlugin({
        // Vue CLI is in maintenance mode, and probably won't merge my PR to fix this in their tooling
        // https://github.com/vuejs/vue-cli/pull/7443
        __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: 'false',
      })
    ],
  },
  transpileDependencies: true,

  // devServer: {
  //   host: 'miso-app.loc', 
  //   port: 8080,           
  //   https: false,          
  //   allowedHosts: [
  //     'miso-app.loc', 
  //     'localhost'    
  //   ],
  // },
});
