
import { expect } from "chai";
import { Contract } from "ethers";
import { ethers, network } from "hardhat";



describe("sharesContract", function(){

    let minter: Contract
    let shares: Contract
    let credit: Contract
    let landOwner: { address: string; }
    let axon: { address: any; }
    let oracle
    let user1: { address: string; }
    let user2: { address: any; }
    let sharesAddress: { address: any; }
    let minterAdress: string

    const value = { value: ethers.utils.parseEther('2.0') }
    const one_ether = ethers.utils.parseEther('4.0')

    this.beforeAll(async function () {


        [axon, landOwner, oracle, user1, user2] = await ethers.getSigners()


        const Shares = await ethers.getContractFactory("sharesContract")
        shares = await Shares.deploy()
        await shares.deployed()

        

        const Minter = await ethers.getContractFactory("minterContract")
        minter = await Minter.deploy(landOwner.address,  shares.address, oracle.address, 100, "testNFT", "tnft")
        await minter.deployed()
        minterAdress = minter.address
 



        const Credit = await ethers.getContractFactory("CreditContract")
        credit = await Credit.deploy(shares.address, minter.address , 80000)
        await credit.deployed()










    })
    it("should mint a new NFT", async () => {
        
        await expect(minter.connect(await ethers.getSigner(landOwner.address)).mintToken("landURI", 5)).to.be.fulfilled;
        const balance = await minter.balanceOf(shares.address);
        expect(balance).to.eq(1);

      });
    it("should stake the NFT", async () => {
        const isStaked = await shares.isStaked(1);
        expect(isStaked).to.be.true;
      });

    it("should check setMinterNFT function", async () => {
        const minterAddress = await shares.minterAddress();

        expect(minterAddress).to.eq(minter.address)
      });

    it("should check setTotalSupply function", async () => {
        const _totalSupply = await shares._totalSupply();

        expect(_totalSupply).to.eq(50)
      });

    it("should buy new shares", async () => {
        await expect(shares.connect(await ethers.getSigner(user1.address)).buyShares(10, {value: 20})).to.be.fulfilled;
        const balance = await shares.balanceOf(user1.address);
        expect(balance).to.eq(10);
      });

    it("should not mint shares if value is too low", async () => {
        await expect(shares.connect(await ethers.getSigner(user2.address)).buyShares(10, {value: 3})).to.be.rejectedWith(Error);
        const balance = await shares.balanceOf(user2.address);
        expect(balance).to.eq(0);
      });

    it("should not mint shares if there are no more shares to mint", async () => {
        await expect(shares.connect(await ethers.getSigner(user2.address)).buyShares(4000, {value: 300})).to.be.rejectedWith(Error);

        const balance = await shares.balanceOf(user2.address);
        expect(balance).to.eq(0);
      });



      // Credit COntract

    it("Should update the current supply and mint tokens to the contract", async () => {
      await credit.updateCurrentSupply(1000);
      expect(await credit.currentSupply()).to.equal(1000);
      expect(await credit.balanceOf(credit.address)).to.equal(1000);
      });


    it("Should not allow updateCurrentSupply to be called twice within a year", async () => {

        await expect(credit.updateCurrentSupply(1000)).to.be.revertedWith("Function can only be called once per year");
      });

    it("Should burn credits and reduce the current supply", async () => {
        await credit.connect(await ethers.getSigner(user1.address)).burnCreditsPublic();
        expect(await credit.currentSupply()).to.equal(900);
 
      });


    it("Should not allow the same user to withdraw again.", async () => {
        const userBalance = await shares.balanceOf(user1.address)
        console.log(userBalance)
        await expect(credit.connect(await ethers.getSigner(user1.address)).burnCreditsPublic()).to.be.revertedWith("You have already claimed your rewards for this year!")
      });

    it("Should not allow users with insufficient shares to burn credits", async () => {
      const userBalance = await shares.balanceOf(user1.address)
       await expect(credit.connect(await ethers.getSigner(user2.address)).burnCreditsPublic()).to.be.revertedWith("You don't have enough shares");

      });
  



    



})