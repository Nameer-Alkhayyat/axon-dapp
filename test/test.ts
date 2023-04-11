
import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";



let minter: Contract
let shares: Contract
let landOwner:any


describe("nftMinterContract", function(){
    const value = { value: ethers.utils.parseEther('1.0') }
    const one_ether = ethers.utils.parseEther('1.0')

    beforeEach(async function () {

        [landOwner] = await ethers.getSigners()



        const Shares = await ethers.getContractFactory("CarbonToken")
        shares = await Shares.deploy()
        await shares.deployed()


        const Minter = await ethers.getContractFactory("nftMinterContract")
        minter = await Minter.deploy(landOwner.address, shares.address)
        await minter.deployed()



    })

    it('Should create a string', async () => {
        await expect( minter.createString("string"))
          .to.emit(minter, 'stringCreated')
          .withArgs("string")
      })

    



})