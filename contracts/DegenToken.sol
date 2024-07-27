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
