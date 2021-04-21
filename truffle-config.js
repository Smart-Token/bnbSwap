require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const privateKeys = fs.readFileSync(".secret").toString().trim().split("\n");
const BSCSCANAPIKEY = fs.readFileSync(".bscscanapikey").toString().trim()
//console.log(privateKeys);
module.exports = {
  networks: {

    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
    },
     testnet: {
      provider: () => new HDWalletProvider(privateKeys, `https://data-seed-prebsc-1-s1.binance.org:8545`, 0, 2),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true,
      networkCheckTimeout: 10000,
      gasPrice: 10000000000
    },
    bsc: {
      provider: () => new HDWalletProvider(prrivateKeys, `https://bsc-dataseed1.binance.org`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      version: "^0.8.3",
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: BSCSCANAPIKEY
  }
}
