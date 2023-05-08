import { ethers, Contract, Bytes} from "ethers";
import fs from 'fs';
require('dotenv').config()



const API_KEY = process.env.API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const API_URL = process.env.goerli_url
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS
const contract = require("../artifacts/contracts/factoryContract.sol/factoryContract.json");


const nftName = "TestNFT";
const nftSymbol = "TNFT";
const price = ethers.utils.parseEther("0.01");
const cap = ethers.utils.parseEther("1000");
const oracle = "0xDD4377094C6C696C2DA1De95def83a5432636D9f"; // Replace with oracle address
const landOwnerAddress = "0x952812337710365489314BdE12Db4764e4770560"; // Replace with land owner address



async function delployContractsInstances() {




    const alchemyProvider = new ethers.providers.AlchemyProvider("goerli", API_KEY);
    const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
    const factory = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);  



  
    const createContractsTx = await factory.createContracts(nftName, nftSymbol, price, cap, oracle, landOwnerAddress);    
    const receipt = await createContractsTx.wait();
  
    const event = receipt.events.find((event: { event: string; }) => event.event =="InstanceDeployed")
  
    const projectId = event.args.contractId;
    console.log("Contracts created with ID:", projectId);
  
    const contracts = await factory.contracts(projectId);
    console.log("sharesContract address:", contracts.sharesContract);
    console.log("CreditContract address:", contracts.creditContract);
    console.log("minterContract address:", contracts.minterContract);
    fs.writeFileSync('./contracts-addresses.tsx', `
    export const projectId = "${projectId}"
    export const sharesContract = "${ contracts.sharesContract}"
    export const CreditContract = "${ contracts.creditContract}"
    export const minterContract = "${contracts.minterContract}"
    `)
  }

  delployContractsInstances()