module student_attendance_system::attendance_tracker {
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use aptos_framework::timestamp;

    /// Error codes
    const ENOT_AUTHORIZED: u64 = 1;
    const ESTUDENT_NOT_FOUND: u64 = 2;
    const ECOURSE_NOT_FOUND: u64 = 3;
    const EATTENDANCE_ALREADY_RECORDED: u64 = 4;

    /// Attendance record structure
    struct AttendanceRecord has key, store, drop, init {
        student_address: address,
        course_code: String,
        date: u64,
        timestamp: u64,
        is_present: bool,
    }

    /// Attendance tracker resource
    struct AttendanceTracker has key {
        records: vector<AttendanceRecord>,
        total_records: u64,
    }

    /// Initialize the attendance tracker
    public entry fun initialize(account: &signer) {
        let account_addr = signer::address_of(account);
        
        // Only the deployer can initialize
        assert!(account_addr == @student_attendance_system, ENOT_AUTHORIZED);
        
        move_to(account, AttendanceTracker {
            records: vector::empty(),
            total_records: 0,
        });
    }

    /// Record attendance for a student
    public entry fun record_attendance(
        account: &signer,
        student_address: address,
        course_code: String,
        is_present: bool,
    ) {
        let current_time = timestamp::now_seconds();
        
        let attendance_record = AttendanceRecord {
            student_address,
            course_code,
            date: current_time,
            timestamp: current_time,
            is_present,
        };
        
        // Store attendance record
        move_to(account, attendance_record);
        
        // Update tracker
        let tracker = borrow_global_mut<AttendanceTracker>(@student_attendance_system);
        vector::push_back(&mut tracker.records, attendance_record);
        tracker.total_records = tracker.total_records + 1;
    }

    /// Get attendance records for a student
    public fun get_student_attendance(student_address: address): vector<AttendanceRecord> {
        let tracker = borrow_global<AttendanceTracker>(@student_attendance_system);
        let records = &tracker.records;
        let student_records = vector::empty<AttendanceRecord>();
        
        let i = 0;
        let len = vector::length(records);
        while (i < len) {
            let record = vector::borrow(records, i);
            if (record.student_address == student_address) {
                vector::push_back(&mut student_records, *record);
            };
            i = i + 1;
        };
        
        student_records
    }

    /// Get total attendance records
    public fun get_total_records(): u64 {
        let tracker = borrow_global<AttendanceTracker>(@student_attendance_system);
        tracker.total_records
    }

    /// Get all attendance records
    public fun get_all_records(): vector<AttendanceRecord> {
        let tracker = borrow_global<AttendanceTracker>(@student_attendance_system);
        *&tracker.records
    }
}
