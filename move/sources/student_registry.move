module student_attendance_system::student_registry {
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use aptos_framework::account;
    use aptos_framework::timestamp;

    /// Error codes
    const ENOT_AUTHORIZED: u64 = 1;
    const ESTUDENT_ALREADY_EXISTS: u64 = 2;
    const ESTUDENT_NOT_FOUND: u64 = 3;
    const EINVALID_STUDENT_ID: u64 = 4;

    /// Student profile structure
    struct StudentProfile has key, store, drop, init {
        student_id: String,
        name: String,
        email: String,
        department: String,
        enrollment_date: u64,
        is_active: bool,
        created_at: u64,
        updated_at: u64,
    }

    /// Student registry resource
    struct StudentRegistry has key {
        students: vector<address>,
        student_profiles: vector<StudentProfile>,
        total_students: u64,
    }

    /// Initialize the student registry
    public entry fun initialize(account: &signer) {
        let account_addr = signer::address_of(account);
        
        // Only the deployer can initialize
        assert!(account_addr == @student_attendance_system, ENOT_AUTHORIZED);
        
        move_to(account, StudentRegistry {
            students: vector::empty(),
            student_profiles: vector::empty(),
            total_students: 0,
        });
    }

    /// Register a new student
    public entry fun register_student(
        account: &signer,
        student_id: String,
        name: String,
        email: String,
        department: String,
    ) {
        let account_addr = signer::address_of(account);
        
        // Check if student already exists
        assert!(!student_exists(account_addr), ESTUDENT_ALREADY_EXISTS);
        assert!(string::length(&student_id) > 0, EINVALID_STUDENT_ID);
        
        let current_time = timestamp::now_seconds();
        
        let student_profile = StudentProfile {
            student_id,
            name,
            email,
            department,
            enrollment_date: current_time,
            is_active: true,
            created_at: current_time,
            updated_at: current_time,
        };
        
        // Store profile in account
        move_to(account, student_profile);
        
        // Update registry
        let registry = borrow_global_mut<StudentRegistry>(@student_attendance_system);
        vector::push_back(&mut registry.students, account_addr);
        vector::push_back(&mut registry.student_profiles, student_profile);
        registry.total_students = registry.total_students + 1;
    }

    /// Get student profile by address
    public fun get_student_profile(student_addr: address): StudentProfile {
        assert!(student_exists(student_addr), ESTUDENT_NOT_FOUND);
        *borrow_global<StudentProfile>(student_addr)
    }

    /// Check if student exists
    public fun student_exists(student_addr: address): bool {
        exists<StudentProfile>(student_addr)
    }

    /// Get total number of students
    public fun get_total_students(): u64 {
        let registry = borrow_global<StudentRegistry>(@student_attendance_system);
        registry.total_students
    }

    /// Update student profile
    public entry fun update_student_profile(
        account: &signer,
        name: String,
        email: String,
        department: String,
    ) {
        let account_addr = signer::address_of(account);
        assert!(student_exists(account_addr), ESTUDENT_NOT_FOUND);
        
        let profile = borrow_global_mut<StudentProfile>(account_addr);
        profile.name = name;
        profile.email = email;
        profile.department = department;
        profile.updated_at = timestamp::now_seconds();
    }

    /// Deactivate student account
    public entry fun deactivate_student(account: &signer) {
        let account_addr = signer::address_of(account);
        assert!(student_exists(account_addr), ESTUDENT_NOT_FOUND);
        
        let profile = borrow_global_mut<StudentProfile>(account_addr);
        profile.is_active = false;
        profile.updated_at = timestamp::now_seconds();
    }

    /// Reactivate student account
    public entry fun reactivate_student(account: &signer) {
        let account_addr = signer::address_of(account);
        assert!(student_exists(account_addr), ESTUDENT_NOT_FOUND);
        
        let profile = borrow_global_mut<StudentProfile>(account_addr);
        profile.is_active = true;
        profile.updated_at = timestamp::now_seconds();
    }

    /// Get all student addresses
    public fun get_all_students(): vector<address> {
        let registry = borrow_global<StudentRegistry>(@student_attendance_system);
        *&registry.students
    }

    /// Get all student profiles
    public fun get_all_student_profiles(): vector<StudentProfile> {
        let registry = borrow_global<StudentRegistry>(@student_attendance_system);
        *&registry.student_profiles
    }
}
