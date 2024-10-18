// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FundManagement is Ownable, ReentrancyGuard {
    IERC20 public fundToken;

    uint256 public totalValueLocked; // Total amount of tokens held in the fund
    uint256 public totalFeesCollected; // Total fees collected by the contract
    uint256 public minimumDeposit; // Minimum deposit amount
    uint256 public withdrawalFee; // Percentage fee for withdrawals
    uint256 public interestRate; // Interest rate per block (in basis points)
    uint256 public interestAccumulated; // Total interest accumulated for users

    struct User {
        uint256 balance;
        uint256 lastDepositTime;
        uint256 totalInterestEarned;
    }

    mapping(address => User) public users;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event FeesCollected(uint256 amount);
    event EmergencyWithdrawal(address indexed user, uint256 amount);

    // Constructor
    constructor(
        IERC20 _fundToken,
        uint256 _minimumDeposit,
        uint256 _withdrawalFee,
        uint256 _interestRate,
        address initialOwner
    ) Ownable(initialOwner) {
        fundToken = _fundToken;
        minimumDeposit = _minimumDeposit;
        withdrawalFee = _withdrawalFee;
        interestRate = _interestRate;
    }

    // Deposit funds
    function deposit(uint256 amount) external nonReentrant {
        require(amount >= minimumDeposit, "Deposit amount below minimum");
        
        fundToken.transferFrom(msg.sender, address(this), amount);
        users[msg.sender].balance += amount;
        users[msg.sender].lastDepositTime = block.timestamp;
        totalValueLocked += amount;

        emit Deposited(msg.sender, amount);
    }

    // Withdraw funds without any fee deduction
    function withdraw(uint256 amount) external nonReentrant {
        User storage user = users[msg.sender];
        require(user.balance >= amount, "Insufficient balance");

        user.balance -= amount; // Deduct the withdrawn amount from the user's balance
        totalValueLocked -= amount; // Update total value locked in the fund
        fundToken.transfer(msg.sender, amount); // Transfer the amount to the user

        emit Withdrawn(msg.sender, amount);
    }

    // Calculate interest
    function calculateInterest(address userAddress) public view returns (uint256) {
        User memory user = users[userAddress];
        uint256 timeElapsed = block.timestamp - user.lastDepositTime;
        return (user.balance * interestRate * timeElapsed) / (1e18 * 1 days); // Interest earned based on time elapsed
    }

    // Claim interest
    function claimInterest() external nonReentrant {
        uint256 interest = calculateInterest(msg.sender);
        require(interest > 0, "No interest to claim");

        users[msg.sender].totalInterestEarned += interest;
        interestAccumulated += interest;
        fundToken.transfer(msg.sender, interest);
    }

    // Emergency withdrawal
    function emergencyWithdraw() external nonReentrant {
        User storage user = users[msg.sender];
        uint256 amount = user.balance;
        require(amount > 0, "No tokens to withdraw");

        user.balance = 0; // Reset balance
        totalValueLocked -= amount;
        fundToken.transfer(msg.sender, amount);

        emit EmergencyWithdrawal(msg.sender, amount);
    }

    // Owner functions to adjust parameters
    function setMinimumDeposit(uint256 newMinimum) external onlyOwner {
        minimumDeposit = newMinimum;
    }

    function setWithdrawalFee(uint256 newFee) external onlyOwner {
        withdrawalFee = newFee;
    }

    function setInterestRate(uint256 newRate) external onlyOwner {
        interestRate = newRate;
    }

    // Emergency stop mechanism
    bool public emergencyMode;

    modifier notInEmergency() {
        require(!emergencyMode, "Emergency mode is active");
        _;
    }

    function toggleEmergencyMode() external onlyOwner {
        emergencyMode = !emergencyMode;
    }
}
