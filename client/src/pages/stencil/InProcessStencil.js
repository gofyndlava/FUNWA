import React, { useState, useEffect, useRef, useCallback } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';
import './InProcessStencil.css';

const InProcessStencil = () => {
  const [stencils, setStencils] = useState([]);
  const [filter, setFilter] = useState('');
  const [selectedStencil, setSelectedStencil] = useState('');
  const [selectedStencilId, setSelectedStencilId] = useState('');
  const [timerText, setTimerText] = useState('');
  const [warningTime, setWarningTime] = useState(null);
  const [timerClass, setTimerClass] = useState('');
  const [loading, setLoading] = useState(false);
  const intervalRef = useRef(null);
  const warningTimeRef = useRef(null);

  const updateTimerLabel = useCallback((warning) => {
    const now = new Date();
    const remaining = warning - now;

    if (remaining <= 0) {
      setTimerText('Last Updated Completed! Please clean now!');
      setTimerClass('blinking-warning');
    } else {
      const hours = Math.floor(remaining / (1000 * 60 * 60));
      const minutes = Math.floor((remaining % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((remaining % (1000 * 60)) / 1000);
      setTimerText(`Time left: ${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`);
      setTimerClass('ok');
    }
  }, []);

  const startCountdown = useCallback(() => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
    }

    intervalRef.current = setInterval(() => {
      if (warningTimeRef.current) {
        updateTimerLabel(warningTimeRef.current);
      }
    }, 1000);
  }, [updateTimerLabel]);

  const loadStencilTimer = useCallback(async (stencilId) => {
    try {
      const response = await apiClient.get(`/api/stencil/${stencilId}`);
      
      if (response.data.success && response.data.data) {
        const lastUpdated = new Date(response.data.data.Lastupdated_DT);
        const intervalHours = 4;
        const warning = new Date(lastUpdated.getTime() + (intervalHours * 60 * 60 * 1000));
        warningTimeRef.current = warning;
        setWarningTime(warning);
        updateTimerLabel(warning);
      }
    } catch (error) {
      console.error('Error loading timer:', error);
      setTimerText('No data found.');
      setTimerClass('');
    }
  }, [updateTimerLabel]);

  useEffect(() => {
    fetchStencilList();
    // Load previous selection from localStorage
    const savedStencil = localStorage.getItem('selectedStencil');
    if (savedStencil) {
      setSelectedStencilId(savedStencil);
      loadStencilTimer(savedStencil);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (warningTime) {
      warningTimeRef.current = warningTime;
      // Start countdown when warningTime changes
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
      intervalRef.current = setInterval(() => {
        if (warningTimeRef.current) {
          updateTimerLabel(warningTimeRef.current);
        }
      }, 1000);
    }
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [warningTime, updateTimerLabel]);

  const fetchStencilList = async (filterText = '') => {
    try {
      const params = filterText ? { filter: filterText } : {};
      const response = await apiClient.get('/api/stencil/monitor/list', { params });
      
      if (response.data.success && response.data.data) {
        setStencils(response.data.data);
        console.log('Loaded stencils for monitoring:', response.data.data.length);
      } else {
        console.error('No stencils data in response:', response.data);
      }
    } catch (error) {
      console.error('Error fetching stencils:', error);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to fetch stencil list'
      });
    }
  };


  const handleFilter = async (e) => {
    e.preventDefault();
    await fetchStencilList(filter);
  };

  const handleStart = async () => {
    if (!selectedStencilId || selectedStencilId === '-- Select Stencil --') {
      Swal.fire({
        icon: 'warning',
        title: 'Warning',
        text: 'Please select a stencil'
      });
      return;
    }

    setLoading(true);

    try {
      const response = await apiClient.post('/api/stencil/monitor/start', {
        stencilid: selectedStencilId
      });

      if (response.data.success) {
        setSelectedStencil(`Selected Stencil: ${selectedStencilId}`);
        localStorage.setItem('selectedStencil', selectedStencilId);
        
        const warning = new Date(response.data.data.warningTime);
        warningTimeRef.current = warning;
        setWarningTime(warning);
        updateTimerLabel(warning);
        // Countdown will start automatically via useEffect when warningTime is set

        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: 'Monitoring started',
          timer: 2000,
          showConfirmButton: false
        });

        // Reload list and reset selection
        setFilter('');
        await fetchStencilList('');
        setSelectedStencilId('');
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: error.response?.data?.error || 'Failed to start monitoring'
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="form-container" style={{ maxWidth: '600px', margin: '0 auto', paddingTop: '80px' }}>
      <h1>Stencil Monitor</h1>

      <form onSubmit={handleFilter}>
        <table className="form-table">
          <tbody>
            <tr>
              <td className="label-cell">Filter stencil ID:</td>
              <td>
                <input
                  type="text"
                  className="form-input"
                  value={filter}
                  onChange={(e) => setFilter(e.target.value)}
                  placeholder="Enter stencil ID to filter..."
                />
              </td>
              <td>
                <button
                  type="submit"
                  className="submit-button"
                >
                  Filter
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>

      <table className="form-table" style={{ marginTop: '20px' }}>
        <tbody>
          <tr>
            <td className="label-cell">Select Stencil:</td>
            <td>
              <select
                className="form-select"
                value={selectedStencilId}
                onChange={(e) => setSelectedStencilId(e.target.value)}
              >
                {stencils.length === 0 ? (
                  <option value="">Loading stencils...</option>
                ) : (
                  stencils.map((stencil, index) => (
                    <option key={index} value={stencil.stencil_id || stencil.Stencil_id || ''}>
                      {stencil.stencil_id || stencil.Stencil_id || 'Unknown'}
                    </option>
                  ))
                )}
              </select>
            </td>
            <td>
              <button
                type="button"
                className="submit-button"
                onClick={handleStart}
                disabled={loading}
              >
                {loading ? 'Starting...' : 'Start'}
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <div style={{ marginTop: '20px' }}>
        {selectedStencil && (
          <div style={{ marginBottom: '10px', fontWeight: 'bold' }}>
            {selectedStencil}
          </div>
        )}
        {timerText && (
          <div className={timerClass} style={{
            padding: '10px',
            borderRadius: '5px',
            marginTop: '10px',
            fontWeight: 'bold'
          }}>
            {timerText}
          </div>
        )}
      </div>
    </div>
  );
};

export default InProcessStencil;

