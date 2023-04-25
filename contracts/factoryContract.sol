// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./sharesContact.sol";
import "./creditContract.sol";
import "./minterContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract factoryContract  is Ownable{
    struct ContractInfo {
        address sharesContract;
        address creditContract;
        address minterContract;
    }

    mapping(bytes32 => ContractInfo) public contracts;

    event InstanceDeployed(bytes32 contractId, string nftName, address sharesContractAddress, address creditContractAddress, address minterContractAddress);
    
    function createContracts (
        string memory _nftName,
        string memory _nftSymbol,
        uint256 _price,
        uint256 _cap,
        address _oracle,
        address _landOwnerAddress
    ) external onlyOwner returns (bytes32)  {
        bytes32 contractId = keccak256(abi.encodePacked(_nftName, _nftSymbol));
        require( contracts[contractId].sharesContract == address(0), "Contracts already deployed");

        // Deploy sharesContract contract
        sharesContract st = new sharesContract();
        contracts[contractId].sharesContract = address(st);


        // Deploy minterContract contract
        minterContract nmc =
            new minterContract(
                address(_landOwnerAddress),
                address(st),
                address(_oracle),
                _price,
                _nftName,
                _nftSymbol
            );
        contracts[contractId].minterContract = address(nmc);

        // Deploy creditContract contract
        CreditContract cc = new CreditContract(address(st), address(nmc), _cap);
        contracts[contractId].creditContract = address(cc);


        emit InstanceDeployed(contractId, _nftName, address(st), address(cc), address(nmc));
        return contractId;
    }
}
