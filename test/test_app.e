note
	description: "Test application runner"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run all tests.
		do
			print ("Running simple_physics test suite...%N%N")
			passed := 0
			failed := 0

			run_vector_tests
			run_body_tests
			run_world_tests
			run_adversarial_tests

			print_summary
		end

feature {NONE} -- Test Runners

	run_vector_tests
			-- Run VECTOR_3D test suite.
		local
			l_tests: TEST_VECTOR_3D
		do
			print ("VECTOR_3D Tests%N")
			print ("===============%N")
			create l_tests
			run_test (agent l_tests.test_make_creates_vector, "test_make_creates_vector")
			run_test (agent l_tests.test_zero_creates_zero_vector, "test_zero_creates_zero_vector")
			run_test (agent l_tests.test_make_with_negative_values, "test_make_with_negative_values")
			run_test (agent l_tests.test_magnitude_calculation, "test_magnitude_calculation")
			run_test (agent l_tests.test_magnitude_zero_vector, "test_magnitude_zero_vector")
			run_test (agent l_tests.test_magnitude_unit_vector, "test_magnitude_unit_vector")
			run_test (agent l_tests.test_magnitude_negative_components, "test_magnitude_negative_components")
			run_test (agent l_tests.test_addition, "test_addition")
			run_test (agent l_tests.test_addition_with_zero, "test_addition_with_zero")
			run_test (agent l_tests.test_subtraction, "test_subtraction")
			run_test (agent l_tests.test_scale, "test_scale")
			run_test (agent l_tests.test_scale_by_zero, "test_scale_by_zero")
			run_test (agent l_tests.test_scale_by_negative, "test_scale_by_negative")
			run_test (agent l_tests.test_dot_product, "test_dot_product")
			run_test (agent l_tests.test_dot_product_orthogonal, "test_dot_product_orthogonal")
			run_test (agent l_tests.test_dot_product_commutativity, "test_dot_product_commutativity")
			run_test (agent l_tests.test_cross_product, "test_cross_product")
			run_test (agent l_tests.test_cross_product_anticommutativity, "test_cross_product_anticommutativity")
			run_test (agent l_tests.test_cross_product_parallel_vectors, "test_cross_product_parallel_vectors")
			run_test (agent l_tests.test_normalize, "test_normalize")
			run_test (agent l_tests.test_normalize_zero_vector, "test_normalize_zero_vector")
			run_test (agent l_tests.test_normalize_very_small_vector, "test_normalize_very_small_vector")
			print ("%N")
		end

	run_body_tests
			-- Run PHYSICS_BODY test suite.
		local
			l_tests: TEST_PHYSICS_BODY
		do
			print ("PHYSICS_BODY Tests%N")
			print ("==================%N")
			create l_tests
			run_test (agent l_tests.test_make_creates_dynamic_body, "test_make_creates_dynamic_body")
			run_test (agent l_tests.test_make_static_creates_static_body, "test_make_static_creates_static_body")
			run_test (agent l_tests.test_body_creation_multiple, "test_body_creation_multiple")
			run_test (agent l_tests.test_set_position, "test_set_position")
			run_test (agent l_tests.test_set_velocity, "test_set_velocity")
			run_test (agent l_tests.test_kinetic_energy_dynamic_body, "test_kinetic_energy_dynamic_body")
			run_test (agent l_tests.test_kinetic_energy_static_body, "test_kinetic_energy_static_body")
			run_test (agent l_tests.test_kinetic_energy_stationary_body, "test_kinetic_energy_stationary_body")
			run_test (agent l_tests.test_potential_energy_dynamic_body, "test_potential_energy_dynamic_body")
			run_test (agent l_tests.test_potential_energy_static_body, "test_potential_energy_static_body")
			run_test (agent l_tests.test_potential_energy_below_ground, "test_potential_energy_below_ground")
			print ("%N")
		end

	run_world_tests
			-- Run SIMPLE_PHYSICS and PHYSICS_WORLD test suites.
		local
			l_physics_tests: TEST_SIMPLE_PHYSICS
			l_world_tests: TEST_PHYSICS_WORLD
		do
			print ("SIMPLE_PHYSICS Tests%N")
			print ("====================%N")
			create l_physics_tests
			run_test (agent l_physics_tests.test_make_initializes_zero_gravity, "test_make_initializes_zero_gravity")
			run_test (agent l_physics_tests.test_set_gravity, "test_set_gravity")
			run_test (agent l_physics_tests.test_set_gravity_fluent_chaining, "test_set_gravity_fluent_chaining")
			run_test (agent l_physics_tests.test_create_world, "test_create_world")
			run_test (agent l_physics_tests.test_create_world_with_zero_gravity, "test_create_world_with_zero_gravity")
			print ("%N")

			print ("PHYSICS_WORLD Tests%N")
			print ("====================%N")
			create l_world_tests
			run_test (agent l_world_tests.test_make_creates_empty_world, "test_make_creates_empty_world")
			run_test (agent l_world_tests.test_add_body, "test_add_body")
			run_test (agent l_world_tests.test_add_multiple_bodies, "test_add_multiple_bodies")
			run_test (agent l_world_tests.test_remove_body, "test_remove_body")
			run_test (agent l_world_tests.test_set_gravity, "test_set_gravity")
			run_test (agent l_world_tests.test_integrate_step, "test_integrate_step")
			print ("%N")
		end

	run_adversarial_tests
			-- Run adversarial and stress tests.
		local
			l_tests: TEST_ADVERSARIAL
		do
			print ("ADVERSARIAL & STRESS Tests%N")
			print ("==========================%N")
			create l_tests
			run_test (agent l_tests.test_vector_extreme_values, "test_vector_extreme_values")
			run_test (agent l_tests.test_vector_very_small_values, "test_vector_very_small_values")
			run_test (agent l_tests.test_body_minimal_mass_and_radius, "test_body_minimal_mass_and_radius")
			run_test (agent l_tests.test_vector_zero_operations, "test_vector_zero_operations")
			run_test (agent l_tests.test_dot_product_with_zero, "test_dot_product_with_zero")
			run_test (agent l_tests.test_cross_product_with_zero, "test_cross_product_with_zero")
			run_test (agent l_tests.test_repeated_additions, "test_repeated_additions")
			run_test (agent l_tests.test_repeated_scaling, "test_repeated_scaling")
			run_test (agent l_tests.test_repeated_normalizations, "test_repeated_normalizations")
			run_test (agent l_tests.test_world_stress_many_bodies, "test_world_stress_many_bodies")
			run_test (agent l_tests.test_world_add_remove_cycle, "test_world_add_remove_cycle")
			run_test (agent l_tests.test_kinetic_energy_high_velocity, "test_kinetic_energy_high_velocity")
			run_test (agent l_tests.test_potential_energy_extreme_height, "test_potential_energy_extreme_height")
			run_test (agent l_tests.test_magnitude_precision, "test_magnitude_precision")
			run_test (agent l_tests.test_dot_product_self, "test_dot_product_self")
			run_test (agent l_tests.test_cross_product_magnitude_relationship, "test_cross_product_magnitude_relationship")
			run_test (agent l_tests.test_body_position_update_sequence, "test_body_position_update_sequence")
			run_test (agent l_tests.test_body_velocity_update_sequence, "test_body_velocity_update_sequence")
			print ("%N")
		end

feature {NONE} -- Test Execution

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Execute a single test with error handling.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

	print_summary
			-- Print test results summary.
		do
			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")
			print ("Total: " + (passed + failed).out + " tests%N")
			print ("========================%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER

end
