const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'factory-utility-secret-key-change-in-production';

// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ error: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(403).json({ error: 'Invalid or expired token.' });
  }
};

// Middleware to check user roles
const authorizeRole = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'User not authenticated.' });
    }

    const userRoles = req.user.roles ? req.user.roles.toUpperCase() : '';
    const hasRole = roles.some(role => userRoles.includes(role.toUpperCase()));

    if (!hasRole) {
      return res.status(403).json({ error: 'Access denied. Insufficient permissions.' });
    }

    next();
  };
};

// Generate JWT token
const generateToken = (user) => {
  return jwt.sign(
    {
      userid: user.userid,
      username: user.username,
      roles: user.roles,
      email: user.email
    },
    JWT_SECRET,
    { expiresIn: '8h' }
  );
};

module.exports = {
  authenticateToken,
  authorizeRole,
  generateToken
};

