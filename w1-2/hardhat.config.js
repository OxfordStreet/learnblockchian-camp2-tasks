require("@nomicfoundation/hardhat-toolbox");
require("hardhat-abi-exporter");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    developemnt: {
      url: "https://127.0.0.1:8545",
      chainId: 31337
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      chainId: 80001,
      accounts: [`0x10ccce74f9893ff3bed704f116f73e6d75dcd02ac22259d68c9525d240d1eab0`]
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: '1WBEBRGY6RSS4NYX9INIK8E8E57PSSTQQY'
    }
  },
  abiExporter: {
    path: './deployments/abi',
    clear: true,
    flat: true,
    only: [],
    spacing: 2,
    pretty: true,
  }
};
