import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Login from './pages/Login';
import Home from './pages/Home';
import MasterLayout from './components/MasterLayout';
import NewSPI from './pages/spi/NewSPI';
import ChangeSPI from './pages/spi/ChangeSPI';
import SPIHistory from './pages/spi/SPIHistory';
import EditSPI from './pages/spi/EditSPI';
import NewStencil from './pages/stencil/NewStencil';
import ChangeStencil from './pages/stencil/ChangeStencil';
import StencilHistory from './pages/stencil/StencilHistory';
import EditStencil from './pages/stencil/EditStencil';
import InProcessStencil from './pages/stencil/InProcessStencil';
import NewSQG from './pages/sqg/NewSQG';
import ChangeSQG from './pages/sqg/ChangeSQG';
import SQGHistory from './pages/sqg/SQGHistory';
import NewWave from './pages/wave/NewWave';
import ChangeWave from './pages/wave/ChangeWave';
import HoldScrap from './pages/scrap/HoldScrap';
import HoldScrapReport from './pages/scrap/HoldScrapReport';
import UserAccess from './pages/UserAccess';

// Protected Route Component
const ProtectedRoute = ({ children }) => {
  const { user, loading } = useAuth();

  if (loading) {
    return <div>Loading...</div>;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return children;
};

// Role-based Protected Route
const RoleProtectedRoute = ({ children, allowedRoles = [] }) => {
  const { user, loading } = useAuth();

  if (loading) {
    return <div>Loading...</div>;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  const userRoles = user.roles ? user.roles.toUpperCase() : '';
  const hasRole = allowedRoles.some(role => userRoles.includes(role.toUpperCase()));

  if (!hasRole) {
    return <Navigate to="/user-access" replace />;
  }

  return children;
};

function AppRoutes() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      
      <Route path="/" element={
        <ProtectedRoute>
          <MasterLayout />
        </ProtectedRoute>
      }>
        <Route index element={<Home />} />
        
        {/* SPI Routes */}
        <Route path="spi/new" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS']}>
            <NewSPI />
          </RoleProtectedRoute>
        } />
        <Route path="spi/change" element={<ChangeSPI />} />
        <Route path="spi/history" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR']}>
            <SPIHistory />
          </RoleProtectedRoute>
        } />
        <Route path="spi/edit" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR']}>
            <EditSPI />
          </RoleProtectedRoute>
        } />
        
        {/* Stencil Routes */}
        <Route path="stencil/new" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS']}>
            <NewStencil />
          </RoleProtectedRoute>
        } />
        <Route path="stencil/change" element={<ChangeStencil />} />
        <Route path="stencil/history" element={<StencilHistory />} />
        <Route path="stencil/monitor" element={
          <RoleProtectedRoute allowedRoles={['PROCESS', 'QUALITY', 'OPERATOR']}>
            <InProcessStencil />
          </RoleProtectedRoute>
        } />
        <Route path="stencil/edit" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR']}>
            <EditStencil />
          </RoleProtectedRoute>
        } />
        
        {/* SQG Routes */}
        <Route path="sqg/new" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS']}>
            <NewSQG />
          </RoleProtectedRoute>
        } />
        <Route path="sqg/change" element={<ChangeSQG />} />
        <Route path="sqg/history" element={<SQGHistory />} />
        
        {/* Wave Routes */}
        <Route path="wave/new" element={
          <RoleProtectedRoute allowedRoles={['ADMIN', 'PROCESS']}>
            <NewWave />
          </RoleProtectedRoute>
        } />
        <Route path="wave/change" element={<ChangeWave />} />
        
        {/* Scrap Routes */}
        <Route path="scrap/hold" element={<HoldScrap />} />
        <Route path="scrap/report" element={<HoldScrapReport />} />
        
        {/* User Access */}
        <Route path="user-access" element={<UserAccess />} />
      </Route>
      
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

function App() {
  return (
    <AuthProvider>
      <Router>
        <AppRoutes />
      </Router>
    </AuthProvider>
  );
}

export default App;

