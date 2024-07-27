# SEUWING Degen Token (ERC-20): Unlocking the Future of Gaming

This Solidity program introduces the DegenToken contract, an ERC20 token implementation on the Avalanche blockchain. Designed for Degen Gaming, it rewards players and enhances player loyalty and retention by allowing them to earn and redeem tokens for in-game items.

## Description

The DegenToken contract includes the following features:
- Minting Tokens: The contract owner can mint new Degen (DGN) tokens to any address using the mint function.
- Burning Tokens: Users can burn their tokens using the burnTokens function.
- Transferring Tokens: Players can transfer their tokens to others using the transferTokens function.
- Redeeming Tokens: Players can redeem their tokens for items in the in-game store using the redeemTokens function.
- Checking Token Balance: Players can check their token balance using the getBalance and getBalanceOf functions.
- Pausing the Contract: The contract owner can pause and unpause the contract.

## Getting Started

### Installing

To get started with this project, you will need a Solidity development environment. We recommend using Remix, an online Solidity IDE. Follow these steps to install and prepare your environment:

1. Go to Remix: Visit the Remix IDE at Remix.
2. Create a New File: Click on the "+" icon in the left-hand sidebar to create a new file. Save the file with a .sol extension (e.g., DegenToken.sol).
3. Copy and Paste the Template Code: Copy the code provided below and paste it into your new file.

### Executing program

To run this program, follow these steps:

1. Copy the following code into your file:
```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable, Pausable, ReentrancyGuard {
    event ItemRedeemed(address indexed user, uint256 itemId, uint256 cost);

    struct StoreItem {
        uint256 itemId;
        string itemName;
        uint256 cost;
    }

    StoreItem[] public storeItems;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _transferOwnership(msg.sender);
        _initializeStoreItems();
    }

    function mint(address to, uint256 amount) public onlyOwner whenNotPaused {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function transferTokens(address receiver, uint256 value) external whenNotPaused nonReentrant {
        require(balanceOf(msg.sender) >= value, "Insufficient Degen Tokens to complete the transfer.");
        approve(msg.sender, value);
        transferFrom(msg.sender, receiver, value);
    }

    function burnTokens(uint256 value) external whenNotPaused nonReentrant {
        require(balanceOf(msg.sender) >= value, "Not enough Degen Tokens to burn.");
        _burn(msg.sender, value);
    }

    function redeemTokens(uint256 itemId) external whenNotPaused nonReentrant {
        uint256 cost;
        string memory itemName;
        
        (cost, itemName) = _getItemDetails(itemId);

        require(balanceOf(msg.sender) >= cost, "Insufficient tokens to redeem the item.");
        _burn(msg.sender, cost);

        emit ItemRedeemed(msg.sender, itemId, cost);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function getBalanceOf(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    function showStoreItems() external pure returns (string memory) {
        return "Available Store Items:\n\
                1. Digital Artwork: 150 Tokens\n\
                2. Custom T-shirt: 100 Tokens\n\
                3. Exclusive Access Pass: 75 Tokens\n\
                4. Collectible Sticker: 50 Tokens\n\
                5. VIP Membership: 200 Tokens";
    }

    function _initializeStoreItems() internal {
        storeItems.push(StoreItem(1, "Digital Artwork", 150));
        storeItems.push(StoreItem(2, "Custom T-shirt", 100));
        storeItems.push(StoreItem(3, "Exclusive Access Pass", 75));
        storeItems.push(StoreItem(4, "Collectible Sticker", 50));
        storeItems.push(StoreItem(5, "VIP Membership", 200));
    }

    function _getItemDetails(uint256 itemId) internal view returns (uint256, string memory) {
        for (uint i = 0; i < storeItems.length; i++) {
            if (storeItems[i].itemId == itemId) {
                return (storeItems[i].cost, storeItems[i].itemName);
            }
        }
        revert("Invalid item ID.");
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
```

2. Compile the Code: Click on the "Solidity Compiler" tab in the left-hand sidebar. Ensure the "Compiler" option is set to a compatible version (e.g., 0.8.20), and then click on the "Compile DegenToken.sol" button.

3. Deploy the Contract: Click on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "DegenToken" contract from the dropdown menu, and then click on the "Deploy" button.

4. Interact with the Contract: Once deployed, interact with the contract using the provided interface in Remix. Here are the main functions you can interact with:
- mint: Mint new DGN tokens to a specified address. Only the contract owner can execute this function.
- burnTokens: Burn DGN tokens from the caller's balance.
- transferTokens: Transfer DGN tokens to another address.
- redeemTokens: Redeem DGN tokens for in-game store items by specifying the item ID.
- getBalance: Get the balance of DGN tokens for the caller.
- getBalanceOf: Get the balance of DGN tokens for any specified address.
- showStoreItems: Display a list of available store items and their costs.
- pause: Pause all token transfers and minting. Only the contract owner can execute this function.
- unpause: Unpause the contract, allowing token transfers and minting to resume. Only the contract owner can execute this function.

## Authors

VincyDaniel 
[VincyDaniel](https://www.linkedin.com/in/vince-daniel-del-rosario-815a11205/)

## License

This project is licensed under the VincyDaniel License - see the LICENSE.md file for details
