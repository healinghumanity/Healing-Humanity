// FAQ.js

import React, { useState, useEffect } from 'react';

// Mock function to fetch FAQs
const fetchFAQs = async () => {
    // Replace with actual API call
    return [
        {
            id: 1,
            category: 'Donations',
            question: 'How can I donate?',
            answer: 'You can donate by selecting a project and completing the donation form.',
        },
        {
            id: 2,
            category: 'Security',
            question: 'Is my data secure?',
            answer: 'Yes, we implement industry-standard security measures to protect your data.',
        },
        // More FAQs...
    ];
};

const FAQ = () => {
    const [faqs, setFaqs] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [filteredFaqs, setFilteredFaqs] = useState([]);
    const [expandedCategories, setExpandedCategories] = useState({});

    useEffect(() => {
        const loadFAQs = async () => {
            const faqs = await fetchFAQs();
            setFaqs(faqs);
        };
        loadFAQs();
    }, []);

    useEffect(() => {
        if (searchTerm) {
            setFilteredFaqs(
                faqs.filter(faq =>
                    faq.question.toLowerCase().includes(searchTerm.toLowerCase())
                )
            );
        } else {
            setFilteredFaqs(faqs);
        }
    }, [searchTerm, faqs]);

    const toggleCategory = (category) => {
        setExpandedCategories(prev => ({
            ...prev,
            [category]: !prev[category],
        }));
    };

    const categories = [...new Set(faqs.map(faq => faq.category))];

    return (
        <div className="faq-container">
            <h1>Frequently Asked Questions</h1>

            {/* Search Bar */}
            <input
                type="text"
                placeholder="Search FAQs..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="faq-search"
            />

            {/* FAQ Categories */}
            {categories.map(category => (
                <div key={category}>
                    <h2 onClick={() => toggleCategory(category)} className="faq-category">
                        {category}
                    </h2>
                    {expandedCategories[category] && (
                        <ul>
                            {filteredFaqs
                                .filter(faq => faq.category === category)
                                .map(faq => (
                                    <li key={faq.id}>
                                        <strong>{faq.question}</strong>
                                        <p>{faq.answer}</p>
                                        {/* Example of embedded tutorial video */}
                                        <iframe
                                            width="560"
                                            height="315"
                                            src="https://www.youtube.com/embed/example"
                                            title="Tutorial"
                                            frameBorder="0"
                                            allowFullScreen
                                        ></iframe>
                                    </li>
                                ))}
                        </ul>
                    )}
                </div>
            ))}
        </div>
    );
};

export default FAQ;
