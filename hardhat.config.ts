import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "ganache",
  networks: {
    ganache:{
      url:"http://127.0.0.1:7545",
      accounts: ["ab546bab82afe3e81d89db7a5b5981bda8558683e7b7d0fae2a191cdfc3b0c64"]

    },
    goerli:{
      url:"https://eth-goerli.g.alchemy.com/v2/R66oFy_NdfMhLFYi1zN62n8FqA8SlHf1",
      accounts:["69b15d7aa34c94353162a876a3a1c0c47319db3bb89ae4034d902a448ec7fc4e"]
    }
}
};

export default config;
