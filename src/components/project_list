import React, { useEffect, useState } from 'react';
import axios from 'axios';

const ProjectList = () => {
    const [projects, setProjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [filter, setFilter] = useState('all'); // State for filtering projects
    const [sortOrder, setSortOrder] = useState('asc'); // State for sorting projects

    useEffect(() => {
        const fetchProjects = async () => {
            try {
                setLoading(true);
                const response = await axios.get('/api/projects'); // Fetch projects from API
                setProjects(response.data);
            } catch (err) {
                setError('Failed to load projects.');
            } finally {
                setLoading(false);
            }
        };
        fetchProjects();
    }, []);

    // Function to handle filter change
    const handleFilterChange = (e) => {
        setFilter(e.target.value);
    };

    // Function to handle sort order change
    const handleSortChange = (e) => {
        setSortOrder(e.target.value);
    };

    // Filter and sort projects based on selected criteria
    const filteredProjects = projects.filter(project => 
        filter === 'all' || project.category === filter
    ).sort((a, b) => {
        if (sortOrder === 'asc') {
            return a.donationGoal - b.donationGoal;
        }
        return b.donationGoal - a.donationGoal;
    });

    if (loading) return <div>Loading projects...</div>;
    if (error) return <div>{error}</div>;

    return (
        <div>
            <h2>Projects</h2>
            <div>
                <label>Filter by category:</label>
                <select onChange={handleFilterChange}>
                    <option value="all">All</option>
                    <option value="education">Education</option>
                    <option value="health">Health</option>
                    <option value="environment">Environment</option>
                </select>
                
                <label>Sort by Donation Goal:</label>
                <select onChange={handleSortChange}>
                    <option value="asc">Ascending</option>
                    <option value="desc">Descending</option>
                </select>
            </div>
            <div className="project-list">
                {filteredProjects.map((project) => (
                    <div key={project.id} className="project-card">
                        <h3>{project.name}</h3>
                        <p>Goal: {project.donationGoal} {project.currency}</p>
                        <p>Current Donations: {project.currentDonations} {project.currency}</p>
                        <button onClick={() => handleDonate(project.id)}>Donate Now</button>
                    </div>
                ))}
            </div>
        </div>
    );
};

// Function to handle donation logic
const handleDonate = (projectId) => {
    // Logic for donation process
    console.log(`Donating to project ID: ${projectId}`);
};

/*
Next Steps:
1. **User Ratings and Feedback**: Implement functionality for users to leave ratings or feedback on projects to enhance community engagement.
2. **Responsive Design**: Ensure the design is mobile-friendly and visually appealing, aligning with branding.
3. **Styling**: Add CSS styles to improve the visual layout of project cards and filters.
4. **Pagination**: Consider adding pagination to manage large lists of projects effectively.
5. **Detailed Project View**: Create a separate page/component for detailed information about each project when clicked.
6. **Search Functionality**: Implement a search bar for users to quickly find specific projects by name or keywords.
*/

export default ProjectList;
