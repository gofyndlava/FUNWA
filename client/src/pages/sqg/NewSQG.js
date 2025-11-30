import React, { useState } from 'react';
import apiClient from '../../config/axios';
import Swal from 'sweetalert2';
import '../FormStyles.css';

const NewSQG = () => {
  const [formData, setFormData] = useState({
    sqgid: '',
    totalpcba_allowed: '',
    totalcycle_allowed: ''
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await apiClient.post('/api/sqg/new', formData);

      if (response.data.success) {
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: response.data.message || 'Successfully Submitted'
        });

        setFormData({
          sqgid: '',
          totalpcba_allowed: '',
          totalcycle_allowed: ''
        });
      }
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.response?.data?.error || 'Failed to submit SQG'
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
            <td className="label-cell">SQG Id :</td>
            <td>
              <input
                type="text"
                className="form-input"
                value={formData.sqgid}
                onChange={(e) => setFormData({ ...formData, sqgid: e.target.value })}
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

export default NewSQG;

