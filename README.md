# Solidity Hexagon test


You will find in this file the correction for the "fake NFT" done in class.

Make sure to read it and understand it well. 

## Solidity Written Exam

Add the follwing functionalities to this code:

1. In this code, there is one issue (there are actually a few other beyond the scope for this class), a single address can only own a single NFT. If a user purchase a new NFT then the previous one will be errased. The goal is to solve this issue (there are many approaches)

2. Create a function `Transfer(uint256 id, address recipient)` that allow the owner of an NFT to send it to someone else

3. (optinal) Allow the owner of an NFT, to put an NFT on sell. ie. A user can set a new price to one their NFTs and mark it as "on-sale". Any user can then purchase that NFT for the correct amount. The funds from the sell should lend in the previous owner wallet (We have not done this in class but refer to this: https://solidity-by-example.org/sending-ether/)



### Rating

You will be rated as follow:

#### Coding
See exercie above. You can submit your code using a Remix or using this repo

#### Oral
1. Answer questions regarding the general understanding of blockchain. example:

- How blockchain work
- Different type of blockchain
- Consensus algorithm
- How to interact with a blockchain
- How to use metamask
- Security rules for using a wallet
and more 

2. You will have to explain the code that you written above. So make sure you understand it properly


Good luck !






