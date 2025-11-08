import axios from 'axios';

// Create an Axios instance
const apiClient = axios.create({
    baseURL: 'https://floralwhite-butterfly-259901.hostingersite.com/api', // Live URL
    headers: {
        'Content-Type': 'application/json',
    },
});

apiClient.interceptors.request.use((config) => {
    const token = localStorage.getItem('access_token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export default apiClient;