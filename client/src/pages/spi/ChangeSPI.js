import React, { useState, useEffect } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';

const ChangeSPI = () => {
  const [models, setModels] = useState([]);
  const [statuses, setStatuses] = useState([]);
  const [formData, setFormData] = useState({
    model: '',
    status1: '',
    spiid: '',
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
      const response = await apiClient.get('/api/spi/models');
      if (response.data.success && response.data.data) {
        setModels(response.data.data);
        console.log('Loaded SPI models:', response.data.data.length);
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
      const response = await apiClient.get('/api/spi/routes');
      if (response.data.success && response.data.data) {
        setStatuses(response.data.data);
        console.log('Loaded SPI routes:', response.data.data.length);
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

  const handleModelChange = (e) => {
    setFormData({ ...formData, model: e.target.value, status1: '', spiid: '', remarks: '', pcbacount: '' });
  };

  const handleSpiIdChange = async (e) => {
    const spiid = e.target.value;
    setFormData({ ...formData, spiid });

    if (spiid && formData.model) {
      try {
        await apiClient.get(`/api/spi/${spiid}`);
        // SPI data validated if no error
      } catch (error) {
        if (error.response?.status !== 404) {
          console.error('Error fetching SPI:', error);
        }
      }
    }
  };

  const handleStatusChange = (e) => {
    setFormData({ ...formData, status1: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await apiClient.post('/api/spi/change-status', formData);

      if (response.data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: response.data.message || 'SPI status updated successfully'
        });

        // Reset form
        setFormData({
          model: formData.model,
          status1: '',
          spiid: '',
          remarks: '',
          pcbacount: ''
        });
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.response?.data?.error || 'Failed to update SPI status'
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
            <td className="label-cell">Solder Paste Model</td>
            <td>
              <select
                className="form-select"
                value={formData.model}
                onChange={handleModelChange}
                required
              >
                {models.length === 0 ? (
                  <option value="">Loading models...</option>
                ) : (
                  models.map((model, index) => (
                    <option key={index} value={model.SPIValue || model.spiValue || ''}>
                      {model.Model || model.model || 'Unknown'}
                    </option>
                  ))
                )}
              </select>
            </td>
          </tr>
          <tr>
            <td className="label-cell">Select Spi Status</td>
            <td>
              <select
                className="form-select"
                value={formData.status1}
                onChange={handleStatusChange}
                required
                disabled={!formData.model || !formData.spiid}
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
            <td className="label-cell">Scan Spi :</td>
            <td>
              <input
                type="text"
                className="form-input"
                value={formData.spiid}
                onChange={handleSpiIdChange}
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

export default ChangeSPI;
