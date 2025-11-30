import React, { useState } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';

const EditStencil = () => {
  const [stencilId, setStencilId] = useState('');
  const [formData, setFormData] = useState({
    totalpcba_allowed: '',
    totalcycle_allowed: ''
  });
  const [loading, setLoading] = useState(false);
  const [searching, setSearching] = useState(false);
  const [found, setFound] = useState(false);
  const [error, setError] = useState('');
  const [result, setResult] = useState('');

  const handleSearch = async (e) => {
    e.preventDefault();
    
    if (!stencilId.trim()) {
      setError('Please enter a Stencil ID.');
      setFound(false);
      return;
    }

    setSearching(true);
    setError('');
    setResult('');
    setFound(false);

    try {
      const response = await apiClient.get(`/api/stencil/${stencilId.trim().toUpperCase()}`);
      
      if (response.data.success && response.data.data) {
        const stencil = response.data.data;
        setFormData({
          totalpcba_allowed: stencil.totalpcba_allowed || '',
          totalcycle_allowed: stencil.totalcycle_allowed || ''
        });
        setFound(true);
        setError('');
      } else {
        setError('Stencil not found.');
        setFound(false);
      }
    } catch (error) {
      setError(error.response?.data?.error || 'Error loading stencil: ' + error.message);
      setFound(false);
    } finally {
      setSearching(false);
    }
  };

  const handleUpdate = async (e) => {
    e.preventDefault();
    
    if (!stencilId.trim()) {
      setError('Please enter a Stencil ID.');
      return;
    }

    if (!formData.totalpcba_allowed || !formData.totalcycle_allowed) {
      setError('PCBA Allowed and Cycle Allowed are required.');
      return;
    }

    setLoading(true);
    setError('');
    setResult('');

    try {
      const response = await apiClient.put(`/api/stencil/edit/${stencilId.trim().toUpperCase()}`, {
        totalpcba_allowed: parseInt(formData.totalpcba_allowed),
        totalcycle_allowed: parseInt(formData.totalcycle_allowed)
      });

      if (response.data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: response.data.message || 'Updated successfully.'
        });

        setFormData({
          totalpcba_allowed: '',
          totalcycle_allowed: ''
        });
        setStencilId('');
        setFound(false);
        setResult('');
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.response?.data?.error || 'Failed to update stencil: ' + error.message
      });
    } finally {
      setLoading(false);
    }
  };

  const handleClear = () => {
    setStencilId('');
    setFormData({
      totalpcba_allowed: '',
      totalcycle_allowed: ''
    });
    setError('');
    setResult('');
    setFound(false);
  };

  return (
    <div className="form-container">
      <h2>Modify Stencil</h2>
      
      <form onSubmit={handleSearch}>
        <table className="form-table">
          <tbody>
            <tr>
              <td className="label-cell">Stencil ID:</td>
              <td>
                <input
                  type="text"
                  className="form-input"
                  value={stencilId}
                  onChange={(e) => setStencilId(e.target.value)}
                  placeholder="Enter Stencil ID"
                  required
                />
              </td>
              <td>
                <button
                  type="submit"
                  className="submit-button"
                  disabled={searching}
                >
                  {searching ? 'Searching...' : 'Search'}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>

      {error && (
        <div style={{ color: 'red', marginTop: '10px', marginBottom: '10px' }}>
          {error}
        </div>
      )}

      {result && (
        <div style={{ color: 'green', marginTop: '10px', marginBottom: '10px' }}>
          {result}
        </div>
      )}

      {found && (
        <form onSubmit={handleUpdate}>
          <table className="form-table">
            <tbody>
              <tr>
                <td className="label-cell">Total PCBA Allowed:</td>
                <td>
                  <input
                    type="number"
                    className="form-input"
                    value={formData.totalpcba_allowed}
                    onChange={(e) => setFormData({ ...formData, totalpcba_allowed: e.target.value })}
                    required
                  />
                </td>
              </tr>
              <tr>
                <td className="label-cell">Total Cycle Allowed:</td>
                <td>
                  <input
                    type="number"
                    className="form-input"
                    value={formData.totalcycle_allowed}
                    onChange={(e) => setFormData({ ...formData, totalcycle_allowed: e.target.value })}
                    required
                  />
                </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>
                  <button
                    type="submit"
                    className="submit-button"
                    disabled={loading}
                  >
                    {loading ? 'Updating...' : 'Update'}
                  </button>
                  <button
                    type="button"
                    className="submit-button"
                    onClick={handleClear}
                    style={{ marginLeft: '10px', backgroundColor: '#6c757d' }}
                  >
                    Clear
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      )}
    </div>
  );
};

export default EditStencil;

