// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// This is a non standard NFT like contract
contract NFT {

    // This struct define the shape of the data that we want
    // to store for each NFT
    struct NFTData {
        string text;
        address owner;
        uint256 id;
        uint256 price;
    }

    // This is a list of NFTData
    NFTData[] public NFTs;

    // Mapping to store the NFT for a given owner.
    mapping(address => uint256[]) public NFTsByOwner; //To support an erray of addresses

    // Here we store the admin address 
    address admin;

    constructor () {
        // Here we store the address of the deployer account
        // so that we can refer to it to check if someone is admin
        admin = msg.sender;
    }
    
    // This function will create new NFT for sale
    function mint(string memory newText, uint256 newPrice) public {
        require(msg.sender == admin, "Only admin can mint");

        // Create an NFTData and push it in the list of NFTs
        NFTs.push(NFTData({
            text: newText,
            // We set address 0 (NULL address) as owner for now
            owner: address(0),
            // We set the id of the NFT
            id: NFTs.length,
            price: newPrice
        }));
    }
        

    // Here the user can purchase an NFT
    // This function is payable so that user can send funds to this function
    function buyNFTById( uint256 id) public payable {
        NFTData storage token = NFTs[id];

        // If the price is not set, it likely mean that this NFT doesn't exist
        require(token.price > 0, "This NFT does not exist");

        // Check that the price match
        require(token.price <= msg.value, "Not enough funds sent");

        // If all check passed, now we can update the NFT owner
        token.owner = msg.sender;
        NFTsByOwner[msg.sender].push(id); 
    }

}
