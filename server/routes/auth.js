const express = require('express');
const router = express.Router();
const { executeQuery } = require('../config/database');
const { generateToken } = require('../middleware/auth');

// Login endpoint
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required.' });
    }

    // Query matches the original VB.NET code
    const query = `
      SELECT * FROM LoginDetails 
      WHERE Userid = @username AND Userpassword = @password
    `;

    const params = {
      username: username.trim(),
      password: password
    };

    const results = await executeQuery(query, params);

    if (results.length === 0) {
      return res.status(401).json({ 
        error: 'Userid or Password is Incorrect',
        showAlert: true 
      });
    }

    const user = results[0];

    // Create user object for session/token
    const userData = {
      userid: user.Userid || user.userid,
      username: user.Username || user.username || user.Userid,
      email: user.Useremail || user.email || '',
      roles: user.Roles || user.roles || ''
    };

    // Generate JWT token
    const token = generateToken(userData);

    res.json({
      success: true,
      token: token,
      user: userData,
      message: 'Login successful'
    });

  } catch (error) {
    console.error('Login error:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({ 
      error: 'Internal server error during login.',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

// Logout endpoint
router.post('/logout', (req, res) => {
  // With JWT, logout is handled client-side by removing the token
  // If using sessions, you would destroy the session here
  res.json({ success: true, message: 'Logged out successfully' });
});

// Verify token endpoint (for checking if user is still authenticated)
router.get('/verify', async (req, res) => {
  // This will be handled by the authenticateToken middleware
  res.json({ success: true, message: 'Token is valid' });
});

module.exports = router;

