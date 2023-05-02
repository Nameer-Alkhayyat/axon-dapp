import hre, { ethers } from "hardhat";
import fs from 'fs';


async function main() {
  const FactoryContract = await hre.ethers.getContractFactory("factoryContract");
  const factoryContract = await FactoryContract.deploy();
  await factoryContract.deployed();
  console.log("factoryContract deployed to:", factoryContract.address);

  fs.writeFileSync("./factroyContractAddress.tsx", `
  export const factoryContract = "${factoryContract.address}"

  `)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
