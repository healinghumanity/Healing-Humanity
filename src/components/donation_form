import React, { useState } from 'react';
import axios from 'axios'; // For fetching crypto conversion rates and network requests

const DonationForm = () => {
  const [donationAmount, setDonationAmount] = useState('');
  const [currency, setCurrency] = useState('USD'); // Default fiat currency
  const [cryptoCurrency, setCryptoCurrency] = useState('BTC'); // Default crypto
  const [convertedAmount, setConvertedAmount] = useState(''); // Holds the crypto equivalent
  const [progressStep, setProgressStep] = useState(1); // Step tracker for the donation process
  const [loading, setLoading] = useState(false); // Loading state for conversion and API requests
  const [error, setError] = useState(null); // Error state for handling validation or API errors

  const handleInputChange = (e) => {
    setDonationAmount(e.target.value);
  };

  const handleCurrencyChange = (e) => {
    setCurrency(e.target.value);
  };

  const handleCryptoChange = (e) => {
    setCryptoCurrency(e.target.value);
  };

  // Real-time validation for donation amount (positive number check)
  const validateInput = () => {
    if (isNaN(donationAmount) || donationAmount <= 0) {
      setError('Please enter a valid donation amount.');
      return false;
    }
    setError(null);
    return true;
  };

  // Fetch the conversion rate from a crypto API and calculate the equivalent crypto amount
  const convertToCrypto = async () => {
    setLoading(true);
    try {
      // Fetch the conversion rate from a crypto price API
      const response = await axios.get(`https://api.coingecko.com/api/v3/simple/price?ids=${cryptoCurrency}&vs_currencies=${currency}`);
      const rate = response.data[cryptoCurrency.toLowerCase()][currency.toLowerCase()];
      const converted = (donationAmount / rate).toFixed(6); // Convert the amount into the chosen crypto
      setConvertedAmount(converted);
      setProgressStep(2); // Proceed to next step in progress bar
    } catch (err) {
      setError('Failed to fetch conversion rates. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validateInput()) return;

    // Proceed with conversion
    convertToCrypto();
  };

  // Progress bar to visually guide users through the donation process
  const renderProgressBar = () => {
    const progress = Math.min((progressStep / 3) * 100, 100); // Assumed 3 steps in total
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
        Donation Amount (in {currency}):
        <input
          type="number"
          value={donationAmount}
          onChange={handleInputChange}
        />
      </label>

      <label>
        Select Fiat Currency:
        <select value={currency} onChange={handleCurrencyChange}>
          <option value="USD">USD</option>
          <option value="EUR">EUR</option>
          <option value="INR">INR</option>
        </select>
      </label>

      <label>
        Select Cryptocurrency:
        <select value={cryptoCurrency} onChange={handleCryptoChange}>
          <option value="BTC">Bitcoin (BTC)</option>
          <option value="ETH">Ethereum (ETH)</option>
          <option value="USDT">Tether (USDT)</option>
        </select>
      </label>

      {error && <p className="error">{error}</p>}
      {loading && <p>Loading conversion rates...</p>}
      {convertedAmount && (
        <p>
          Your donation will be approximately {convertedAmount} {cryptoCurrency}.
        </p>
      )}

      <button type="submit">Donate</button>
    </form>
  );
};

export default DonationForm;
