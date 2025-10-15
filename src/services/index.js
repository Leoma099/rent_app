import axios from 'axios';

// Create an Axios instance
const apiClient = axios.create({
    baseURL: 'http://api.rent-app.loc/api', // Replace with your Laravel API URL
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