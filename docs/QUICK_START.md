# Quick Start Guide - Student Attendance System

This is a **simplified** Student Attendance System built on Aptos blockchain with minimal functions and basic UI.

## 🎯 What This System Does

- **Add Students**: Register new students with basic info
- **Add Courses**: Create new courses with descriptions
- **Record Attendance**: Mark students as present/absent for specific courses
- **View Data**: See all students, courses, and attendance records

## 🚀 Quick Start (5 minutes)

### 1. Install Dependencies
```bash
npm run install:all
```

### 2. Start the Application
```bash
npm run start:dev
```

This will start:
- Backend API on http://localhost:3001
- Frontend UI on http://localhost:3000

### 3. Use the System
1. Open http://localhost:3000 in your browser
2. Add a few students in the "Students" tab
3. Add a course in the "Courses" tab
4. Record attendance in the "Attendance" tab

## 🏗️ Project Structure

```
student-attendance-system/
├── move/                    # Move smart contracts (simplified)
├── backend/                 # Simple Express.js API
├── frontend/                # Basic React UI
├── scripts/                 # Helper scripts
└── docs/                    # Documentation
```

## 🔧 Smart Contracts (Move)

The system has 3 simple Move modules:
- **StudentRegistry**: Basic student management
- **CourseManager**: Simple course creation
- **AttendanceTracker**: Basic attendance recording

## 🌐 API Endpoints

- `GET /api/students` - Get all students
- `POST /api/students` - Add new student
- `GET /api/courses` - Get all courses
- `POST /api/courses` - Add new course
- `GET /api/attendance` - Get all attendance records
- `POST /api/attendance` - Record attendance

## 🎨 UI Features

- **Tab-based navigation** between Students, Courses, and Attendance
- **Simple forms** for adding data
- **Clean display** of all records
- **Responsive design** for mobile and desktop

## 🚫 What's NOT Included (For Simplicity)

- User authentication
- Complex validation
- Database persistence (uses in-memory storage)
- Advanced search/filtering
- Export functionality
- Blockchain integration in frontend (demo mode only)

## 🔄 Development

- **Backend**: Node.js + Express
- **Frontend**: React (Create React App)
- **Blockchain**: Aptos + Move
- **Storage**: In-memory (for demo)

## 🐛 Troubleshooting

- **Port conflicts**: Change ports in backend/src/index.js and frontend/package.json
- **Dependencies**: Run `npm run install:all` again
- **Move contracts**: Use `npm run compile:contracts` to compile

## 📝 Next Steps

This is a minimal demo. To make it production-ready, consider:
- Adding a real database
- Implementing user authentication
- Connecting frontend to actual blockchain
- Adding more validation and error handling
- Implementing real-time updates

## 🤝 Contributing

Feel free to extend this simple system with additional features!
