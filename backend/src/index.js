const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory storage for demo purposes
let students = [];
let courses = [];
let attendanceRecords = [];

// Routes

// Get all students
app.get('/api/students', (req, res) => {
  res.json(students);
});

// Add a new student
app.post('/api/students', (req, res) => {
  const { studentId, name, email, department } = req.body;
  
  if (!studentId || !name || !email || !department) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  const newStudent = {
    id: Date.now().toString(),
    studentId,
    name,
    email,
    department,
    enrollmentDate: new Date().toISOString(),
    isActive: true
  };

  students.push(newStudent);
  res.status(201).json(newStudent);
});

// Get all courses
app.get('/api/courses', (req, res) => {
  res.json(courses);
});

// Add a new course
app.post('/api/courses', (req, res) => {
  const { courseCode, courseName, description, maxStudents } = req.body;
  
  if (!courseCode || !courseName || !description || !maxStudents) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  const newCourse = {
    id: Date.now().toString(),
    courseCode,
    courseName,
    description,
    maxStudents: parseInt(maxStudents),
    enrolledStudents: [],
    isActive: true,
    createdAt: new Date().toISOString()
  };

  courses.push(newCourse);
  res.status(201).json(newCourse);
});

// Get attendance records
app.get('/api/attendance', (req, res) => {
  res.json(attendanceRecords);
});

// Record attendance
app.post('/api/attendance', (req, res) => {
  const { studentId, courseCode, isPresent } = req.body;
  
  if (!studentId || !courseCode || typeof isPresent !== 'boolean') {
    return res.status(400).json({ error: 'Invalid attendance data' });
  }

  const newRecord = {
    id: Date.now().toString(),
    studentId,
    courseCode,
    isPresent,
    timestamp: new Date().toISOString()
  };

  attendanceRecords.push(newRecord);
  res.status(201).json(newRecord);
});

// Get attendance for a specific student
app.get('/api/attendance/student/:studentId', (req, res) => {
  const { studentId } = req.params;
  const studentRecords = attendanceRecords.filter(record => record.studentId === studentId);
  res.json(studentRecords);
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});
