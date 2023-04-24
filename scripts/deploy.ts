import hre, { ethers } from "hardhat";
import fs from 'fs';
import { Contract } from "ethers";


let landOwner: { address: string; }
let axon: { address: any; }
let oracle

async function main() {
  const FactoryContract = await hre.ethers.getContractFactory("factoryContract");
  const factoryContract = await FactoryContract.deploy();
  await factoryContract.deployed();
  console.log("factoryContract deployed to:", factoryContract.address);


  // await delployContractsInstances(factoryContract)


}



// async function delployContractsInstances(factory:Contract) {

//   const [axon, landOwner, oracle] = await ethers.getSigners()

//   const createContractsTx = await factory.connect(await ethers.getSigner(axon.address)).createContracts("test", "tstf", 2, 100, oracle.address, landOwner.address)
//   const receipt = await createContractsTx.wait();

//   const event = receipt.events.find((event: { event: string; }) => event.event =="InstanceDeployed")

//   const contractId = event.args.contractId;
//   console.log("Contracts created with ID:", contractId);

//   const contracts = await factory.contracts(contractId);
//   console.log("SharesToken address:", contracts.sharesToken);
//   console.log("CreditContract address:", contracts.creditContract);
//   console.log("NFTMinterContract address:", contracts.nftMinterContract);
//   fs.writeFileSync('./contracts-addres.tsx', `
//   export const factoryContract = "${factory.address}"
//   export const SharesToken = "${ contracts.sharesToken}"
//   export const CreditContract = "${ contracts.creditContract}"
//   export const NFTMinterContract = "${contracts.nftMinterContract}"
//   `)
// }



main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
