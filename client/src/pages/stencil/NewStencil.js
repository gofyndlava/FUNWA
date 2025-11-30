import React, { useState, useEffect } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';

const NewStencil = () => {
  const [models, setModels] = useState([]);
  const [formData, setFormData] = useState({
    model: '',
    stencilid: '',
    totalpcba_allowed: '',
    totalcycle_allowed: ''
  });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchModels();
  }, []);

  const fetchModels = async () => {
    try {
      const response = await apiClient.get('/api/stencil/models');
      if (response.data.success && response.data.data) {
        setModels(response.data.data);
        console.log('Loaded models:', response.data.data.length);
      } else {
        console.error('No models data in response:', response.data);
      }
    } catch (error) {
      console.error('Error fetching models:', error);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to load models: ' + (error.response?.data?.error || error.message)
      });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await apiClient.post('/api/stencil/new', formData);

      if (response.data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: response.data.message || 'Successfully Submitted'
        });

        setFormData({
          model: '',
          stencilid: '',
          totalpcba_allowed: '',
          totalcycle_allowed: ''
        });
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.response?.data?.error || 'Failed to submit Stencil'
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="form-container">
      <table className="form-table">
        <tbody>
          <tr>
            <td className="label-cell">Model:</td>
            <td>
              <select
                className="form-select"
                value={formData.model}
                onChange={(e) => setFormData({ ...formData, model: e.target.value })}
                required
              >
                {models.length === 0 ? (
                  <option value="">Loading models...</option>
                ) : (
                  models.map((model, index) => (
                    <option key={index} value={model.StencilValue || model.stencilValue || ''}>
                      {model.Model || model.model || 'Unknown'}
                    </option>
                  ))
                )}
              </select>
            </td>
          </tr>
          <tr>
            <td className="label-cell">Stencil Id :</td>
            <td>
              <input
                type="text"
                className="form-input"
                value={formData.stencilid}
                onChange={(e) => setFormData({ ...formData, stencilid: e.target.value })}
                required
              />
            </td>
          </tr>
          <tr>
            <td className="label-cell">Total PCBA Allowed :</td>
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
            <td className="label-cell">Total cycle Allowed :</td>
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
                type="button"
                className="submit-button"
                onClick={handleSubmit}
                disabled={loading}
              >
                {loading ? 'Submitting...' : 'Submit'}
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  );
};

export default NewStencil;

