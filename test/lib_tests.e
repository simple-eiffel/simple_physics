note
	description: "Main test suite for simple_physics library"
	author: "Larry Rix"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test Suite Groups

	test_all
			-- Run all test suites.
		do
			test_vectors
			test_bodies
			test_world
		end

feature -- Vector Tests

	test_vectors
			-- Test VECTOR_3D operations.
		local
			l_tests: TEST_VECTOR_3D
		do
			create l_tests
			l_tests.test_make_creates_vector
			l_tests.test_zero_creates_zero_vector
			l_tests.test_make_with_negative_values
			l_tests.test_magnitude_calculation
			l_tests.test_magnitude_zero_vector
			l_tests.test_magnitude_unit_vector
			l_tests.test_magnitude_negative_components
			l_tests.test_addition
			l_tests.test_addition_with_zero
			l_tests.test_subtraction
			l_tests.test_scale
			l_tests.test_scale_by_zero
			l_tests.test_scale_by_negative
			l_tests.test_dot_product
			l_tests.test_dot_product_orthogonal
			l_tests.test_dot_product_commutativity
			l_tests.test_cross_product
			l_tests.test_cross_product_anticommutativity
			l_tests.test_cross_product_parallel_vectors
			l_tests.test_normalize
			l_tests.test_normalize_zero_vector
			l_tests.test_normalize_very_small_vector
		end

feature -- Body Tests

	test_bodies
			-- Test PHYSICS_BODY operations.
		local
			l_tests: TEST_PHYSICS_BODY
		do
			create l_tests
			l_tests.test_make_creates_dynamic_body
			l_tests.test_make_static_creates_static_body
			l_tests.test_body_creation_multiple
			l_tests.test_set_position
			l_tests.test_set_velocity
			l_tests.test_kinetic_energy_dynamic_body
			l_tests.test_kinetic_energy_static_body
			l_tests.test_kinetic_energy_stationary_body
			l_tests.test_potential_energy_dynamic_body
			l_tests.test_potential_energy_static_body
			l_tests.test_potential_energy_below_ground
		end

feature -- World Tests

	test_world
			-- Test PHYSICS_WORLD and SIMPLE_PHYSICS.
		local
			l_world_tests: TEST_PHYSICS_WORLD
			l_physics_tests: TEST_SIMPLE_PHYSICS
		do
			create l_world_tests
			l_world_tests.test_make_creates_empty_world
			l_world_tests.test_add_body
			l_world_tests.test_add_multiple_bodies
			l_world_tests.test_remove_body
			l_world_tests.test_set_gravity
			l_world_tests.test_integrate_step

			create l_physics_tests
			l_physics_tests.test_make_initializes_zero_gravity
			l_physics_tests.test_set_gravity
			l_physics_tests.test_set_gravity_fluent_chaining
			l_physics_tests.test_create_world
			l_physics_tests.test_create_world_with_zero_gravity
		end

end
