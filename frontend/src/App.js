import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [activeTab, setActiveTab] = useState('students');
  const [students, setStudents] = useState([]);
  const [courses, setCourses] = useState([]);
  const [attendanceRecords, setAttendanceRecords] = useState([]);
  
  // Form states
  const [newStudent, setNewStudent] = useState({ studentId: '', name: '', email: '', department: '' });
  const [newCourse, setNewCourse] = useState({ courseCode: '', courseName: '', description: '', maxStudents: '' });
  const [newAttendance, setNewAttendance] = useState({ studentId: '', courseCode: '', isPresent: true });

  // Load data on component mount
  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const [studentsRes, coursesRes, attendanceRes] = await Promise.all([
        axios.get('/api/students'),
        axios.get('/api/courses'),
        axios.get('/api/attendance')
      ]);
      
      setStudents(studentsRes.data);
      setCourses(coursesRes.data);
      setAttendanceRecords(attendanceRes.data);
    } catch (error) {
      console.error('Error loading data:', error);
    }
  };

  const handleAddStudent = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('/api/students', newStudent);
      setStudents([...students, response.data]);
      setNewStudent({ studentId: '', name: '', email: '', department: '' });
      alert('Student added successfully!');
    } catch (error) {
      alert('Error adding student');
    }
  };

  const handleAddCourse = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('/api/courses', newCourse);
      setCourses([...courses, response.data]);
      setNewCourse({ courseCode: '', courseName: '', description: '', maxStudents: '' });
      alert('Course added successfully!');
    } catch (error) {
      alert('Error adding course');
    }
  };

  const handleRecordAttendance = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('/api/attendance', newAttendance);
      setAttendanceRecords([...attendanceRecords, response.data]);
      setNewAttendance({ studentId: '', courseCode: '', isPresent: true });
      alert('Attendance recorded successfully!');
    } catch (error) {
      alert('Error recording attendance');
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>🎓 Student Attendance System</h1>
        <p>Simple blockchain-based attendance management</p>
      </header>

      <nav className="nav-tabs">
        <button 
          className={activeTab === 'students' ? 'active' : ''} 
          onClick={() => setActiveTab('students')}
        >
          Students
        </button>
        <button 
          className={activeTab === 'courses' ? 'active' : ''} 
          onClick={() => setActiveTab('courses')}
        >
          Courses
        </button>
        <button 
          className={activeTab === 'attendance' ? 'active' : ''} 
          onClick={() => setActiveTab('attendance')}
        >
          Attendance
        </button>
      </nav>

      <main className="main-content">
        {activeTab === 'students' && (
          <div className="tab-content">
            <h2>Student Management</h2>
            
            <form onSubmit={handleAddStudent} className="form">
              <h3>Add New Student</h3>
              <input
                type="text"
                placeholder="Student ID"
                value={newStudent.studentId}
                onChange={(e) => setNewStudent({...newStudent, studentId: e.target.value})}
                required
              />
              <input
                type="text"
                placeholder="Name"
                value={newStudent.name}
                onChange={(e) => setNewStudent({...newStudent, name: e.target.value})}
                required
              />
              <input
                type="email"
                placeholder="Email"
                value={newStudent.email}
                onChange={(e) => setNewStudent({...newStudent, email: e.target.value})}
                required
              />
              <input
                type="text"
                placeholder="Department"
                value={newStudent.department}
                onChange={(e) => setNewStudent({...newStudent, department: e.target.value})}
                required
              />
              <button type="submit">Add Student</button>
            </form>

            <div className="data-list">
              <h3>Registered Students ({students.length})</h3>
              {students.map(student => (
                <div key={student.id} className="data-item">
                  <strong>{student.studentId}</strong> - {student.name}
                  <br />
                  <small>{student.email} • {student.department}</small>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === 'courses' && (
          <div className="tab-content">
            <h2>Course Management</h2>
            
            <form onSubmit={handleAddCourse} className="form">
              <h3>Add New Course</h3>
              <input
                type="text"
                placeholder="Course Code"
                value={newCourse.courseCode}
                onChange={(e) => setNewCourse({...newCourse, courseCode: e.target.value})}
                required
              />
              <input
                type="text"
                placeholder="Course Name"
                value={newCourse.courseName}
                onChange={(e) => setNewCourse({...newCourse, courseName: e.target.value})}
                required
              />
              <input
                type="text"
                placeholder="Description"
                value={newCourse.description}
                onChange={(e) => setNewCourse({...newCourse, description: e.target.value})}
                required
              />
              <input
                type="number"
                placeholder="Max Students"
                value={newCourse.maxStudents}
                onChange={(e) => setNewCourse({...newCourse, maxStudents: e.target.value})}
                required
              />
              <button type="submit">Add Course</button>
            </form>

            <div className="data-list">
              <h3>Available Courses ({courses.length})</h3>
              {courses.map(course => (
                <div key={course.id} className="data-item">
                  <strong>{course.courseCode}</strong> - {course.courseName}
                  <br />
                  <small>{course.description} • Max: {course.maxStudents}</small>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === 'attendance' && (
          <div className="tab-content">
            <h2>Attendance Management</h2>
            
            <form onSubmit={handleRecordAttendance} className="form">
              <h3>Record Attendance</h3>
              <select
                value={newAttendance.studentId}
                onChange={(e) => setNewAttendance({...newAttendance, studentId: e.target.value})}
                required
              >
                <option value="">Select Student</option>
                {students.map(student => (
                  <option key={student.id} value={student.studentId}>
                    {student.studentId} - {student.name}
                  </option>
                ))}
              </select>
              <select
                value={newAttendance.courseCode}
                onChange={(e) => setNewAttendance({...newAttendance, courseCode: e.target.value})}
                required
              >
                <option value="">Select Course</option>
                {courses.map(course => (
                  <option key={course.id} value={course.courseCode}>
                    {course.courseCode} - {course.courseName}
                  </option>
                ))}
              </select>
              <label>
                <input
                  type="checkbox"
                  checked={newAttendance.isPresent}
                  onChange={(e) => setNewAttendance({...newAttendance, isPresent: e.target.checked})}
                />
                Present
              </label>
              <button type="submit">Record Attendance</button>
            </form>

            <div className="data-list">
              <h3>Attendance Records ({attendanceRecords.length})</h3>
              {attendanceRecords.map(record => (
                <div key={record.id} className="data-item">
                  <strong>{record.studentId}</strong> in <strong>{record.courseCode}</strong>
                  <br />
                  <small>
                    {record.isPresent ? '✅ Present' : '❌ Absent'} • 
                    {new Date(record.timestamp).toLocaleString()}
                  </small>
                </div>
              ))}
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

export default App;
