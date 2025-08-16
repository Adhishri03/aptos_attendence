#[test_only]
module student_attendance_system::student_attendance_system_tests {
    use std::signer;
    use std::string;
    use std::vector;
    use aptos_framework::account;
    use aptos_framework::timestamp;

    use student_attendance_system::student_registry;
    use student_attendance_system::course_manager;
    use student_attendance_system::attendance_tracker;

    // Test accounts
    const ADMIN: address = @0x1;
    const STUDENT1: address = @0x2;
    const STUDENT2: address = @0x3;

    fun setup_test(): signer {
        let admin = account::create_account_for_test(ADMIN);
        let student1 = account::create_account_for_test(STUDENT1);
        let student2 = account::create_account_for_test(STUDENT2);

        // Initialize modules
        student_registry::initialize(&admin);
        course_manager::initialize(&admin);
        attendance_tracker::initialize(&admin);

        admin
    }

    #[test]
    fun test_student_registration() {
        let admin = setup_test();
        let student1 = account::create_account_for_test(STUDENT1);

        // Register student
        student_registry::register_student(
            &student1,
            string::utf8(b"STU001"),
            string::utf8(b"John Doe"),
            string::utf8(b"john@example.com"),
            string::utf8(b"Computer Science"),
        );

        // Verify student exists
        assert!(student_registry::student_exists(STUDENT1), 0);
        assert!(student_registry::get_total_students() == 1, 1);
    }

    #[test]
    fun test_course_creation() {
        let admin = setup_test();

        // Create course
        course_manager::create_course(
            &admin,
            string::utf8(b"CS101"),
            string::utf8(b"Introduction to Computer Science"),
            string::utf8(b"Basic programming concepts"),
            30,
        );

        // Verify course exists
        assert!(course_manager::course_exists(&string::utf8(b"CS101")), 0);
        assert!(course_manager::get_total_courses() == 1, 1);
    }

    #[test]
    fun test_attendance_recording() {
        let admin = setup_test();
        let student1 = account::create_account_for_test(STUDENT1);

        // Record attendance
        attendance_tracker::record_attendance(
            &admin,
            STUDENT1,
            string::utf8(b"CS101"),
            true,
        );

        // Verify attendance record
        assert!(attendance_tracker::get_total_records() == 1, 0);
    }
}
