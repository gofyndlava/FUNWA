import React from 'react';
import { Outlet, Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './MasterLayout.css';

const MasterLayout = () => {
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  return (
    <div className="master-container">
      <header>
        <div className="navbar">
          <ul>
            <li>
              <Link to="/">
                <i className="fa-solid fa-house"></i>&nbsp;Home
              </Link>
            </li>
            
            <li>
              <span className="nav-menu-item">
                <i className="fa-brands fa-stack-overflow"></i>&nbsp;Stencil Management
              </span>
              <ul>
                <li><Link to="/stencil/new">Create New Stencil</Link></li>
                <li><Link to="/stencil/change">Change Stencil Status</Link></li>
                <li><Link to="/scrap/hold">Hold/Scrap</Link></li>
                <li><Link to="/scrap/report">Hold/Scrap Report</Link></li>
                <li><Link to="/stencil/history">Show Stencil History</Link></li>
                <li><Link to="/stencil/monitor">Monitor Stencil</Link></li>
                <li><Link to="/stencil/edit">Modify Stencil</Link></li>
              </ul>
            </li>

            <li>
              <span className="nav-menu-item">
                <i className="fa-solid fa-layer-group"></i>&nbsp;SP Management
              </span>
              <ul>
                <li><Link to="/spi/new">Create New SP</Link></li>
                <li><Link to="/spi/change">Change SP Status</Link></li>
                <li><Link to="/spi/history">Show SP History</Link></li>
                <li><Link to="/spi/edit">Modify SPI</Link></li>
              </ul>
            </li>

            <li>
              <span className="nav-menu-item">
                <i className="fa-solid fa-pen-fancy"></i>&nbsp;SQG
              </span>
              <ul>
                <li><Link to="/sqg/new">New SQG</Link></li>
                <li><Link to="/sqg/change">Change Status</Link></li>
                <li><Link to="/sqg/history">History</Link></li>
              </ul>
            </li>

            <li>
              <span className="nav-menu-item">
                <i className="fa-brands fa-servicestack"></i>&nbsp;Wave
              </span>
              <ul>
                <li><Link to="/wave/new">New WavePallet</Link></li>
                <li><Link to="/wave/change">Change Status</Link></li>
                <li><span className="nav-menu-item">History</span></li>
              </ul>
            </li>

            <li>
              <button type="button" onClick={handleLogout} className="nav-logout-button">
                <i className="fa-solid fa-user"></i>&nbsp;Logout
              </button>
            </li>
          </ul>
        </div>
      </header>

      <main className="content container" style={{ flex: 1 }}>
        <Outlet />
      </main>

      <footer>
        <p>Developed by MES Team</p>
      </footer>
    </div>
  );
};

export default MasterLayout;

