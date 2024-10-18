// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Donation {
    // State variables
    address public owner;
    uint256 public totalDonations;
    uint256 public platformFeePercent = 10; // Platform fee set to 10%
    
    // Event to log donations
    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);
    
    // Modifier to restrict access to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    
    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender; // Set the owner to the address that deploys the contract
    }
    
    // Function to donate
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than 0");

        // Calculate platform fee
        uint256 platformFee = (msg.value * platformFeePercent) / 100;
        uint256 donationAmount = msg.value - platformFee; // Donation amount exclusive of platform fee
        
        totalDonations += donationAmount; // Update total donations
        
        // Emit event for the donation
        emit DonationReceived(msg.sender, donationAmount);
        
        // Optionally send the platform fee to the owner's address
        payable(owner).transfer(platformFee);
    }
    
    // Function for the owner to withdraw funds
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        
        payable(owner).transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }

    // Function to get the contract's balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
