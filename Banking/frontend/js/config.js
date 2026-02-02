// API Configuration
// This file centralizes the API endpoint configuration
// For production, the API URL will be set based on the environment

// Get API URL from environment or use default
// In production on Render, this will be the backend service URL
const API_BASE_URL = window.API_BASE_URL || 
                     (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1' 
                       ? 'http://localhost:3000' 
                       : ''); // Empty string means relative URLs (same origin)

// Export API base URL
window.API_BASE_URL = API_BASE_URL;

// Helper function to build API URLs
function getApiUrl(endpoint) {
  // Remove leading slash if present to avoid double slashes
  const cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
  
  if (API_BASE_URL) {
    return `${API_BASE_URL}/${cleanEndpoint}`;
  }
  // Use relative URL if API_BASE_URL is empty (same origin)
  return `/${cleanEndpoint}`;
}

