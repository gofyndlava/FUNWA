import React, { useState, useEffect } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';

const NewSPI = () => {
  const [models, setModels] = useState([]);
  const [formData, setFormData] = useState({
    model: '',
    spiid: '',
    totalpcba_allowed: '5000',
    totalcycle_allowed: '5'
  });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchModels();
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

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await apiClient.post('/api/spi/new', {
        model: formData.model,
        spiid: formData.spiid,
        totalpcba_allowed: formData.totalpcba_allowed,
        totalcycle_allowed: formData.totalcycle_allowed
      });

      if (response.data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: response.data.message || 'Successfully Submitted'
        });

        // Reset form
        setFormData({
          model: '',
          spiid: '',
          totalpcba_allowed: '5000',
          totalcycle_allowed: '5'
        });
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.response?.data?.error || 'Failed to submit SPI'
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
            <td colSpan="5">&nbsp;</td>
          </tr>
          <tr>
            <td className="label-cell">Solder Paste Model :</td>
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
                    <option key={index} value={model.SPIValue || model.spiValue || ''}>
                      {model.Model || model.model || 'Unknown'}
                    </option>
                  ))
                )}
              </select>
            </td>
          </tr>
          <tr>
            <td className="label-cell">Solder Paste Id :</td>
            <td>
              <input
                type="text"
                className="form-input"
                value={formData.spiid}
                onChange={(e) => setFormData({ ...formData, spiid: e.target.value })}
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

export default NewSPI;

