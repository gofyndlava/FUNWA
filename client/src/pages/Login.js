import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './Login.css';

const Login = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { login, user } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (user) {
      navigate('/');
    }
  }, [user, navigate]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    const result = await login(username, password);

    if (result.success) {
      navigate('/');
    }

    setLoading(false);
  };

  return (
    <div className="login-container">
      <div className="mark">
        <h1>Factory Utility system</h1>
      </div>

      <div className="Login">
        <form onSubmit={handleSubmit}>
          <div className="input-group">
            <span className="input-group-addon">
              <i className="fas fa-user"></i>
            </span>
            <input
              className="tbox"
              type="text"
              id="username"
              placeholder="Enter Userid"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <span className="input-group-addon">
              <i className="fas fa-key"></i>
            </span>
            <input
              className="tbox"
              type="password"
              id="password"
              placeholder="Enter Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <button type="submit" id="Button1" disabled={loading}>
              {loading ? 'Logging in...' : 'Login'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Login;

