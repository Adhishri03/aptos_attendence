#!/bin/bash

echo "🚀 Deploying Student Attendance System to Aptos..."

# Navigate to move directory
cd move

# Compile the contracts
echo "📦 Compiling Move contracts..."
aptos move compile

# Run tests
echo "🧪 Running tests..."
aptos move test

# Deploy to local network (for testing)
echo "🌐 Deploying to local network..."
aptos move publish --named-addresses student_attendance_system=default

echo "✅ Deployment complete!"
echo "📋 Contract addresses:"
echo "   - StudentRegistry: deployed"
echo "   - CourseManager: deployed"
echo "   - AttendanceTracker: deployed"

echo ""
echo "🔗 To interact with the contracts, use:"
echo "   aptos move run --function-id default::student_registry::initialize"
echo "   aptos move run --function-id default::course_manager::initialize"
echo "   aptos move run --function-id default::attendance_tracker::initialize"
