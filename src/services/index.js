import axios from 'axios';

console.log('VUE_APP_API_URL:', process.env.VUE_APP_API_URL);

const apiClient = axios.create({
        baseURL: process.env.VUE_APP_API_URL + '/api',
        withCredentials: true,
});

console.log('Axios baseURL:', apiClient.defaults.baseURL);

apiClient.interceptors.request.use((config) => {
    const token = sessionStorage.getItem('access_token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export default apiClient;