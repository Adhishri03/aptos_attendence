module student_attendance_system::course_manager {
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use std::option::{Self, Option};
    use aptos_framework::timestamp;

    /// Error codes
    const ENOT_AUTHORIZED: u64 = 1;
    const ECOURSE_ALREADY_EXISTS: u64 = 2;
    const ECOURSE_NOT_FOUND: u64 = 3;
    const ESTUDENT_NOT_ENROLLED: u64 = 4;
    const ESTUDENT_ALREADY_ENROLLED: u64 = 5;
    const EINVALID_COURSE_CODE: u64 = 6;

    /// Course structure
    struct Course has key, store, drop, init {
        course_code: String,
        course_name: String,
        description: String,
        instructor: address,
        max_students: u64,
        enrolled_students: vector<address>,
        is_active: bool,
        created_at: u64,
        updated_at: u64,
    }

    /// Course enrollment structure
    struct CourseEnrollment has key, store, drop, init {
        course_code: String,
        student_address: address,
        enrollment_date: u64,
        is_active: bool,
    }

    /// Course manager resource
    struct CourseManager has key {
        courses: vector<Course>,
        total_courses: u64,
    }

    /// Initialize the course manager
    public entry fun initialize(account: &signer) {
        let account_addr = signer::address_of(account);
        
        // Only the deployer can initialize
        assert!(account_addr == @student_attendance_system, ENOT_AUTHORIZED);
        
        move_to(account, CourseManager {
            courses: vector::empty(),
            total_courses: 0,
        });
    }

    /// Create a new course
    public entry fun create_course(
        account: &signer,
        course_code: String,
        course_name: String,
        description: String,
        max_students: u64,
    ) {
        let account_addr = signer::address_of(account);
        
        // Check if course already exists
        assert!(!course_exists(&course_code), ECOURSE_ALREADY_EXISTS);
        assert!(string::length(&course_code) > 0, EINVALID_COURSE_CODE);
        assert!(max_students > 0, 7); // EINVALID_MAX_STUDENTS
        
        let current_time = timestamp::now_seconds();
        
        let course = Course {
            course_code,
            course_name,
            description,
            instructor: account_addr,
            max_students,
            enrolled_students: vector::empty(),
            is_active: true,
            created_at: current_time,
            updated_at: current_time,
        };
        
        // Store course in account
        move_to(account, course);
        
        // Update manager
        let manager = borrow_global_mut<CourseManager>(@student_attendance_system);
        vector::push_back(&mut manager.courses, course);
        manager.total_courses = manager.total_courses + 1;
    }

    /// Enroll a student in a course
    public entry fun enroll_student(
        account: &signer,
        course_code: String,
    ) {
        let student_addr = signer::address_of(account);
        
        // Check if course exists
        assert!(course_exists(&course_code), ECOURSE_NOT_FOUND);
        
        // Check if student is already enrolled
        assert!(!is_student_enrolled(student_addr, &course_code), ESTUDENT_ALREADY_ENROLLED);
        
        // Check if course has capacity
        let course = borrow_global_mut<Course>(@student_attendance_system);
        assert!(vector::length(&course.enrolled_students) < course.max_students, 8); // ECOURSE_FULL
        
        // Add student to course
        vector::push_back(&mut course.enrolled_students, student_addr);
        course.updated_at = timestamp::now_seconds();
        
        // Create enrollment record
        let enrollment = CourseEnrollment {
            course_code,
            student_address: student_addr,
            enrollment_date: timestamp::now_seconds(),
            is_active: true,
        };
        
        move_to(account, enrollment);
    }

    /// Unenroll a student from a course
    public entry fun unenroll_student(
        account: &signer,
        course_code: String,
    ) {
        let student_addr = signer::address_of(account);
        
        // Check if course exists
        assert!(course_exists(&course_code), ECOURSE_NOT_FOUND);
        
        // Check if student is enrolled
        assert!(is_student_enrolled(student_addr, &course_code), ESTUDENT_NOT_ENROLLED);
        
        // Remove student from course
        let course = borrow_global_mut<Course>(@student_attendance_system);
        let enrolled_students = &mut course.enrolled_students;
        
        let i = 0;
        let len = vector::length(enrolled_students);
        while (i < len) {
            if (*vector::borrow(enrolled_students, i) == student_addr) {
                vector::remove(enrolled_students, i);
                break
            };
            i = i + 1;
        };
        
        course.updated_at = timestamp::now_seconds();
        
        // Deactivate enrollment record
        let enrollment = borrow_global_mut<CourseEnrollment>(student_addr);
        enrollment.is_active = false;
    }

    /// Get course by code
    public fun get_course(course_code: &String): Course {
        assert!(course_exists(course_code), ECOURSE_NOT_FOUND);
        *borrow_global<Course>(@student_attendance_system)
    }

    /// Check if course exists
    public fun course_exists(course_code: &String): bool {
        exists<Course>(@student_attendance_system)
    }

    /// Check if student is enrolled in a course
    public fun is_student_enrolled(student_addr: address, course_code: &String): bool {
        if (!course_exists(course_code)) {
            return false
        };
        
        let course = borrow_global<Course>(@student_attendance_system);
        let enrolled_students = &course.enrolled_students;
        
        let i = 0;
        let len = vector::length(enrolled_students);
        while (i < len) {
            if (*vector::borrow(enrolled_students, i) == student_addr) {
                return true
            };
            i = i + 1;
        };
        
        false
    }

    /// Get all courses
    public fun get_all_courses(): vector<Course> {
        let manager = borrow_global<CourseManager>(@student_attendance_system);
        *&manager.courses
    }

    /// Get total number of courses
    public fun get_total_courses(): u64 {
        let manager = borrow_global<CourseManager>(@student_attendance_system);
        manager.total_courses
    }

    /// Update course information
    public entry fun update_course(
        account: &signer,
        course_code: String,
        course_name: String,
        description: String,
        max_students: u64,
    ) {
        let account_addr = signer::address_of(account);
        
        // Check if course exists
        assert!(course_exists(&course_code), ECOURSE_NOT_FOUND);
        
        // Only instructor can update course
        let course = borrow_global_mut<Course>(@student_attendance_system);
        assert!(course.instructor == account_addr, ENOT_AUTHORIZED);
        
        course.course_name = course_name;
        course.description = description;
        course.max_students = max_students;
        course.updated_at = timestamp::now_seconds();
    }

    /// Deactivate course
    public entry fun deactivate_course(
        account: &signer,
        course_code: String,
    ) {
        let account_addr = signer::address_of(account);
        
        // Check if course exists
        assert!(course_exists(&course_code), ECOURSE_NOT_FOUND);
        
        // Only instructor can deactivate course
        let course = borrow_global_mut<Course>(@student_attendance_system);
        assert!(course.instructor == account_addr, ENOT_AUTHORIZED);
        
        course.is_active = false;
        course.updated_at = timestamp::now_seconds();
    }
}
