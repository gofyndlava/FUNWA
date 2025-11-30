import React, { createContext, useState, useContext, useEffect, useCallback } from 'react';
import Swal from 'sweetalert2';
import apiClient from '../config/axios';

const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [token, setToken] = useState(localStorage.getItem('token'));

  const verifyToken = useCallback(async () => {
    const authToken = localStorage.getItem('token');
    if (!authToken) {
      setLoading(false);
      return;
    }

    try {
      await apiClient.get('/api/auth/verify');
      // If token is valid, decode it to get user info
      const payload = JSON.parse(atob(authToken.split('.')[1]));
      setUser({
        userid: payload.userid,
        username: payload.username,
        email: payload.email,
        roles: payload.roles
      });
    } catch (error) {
      // Token is invalid, remove it
      localStorage.removeItem('token');
      setToken(null);
    } finally {
      setLoading(false);
    }
  }, []);

  // Verify token on mount
  useEffect(() => {
    if (token) {
      // Token is automatically handled by apiClient interceptor
      verifyToken();
    } else {
      setLoading(false);
    }
  }, [token, verifyToken]);

  const login = async (username, password) => {
    try {
      const response = await apiClient.post('/api/auth/login', {
        username,
        password
      });

      if (response.data.success) {
        const { token: newToken, user: userData } = response.data;
        setToken(newToken);
        setUser(userData);
        localStorage.setItem('token', newToken);
        // Token is automatically added by apiClient interceptor
        return { success: true };
      }
    } catch (error) {
      if (error.response && error.response.data && error.response.data.showAlert) {
        Swal.fire({
          icon: 'error',
          title: 'Oops...',
          text: error.response.data.error || 'Userid or Password is Incorrect !'
        });
      }
      return { success: false, error: error.response?.data?.error || 'Login failed' };
    }
  };

  const logout = async () => {
    try {
      await apiClient.post('/api/auth/logout');
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      setToken(null);
      setUser(null);
      localStorage.removeItem('token');
      // Token removal handled by localStorage cleanup
    }
  };

  const value = {
    user,
    token,
    loading,
    login,
    logout
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
