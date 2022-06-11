const HDWalletProvider = require('truffle-hdwallet-provider');
beneficiary='';
module.exports = {
  networks: {
    ropsten: {
      provider: () => new HDWalletProvider(beneficiary, ''),
      network_id: 3,       
      gas: 5000000,       
      skipDryRun: false
    },
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    }
  },

  compilers: {
    solc: {
       version: "0.5.8"
    }
  }
};