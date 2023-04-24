import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter"
import "hardhat-contract-sizer"
import "@nomiclabs/hardhat-etherscan"

require('dotenv').config()

const config: HardhatUserConfig = {
  solidity:{
    version:"0.8.17",
    settings:{
      
      optimizer: {
        enabled: true,
        runs: 200,
      },
    }

  },
  defaultNetwork: "hardhat",
  gasReporter:{
    enabled:true

  },
  contractSizer: {
    outputFile:"./contractSize.txt"


  },
  networks: {
    hardhat:{


    },
    ganache:{
      url:"http://127.0.0.1:7545",
      accounts: [process.env.PRIVATE_KEY],


    },
    goerli:{
      url:process.env.goerli_url,
      accounts:[process.env.PRIVATE_KEY]
    },
    sepolia:{
      url:"https://eth-sepolia.g.alchemy.com/v2/l5za7P6ehUtAsR5PH7OcZkbml76iLKG4",
      accounts:[[process.env.PRIVATE_KEY]]
    }
},
  etherscan:{
    apiKey:{
      goerli: process.env.API_KEY

    }

  }
};

export default config;
