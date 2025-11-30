import React, { useState } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../spi/HistoryStyles.css';

const StencilHistory = () => {
  const [stencilid, setStencilid] = useState('');
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await apiClient.get(`/api/stencil/history/${stencilid}`);
      if (response.data.success) {
        setHistory(response.data.data);
      }
    } catch (error) {
      console.error('Error fetching history:', error);
      setHistory([]);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: error.response?.data?.error || 'Failed to fetch stencil history: ' + error.message
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="history-container">
      <div className="history-form">
        <label>Stencil ID</label>
        <br />
        <input
          type="text"
          value={stencilid}
          onChange={(e) => setStencilid(e.target.value.toUpperCase())}
          placeholder="Enter Stencil ID"
          style={{ width: '311px', padding: '5px' }}
        />
        <br />
        <br />
        <button
          onClick={handleSubmit}
          disabled={loading}
          style={{ padding: '5px 15px', cursor: loading ? 'not-allowed' : 'pointer' }}
        >
          {loading ? 'Loading...' : 'Submit'}
        </button>
      </div>

      <div className="history-table-container">
        {history.length > 0 ? (
          <table className="history-table">
            <thead>
              <tr>
                <th>Stencil ID</th>
                <th>Current Status</th>
                <th>Cycle Count</th>
                <th>Total PCBA Count</th>
                <th>Last Updated By</th>
                <th>Last Updated DT</th>
                <th>Remarks</th>
              </tr>
            </thead>
            <tbody>
              {history.map((item, index) => (
                <tr key={index}>
                  <td>{item.stencil_id || item.Stencil_id}</td>
                  <td>{item.Status1 || item.status1}</td>
                  <td>{item.cyclecount}</td>
                  <td>{item.totalpcba_count}</td>
                  <td>{item.Lastupdated_by || item.lastupdated_by}</td>
                  <td>{new Date(item.Lastupdated_DT || item.lastupdated_dt).toLocaleString()}</td>
                  <td>{item.remarks}</td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p>No history found. Enter a Stencil ID and click Submit.</p>
        )}
      </div>
    </div>
  );
};

export default StencilHistory;

