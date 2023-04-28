# Axon protocol
> This project is the source code of axon protocol which contains:
- Smart contract logic
- Frontend layout and logic

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Software Modelling and Design Patterns](#software-modelling-and-design-patterns)
- [Deployment](#deployment)
    - [Locally](#1.locally)
    - [Custome Netwrok](#2.custome-network)
- [Verify](#verify)
- [Testing](#testing)



## Prerequisites

-node:16.x0

-hardhat: ^2.12

-Solidity v0.8.4 


## Installation

### Clone Repo
```bash
# Clone the repository
git clone https://github.com/yourusername/your-dapp.git

# For smart contracts development, in the root folder:
npm install

# For frontend development:
cd frontend
npm install
```
## Software Modelling and Design Patterns

Please find all the relevant information about Software Modelling and Design Patterns in this [Drive File](https://drive.google.com/file/d/1Rsu-sjnc8A4TrsDYZGQ9UoHtas3sgVs2/view?usp=sharing)


## Deployment

#### 1.Locally : 

---
**NOTE**

The follwing command will depoly the Factory Contract on Hardhat local node.

---
```bash  
npx hardhat run scripts/deploy.ts
 ```

 #### 2.Custome Network :
---
**NOTE**

The follwing command will depoly the Factory Contract on a remote network of your chioce. Make sure to provide netwrok_url and account secerts to env-var before trying to deploy on custome or remote networ network

---

 ```bash
  npx hardhat run scripts/deploy.ts --network NETWORKNAME 
  ```
To create an instance of minterContract, sharesContract and creditContract from the factoryContract, run the following:

 ```bash
  npx hardhat run scripts/createContracts.ts

  # The above command will create a text file where are the new created contract addresses and projectId will be saved.
  ```


## Verify

Verify contract automatically using etherscan

``` bash 
npx hardhat --network NETWORKNAME verify CONTRACTADDRESS
```


## Test

1. ``` npx hardhat test ```

2. Check test coverage ``` npx hardhat coverage ```
