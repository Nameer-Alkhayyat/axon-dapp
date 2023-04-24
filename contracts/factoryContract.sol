// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./sharesContact.sol";
import "./creditContract.sol";
import "./minterContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract factoryContract  is Ownable{
    struct ContractInfo {
        address sharesToken;
        address creditContract;
        address nftMinterContract;
    }

    mapping(bytes32 => ContractInfo) public contracts;

    event InstanceDeployed(bytes32 contractId, string nftName, address sharesTokenAddress, address creditContractAddress, address nftMinterContractAddress);
    
    function createContracts (
        string memory _nftName,
        string memory _nftSymbol,
        uint256 _price,
        uint256 _cap,
        address _oracle,
        address _landOwnerAddress
    ) external onlyOwner returns (bytes32)  {
        bytes32 contractId = keccak256(abi.encodePacked(_nftName, _nftSymbol));
        require( contracts[contractId].sharesToken == address(0), "Contracts already deployed");

        // Deploy sharesToken contract
        sharesToken st = new sharesToken();
        contracts[contractId].sharesToken = address(st);


        // Deploy nftMinterContract contract
        nftMinterContract nmc =
            new nftMinterContract(
                address(_landOwnerAddress),
                address(st),
                address(_oracle),
                _price,
                _nftName,
                _nftSymbol
            );
        contracts[contractId].nftMinterContract = address(nmc);

        // Deploy creditContract contract
        CreditContract cc = new CreditContract(address(st), address(nmc), _cap);
        contracts[contractId].creditContract = address(cc);


        emit InstanceDeployed(contractId, _nftName, address(st), address(cc), address(nmc));
        return contractId;
    }
}
