// Dashboard.js
import React, { useEffect, useState } from 'react';
import { Bar, Line } from 'react-chartjs-2';
import { getDonationData, getLeaderboardData, getBadges } from './utils/dashboard_service';
import jsPDF from 'jspdf';
import { Button } from 'reactstrap';

const Dashboard = () => {
    const [donationData, setDonationData] = useState({});
    const [leaderboard, setLeaderboard] = useState([]);
    const [badges, setBadges] = useState([]);

    useEffect(() => {
        fetchDonationData();
        fetchLeaderboard();
        fetchBadges();
    }, []);

    const fetchDonationData = async () => {
        const data = await getDonationData();
        setDonationData(data);
    };

    const fetchLeaderboard = async () => {
        const data = await getLeaderboardData();
        setLeaderboard(data);
    };

    const fetchBadges = async () => {
        const data = await getBadges();
        setBadges(data);
    };

    const downloadReceipt = (donationId) => {
        const doc = new jsPDF();
        doc.text(`Donation Receipt ID: ${donationId}`, 10, 10);
        doc.save(`receipt_${donationId}.pdf`);
    };

    return (
        <div className="dashboard">
            <h1>Donation Dashboard</h1>

            <h2>Donation Impact</h2>
            <Bar data={donationData} />
            <Line data={donationData} />

            <h2>Leaderboard</h2>
            <ul>
                {leaderboard.map((donor, index) => (
                    <li key={index}>{donor.name}: ${donor.totalDonations}</li>
                ))}
            </ul>

            <h2>Your Badges</h2>
            <div className="badges">
                {badges.map((badge, index) => (
                    <img key={index} src={badge.icon} alt={badge.name} />
                ))}
            </div>

            <h2>Download Receipts</h2>
            <Button onClick={() => downloadReceipt('12345')}>Download Receipt for Donation #12345</Button>

            <h2>Feedback</h2>
            <form>
                <textarea placeholder="Leave your feedback here..." />
                <Button type="submit">Submit Feedback</Button>
            </form>
        </div>
    );
};

export default Dashboard;
