const HDWalletProvider = require('truffle-hdwallet-provider');
organizer='   ';

module.exports = {
  networks: {
    ropsten: {
      provider: () => new HDWalletProvider(organizer, ''),
      network_id: 3,       
      gas: 1000000,       
      skipDryRun: true
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