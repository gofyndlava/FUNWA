import React, { useState, useEffect } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';

const ChangeStencil = () => {
  const [models, setModels] = useState([]);
  const [statuses, setStatuses] = useState([]);
  const [formData, setFormData] = useState({
    model: '',
    status1: '',
    stencilid: '',
    remarks: '',
    pcbacount: ''
  });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchModels();
    fetchRoutes();
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

  const fetchRoutes = async () => {
    try {
      const response = await apiClient.get('/api/stencil/routes');
      if (response.data.success && response.data.data) {
        setStatuses(response.data.data);
        console.log('Loaded routes:', response.data.data.length);
      } else {
        console.error('No routes data in response:', response.data);
      }
    } catch (error) {
      console.error('Error fetching routes:', error);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to load statuses: ' + (error.response?.data?.error || error.message)
      });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await apiClient.post('/api/stencil/change-status', formData);

      if (response.data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: response.data.message || 'Stencil status updated successfully'
        });

        setFormData({
          model: formData.model,
          status1: '',
          stencilid: '',
          remarks: '',
          pcbacount: ''
        });
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.response?.data?.error || 'Failed to update stencil status'
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
            <td className="label-cell">Stencil Model</td>
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
            <td className="label-cell">Select Stencil Status</td>
            <td>
              <select
                className="form-select"
                value={formData.status1}
                onChange={(e) => setFormData({ ...formData, status1: e.target.value })}
                required
                disabled={!formData.model || !formData.stencilid}
              >
                {statuses.length === 0 ? (
                  <option value="">Loading statuses...</option>
                ) : (
                  statuses.map((status, index) => (
                    <option key={index} value={status.ValueField || status.valueField || ''}>
                      {status.TextFiled || status.textFiled || 'Unknown'}
                    </option>
                  ))
                )}
              </select>
            </td>
          </tr>
          <tr>
            <td className="label-cell">Scan Stencil :</td>
            <td>
              <input
                type="text"
                className="form-input"
                value={formData.stencilid}
                onChange={(e) => setFormData({ ...formData, stencilid: e.target.value.toUpperCase() })}
                required
                disabled={!formData.model}
              />
            </td>
          </tr>
          <tr>
            <td className="label-cell">Remarks :</td>
            <td>
              <input
                type="text"
                className="form-input"
                value={formData.remarks}
                onChange={(e) => setFormData({ ...formData, remarks: e.target.value })}
                required
              />
            </td>
          </tr>
          <tr>
            <td className="label-cell">Pcba Count :</td>
            <td>
              <input
                type="number"
                className="form-input"
                value={formData.pcbacount}
                onChange={(e) => setFormData({ ...formData, pcbacount: e.target.value })}
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

export default ChangeStencil;

