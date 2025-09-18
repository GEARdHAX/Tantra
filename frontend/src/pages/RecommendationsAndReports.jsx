import React, { useState, useEffect } from 'react';
import { DownloadIcon, LightbulbIcon, PlusIcon, TrashIcon, CheckIcon } from 'lucide-react';
import { zones, recommendations } from '../data/mockData';

// TODO: Move this to a separate file later
const TaskList = () => {
  const [taskList, setTaskList] = useState([
    { id: 1, text: "Irrigate vegetable garden", completed: false },
    { id: 2, text: "Apply fertilizer to fruit orchard", completed: false },
    { id: 3, text: "Check rice paddy field water level", completed: true },
  ]);
  const [inputValue, setInputValue] = useState('');

  // Toggle task completion status
  const toggleTaskStatus = (taskId) => {
    // console.log('Toggling task:', taskId);
    setTaskList(prevTasks => 
      prevTasks.map(task => 
        task.id === taskId ? { ...task, completed: !task.completed } : task
      )
    );
  };

  const addNewTask = (e) => {
    e.preventDefault();
    
    // Don't add empty tasks
    if (!inputValue.trim()) return;
    
    const task = {
      id: Date.now(), // Simple ID generation - could use uuid later
      text: inputValue.trim(),
      completed: false
    };
    
    setTaskList(prev => [...prev, task]);
    setInputValue(''); // Clear input
  };

  const removeTask = (taskId) => {
    // Filter out the task to delete
    setTaskList(currentTasks => currentTasks.filter(task => task.id !== taskId));
  };

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white">
        <h2 className="text-lg font-semibold">Task List</h2>
      </div>
      <div className="p-4">
        
        {/* Add new task form */}
        <form onSubmit={addNewTask} className="flex mb-4">
          <input
            type="text"
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            placeholder="Add a new task..."
            className="flex-1 px-4 py-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-green-500"
          />
          <button
            type="submit"
            className="bg-green-600 text-white px-4 py-2 rounded-r-md hover:bg-green-700 focus:outline-none"
          >
            <PlusIcon size={18} />
          </button>
        </form>

        {/* Task list */}
        <ul className="divide-y divide-gray-200">
          {taskList.length === 0 ? (
            <li className="py-4 text-center text-gray-500">No tasks yet</li>
          ) : (
            taskList.map((task) => (
              <li key={task.id} className="py-3 flex items-center justify-between">
                <div className="flex items-center">
                  <button
                    onClick={() => toggleTaskStatus(task.id)}
                    className={`w-5 h-5 rounded-full border flex items-center justify-center mr-3 transition-colors ${
                      task.completed ? 'bg-green-500 border-green-500' : 'border-gray-300 hover:border-green-400'
                    }`}
                  >
                    {task.completed && <CheckIcon size={12} className="text-white" />}
                  </button>
                  <span className={`${task.completed ? 'line-through text-gray-400' : 'text-gray-700'}`}>
                    {task.text}
                  </span>
                </div>
                <button
                  onClick={() => removeTask(task.id)}
                  className="text-gray-400 hover:text-red-500 transition-colors"
                >
                  <TrashIcon size={16} />
                </button>
              </li>
            ))
          )}
        </ul>
      </div>
    </div>
  );
};

// Recommendations component
const RecommendationPanel = () => {
  // Sort recommendations by priority (high first)
  const sortedRecs = [...recommendations].sort((a, b) => {
    const priorities = { high: 1, medium: 2, low: 3 };
    return priorities[a.priority] - priorities[b.priority];
  });

  // Find zone name by ID - could probably memoize this
  const findZoneName = (zoneId) => {
    const foundZone = zones.find(zone => zone.id === zoneId);
    return foundZone ? foundZone.name : 'Unknown Zone';
  };

  const getPriorityStyles = (priority) => {
    const styles = {
      high: 'bg-red-100 text-red-800',
      medium: 'bg-yellow-100 text-yellow-800', 
      low: 'bg-green-100 text-green-800'
    };
    return styles[priority] || 'bg-gray-100 text-gray-800';
  };

  // Format timestamp for display
  const formatDateTime = (dateString) => {
    try {
      const date = new Date(dateString);
      return date.toLocaleString();
    } catch (err) {
      // console.error('Invalid date:', dateString);
      return 'Invalid date';
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="px-6 py-4 bg-green-900 text-white">
        <h2 className="text-lg font-semibold">Recommendations</h2>
      </div>
      
      {sortedRecs.length === 0 ? (
        <div className="p-6 text-center">
          <LightbulbIcon size={24} className="text-yellow-500 mx-auto mb-2" />
          <p className="text-gray-500">No recommendations available</p>
        </div>
      ) : (
        <ul className="divide-y divide-gray-200">
          {sortedRecs.map((recommendation) => (
            <li key={recommendation.id} className="p-4 hover:bg-gray-50 transition-colors">
              <div className="flex items-start">
                <div className="flex-shrink-0 mr-3">
                  <div className="bg-yellow-100 p-2 rounded-full">
                    <LightbulbIcon size={16} className="text-yellow-500" />
                  </div>
                </div>
                <div className="flex-1">
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-sm font-medium text-green-600">
                      {findZoneName(recommendation.zoneId)}
                    </span>
                    <span className={`text-xs px-2 py-1 rounded-full ${getPriorityStyles(recommendation.priority)}`}>
                      {recommendation.priority.charAt(0).toUpperCase() + recommendation.priority.slice(1)}
                    </span>
                  </div>
                  <div className="text-sm font-medium text-gray-900 mb-1">
                    {recommendation.message}
                  </div>
                  <div className="text-xs text-gray-500">
                    {formatDateTime(recommendation.timestamp)}
                  </div>
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

const RecommendationsAndReports = () => {
  // Export data to CSV file
  const handleDataExport = () => {
    // Build CSV content
    let csvData = "Zone,Status,Moisture,Temperature,Last Updated,Alert Count\n";
    
    zones.forEach(zone => {
      csvData += `"${zone.name}",${zone.status},${zone.moisture},${zone.temperature},${zone.lastUpdated},${zone.alerts.length}\n`;
    });
    
    // Create and download file
    const blob = new Blob([csvData], { type: 'text/csv;charset=utf-8;' });
    const downloadUrl = URL.createObjectURL(blob);
    const link = document.createElement('a');
    
    link.setAttribute('href', downloadUrl);
    link.setAttribute('download', `farm_data_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // Clean up the URL object
    URL.revokeObjectURL(downloadUrl);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      
      {/* Page header */}
      <div className="mb-8">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Recommendations & Reports</h1>
            <p className="mt-1 text-gray-600">
              Get insights and recommendations for your farm
            </p>
          </div>
          <button
            className="flex items-center px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 focus:outline-none transition-colors"
            onClick={handleDataExport}
          >
            <DownloadIcon size={18} className="mr-2" />
            Export Data (CSV)
          </button>
        </div>
      </div>

      {/* Main content grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-8">
          <RecommendationPanel />
        </div>
        <div>
          <TaskList />
        </div>
      </div>
    </div>
  );
};

export default RecommendationsAndReports;
