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
        bool onSale;
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
            price: newPrice,
            onSale: false
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

     // Function to transfer ownership of an NFT to another address
    function transfer(uint256 id, address recipient) public {
        // Ensure that the sender is the owner of the NFT
        require(msg.sender == NFTs[id].owner, "You are not the owner of this NFT");

        // Transfer ownership by updating the owner address
        NFTs[id].owner = recipient;

        // Update the NFTsByOwner mapping for both sender and recipient
        updateOwnership(msg.sender, id, recipient);
    }

    
    // New function to put an NFT on sale
    function putOnSale(uint256 id, uint256 salePrice) public {
       // require(msg.sender == NFTs[id].owner, "You are not the owner of this NFT");
        require(!NFTs[id].onSale, "NFT is already on sale");

        NFTs[id].price = salePrice;
        NFTs[id].onSale = true;
    }

    // New function to purchase an NFT that is on sale
    function purchaseOnSale(uint256 id) public payable {
        NFTData storage token = NFTs[id];
        require(token.onSale, "NFT is not on sale");
        require(token.price > 0, "This NFT does not exist");
        require(token.price <= msg.value, "Not enough funds sent");

        address previousOwner = token.owner;
        token.owner = msg.sender;
        token.onSale = false;

        // Transfer funds to the previous owner
        payable(previousOwner).transfer(msg.value);
        
        // Update NFT ownership mappings
        updateOwnership(previousOwner, id, msg.sender);
    }


    // Internal function to update the NFTsByOwner mapping
    function updateOwnership(address from, uint256 id, address to) internal {
        // Remove the NFT ID from the sender's list
        uint256[] storage fromNFTs = NFTsByOwner[from];
        for (uint256 i = 0; i < fromNFTs.length; i++) {
            if (fromNFTs[i] == id) {
                fromNFTs[i] = fromNFTs[fromNFTs.length - 1];
                fromNFTs.pop();
                break;
            }
        }

        // Add the NFT ID to the recipient's list
        NFTsByOwner[to].push(id);
    }

}
