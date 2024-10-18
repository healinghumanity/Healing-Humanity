// RewardsSystem.js
import React, { useEffect, useState } from 'react';
import { getUserRewards, getReferralData, redeemReward } from './utils/rewards_service';
import { Button, Notification } from 'reactstrap';

const RewardsSystem = () => {
    const [userRewards, setUserRewards] = useState([]);
    const [referralData, setReferralData] = useState([]);
    const [notification, setNotification] = useState('');

    useEffect(() => {
        fetchUserRewards();
        fetchReferralData();
    }, []);

    const fetchUserRewards = async () => {
        const rewards = await getUserRewards();
        setUserRewards(rewards);
    };

    const fetchReferralData = async () => {
        const data = await getReferralData();
        setReferralData(data);
    };

    const handleRedeem = async (rewardId) => {
        const result = await redeemReward(rewardId);
        if (result.success) {
            setNotification('Reward redeemed successfully!');
            fetchUserRewards(); // Refresh user rewards after redemption
        } else {
            setNotification('Failed to redeem reward. Please try again.');
        }
    };

    return (
        <div className="rewards-system">
            <h1>Your Rewards</h1>

            {notification && <Notification>{notification}</Notification>}

            <h2>Reward Tiers</h2>
            <ul>
                <li>Bronze Donor: $1–$100</li>
                <li>Silver Donor: $101–$500</li>
                <li>Gold Donor: $501+</li>
            </ul>

            <h2>Your Current Tier</h2>
            <p>{userRewards.currentTier}</p>

            <h2>Your Rewards</h2>
            <ul>
                {userRewards.list.map((reward, index) => (
                    <li key={index}>
                        {reward.name} - Expires on: {new Date(reward.expiryDate).toLocaleDateString()}
                        <Button onClick={() => handleRedeem(reward.id)}>Redeem</Button>
                    </li>
                ))}
            </ul>

            <h2>Referral Program</h2>
            <p>Invite your friends and earn rewards!</p>
            <ul>
                {referralData.map((referral, index) => (
                    <li key={index}>
                        {referral.email} - Earned: {referral.earnedRewards}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default RewardsSystem;
