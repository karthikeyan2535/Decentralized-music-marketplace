# Decentralized-music-marketplace
This is a decentralized music marketplace smart contract built with solidity and compiled and deployed in Remix-IDE.
In this contract artists can upload their music and listeners can purchase or donate to support their favorite artists.
The goal of this project is to create a platform that promotes decentralized, direct transactions between artists and their audience, without intermediaries.It uses etherium transactions
 
- I have compiled,deployed and tested this project in Remix-IDE using etherium testnet and test ethers.
  
## Compiling the contract
1. To compile the contract you must copy the code to a new file named DecentralizedMusicMarketplace.sol in Remix-Ide.
2. On the left you will have the solidity compiler button.
3. Once you click on the compile button, you will have an option to choose the solidity sompiler version.
4. As the code has solidity version 0.8.17, only this version and above versions are compatible.Select a version.
5. If theres any error or bugs in the code, the compiler will throw an error at that position.
6. If the code is error free, Click on the compile button.

## Deploying the contract
1. Once the code is compiled, click on the Deploy and run transactions button just below it.
2. Under environment, you can select Injected provider Or else you can choose Remix VM which is an inbuilt deployment by Remix-IDE. 
  - Deploying using Injected Provider
    1. Ensure your metamask wallet is connected to Remix-IDE.
    2. Select a network(Mainnet or any other Testnet)
    3. Click on deploy button.
    4. Your metamask will pop up and ask for confirmation. Click on confirm.
    5. Your contract is deployed and you can see the transaction in the corresponding testnet.
  - Deploying using Remix VM(Virtual Machine)
    1. Select a Remix VM from environment.
    2. You can deploy the contract using fake or test eth provided by Remix VM.
    3. Click on the deploy button and the contract is deployed. 
3. Once deployed the contract will appear in the deployed section.
4. Then you can interact with the contract by changing accounts and registering as different user roles like artists and listeners(you can use different MetaMask accounts or the provided Remix VM accounts).


