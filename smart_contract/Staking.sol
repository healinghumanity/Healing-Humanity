// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is ReentrancyGuard, Ownable {
    IERC20 public stakingToken;
    uint256 public rewardRate; // Rewards per block
    uint256 public lockUpPeriod; // Lock-up period in seconds

    struct Stake {
        uint256 amount;
        uint256 timestamp;
        uint256 rewardDebt;
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);

    // Constructor with parameters
    constructor(
        IERC20 _stakingToken, 
        uint256 _rewardRate, 
        uint256 _lockUpPeriod
    )
        // Pass the address of the initial owner (this address can be set dynamically)
        Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4) 
    {
        stakingToken = _stakingToken;
        rewardRate = _rewardRate;
        lockUpPeriod = _lockUpPeriod;
    }

    modifier updateReward(address user) {
        // Update the user's reward debt before any action
        Stake storage userStake = stakes[user];
        if (userStake.amount > 0) {
            userStake.rewardDebt = earned(user);
        }
        _;
    }

    function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0");
        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;

        stakingToken.transferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function unstake() external nonReentrant updateReward(msg.sender) {
        Stake storage userStake = stakes[msg.sender];
        require(block.timestamp >= userStake.timestamp + lockUpPeriod, "Lock-up period not over");
        require(userStake.amount > 0, "No tokens staked");

        uint256 amount = userStake.amount;
        userStake.amount = 0;

        stakingToken.transfer(msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimReward() external nonReentrant updateReward(msg.sender) {
        uint256 reward = stakes[msg.sender].rewardDebt;
        require(reward > 0, "No rewards to claim");
        stakes[msg.sender].rewardDebt = 0;

        stakingToken.transfer(msg.sender, reward);
        emit RewardClaimed(msg.sender, reward);
    }

    function emergencyWithdraw() external nonReentrant {
        Stake storage userStake = stakes[msg.sender];
        uint256 amount = userStake.amount;
        require(amount > 0, "No tokens to withdraw");

        userStake.amount = 0;
        stakingToken.transfer(msg.sender, amount);
        emit EmergencyWithdraw(msg.sender, amount);
    }

    function earned(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        return (userStake.amount * rewardRate * (block.timestamp - userStake.timestamp)) / 1e18; // Reward calculation
    }

    // Owner functions
    function setRewardRate(uint256 newRate) external onlyOwner {
        rewardRate = newRate;
    }

    function setLockUpPeriod(uint256 newPeriod) external onlyOwner {
        lockUpPeriod = newPeriod;
    }

    // Add other functionalities as needed...
}
