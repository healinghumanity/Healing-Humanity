import React, { useState } from 'react';
import axios from 'axios'; // For currency conversion API and network requests

const DonationForm = () => {
  const [donationAmount, setDonationAmount] = useState('');
  const [currency, setCurrency] = useState('USD'); // Default to USD
  const [convertedAmount, setConvertedAmount] = useState('');
  const [progressStep, setProgressStep] = useState(1); // Step tracker
  const [loading, setLoading] = useState(false); // Loading state for network requests
  const [error, setError] = useState(null); // Error state for network issues

  const handleInputChange = (e) => {
    setDonationAmount(e.target.value);
  };

  const handleCurrencyChange = (e) => {
    setCurrency(e.target.value);
  };

  // Real-time validation for donation amount (e.g., must be positive number)
  const validateInput = () => {
    if (isNaN(donationAmount) || donationAmount <= 0) {
      setError('Please enter a valid donation amount.');
      return false;
    }
    setError(null);
    return true;
  };

  // Currency conversion using an external API
  const convertCurrency = async () => {
    setLoading(true);
    try {
      const response = await axios.get(
        `https://api.exchangerate-api.com/v4/latest/${currency}`
      );
      const rate = response.data.rates['CRYPTO']; // Assuming CRYPTO is the desired currency
      const converted = (donationAmount * rate).toFixed(2);
      setConvertedAmount(converted);
      setProgressStep(2); // Move to the next step
    } catch (err) {
      setError('Failed to fetch conversion rates. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validateInput()) return;

    // Step 1: Convert the currency before submitting the donation
    convertCurrency();
  };

  // Progress bar for donation process
  const renderProgressBar = () => {
    const progress = Math.min((progressStep / 3) * 100, 100); // Assuming 3 steps total
    return (
      <div className="progress-bar">
        <div className="progress" style={{ width: `${progress}%` }}></div>
      </div>
    );
  };

  return (
    <form onSubmit={handleSubmit}>
      {renderProgressBar()}

      <label>
        Donation Amount:
        <input
          type="number"
          value={donationAmount}
          onChange={handleInputChange}
        />
      </label>
      <label>
        Currency:
        <select value={currency} onChange={handleCurrencyChange}>
          <option value="USD">USD</option>
          <option value="EUR">EUR</option>
          <option value="INR">INR</option>
          <option value="CRYPTO">Crypto</option>
        </select>
      </label>

      {error && <p className="error">{error}</p>}
      {loading && <p>Loading...</p>}
      {convertedAmount && (
        <p>
          Converted Amount: {convertedAmount} in Crypto
        </p>
      )}

      <button type="submit">Donate</button>
    </form>
  );
};

export default DonationForm;
