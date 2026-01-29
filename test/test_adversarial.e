note
	description: "Adversarial and stress tests for simple_physics"
	author: "Larry Rix"

class
	TEST_ADVERSARIAL

inherit
	TEST_SET_BASE

feature -- Tests: Boundary Values

	test_vector_extreme_values
			-- Test vector with extreme floating point values.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (0.0, 0.0, 0.0)
			assert ("zero vector", l_vec.magnitude < 0.0001)

			create l_vec.make (1000000.0, 1000000.0, 1000000.0)
			assert ("large magnitude calculated", l_vec.magnitude > 0.0)
		end

	test_vector_very_small_values
			-- Test vector with very small values.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (0.0000001, 0.0000001, 0.0000001)
			-- Magnitude should be non-negative
			assert ("small magnitude non-negative", l_vec.magnitude >= 0.0)
		end

	test_body_minimal_mass_and_radius
			-- Test body with minimal positive mass and radius.
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.zero
			create l_vel.zero
			create l_body.make (0.00001, 0.00001, l_pos, l_vel)
			assert ("minimal body created", l_body /= Void)
			assert ("mass preserved", l_body.mass = 0.00001)
		end

feature -- Tests: Zero and Identity Operations

	test_vector_zero_operations
			-- Test operations on zero vectors.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.zero
			create l_v2.zero

			l_result := l_v1.add (l_v2)
			assert ("zero plus zero is zero", l_result.magnitude < 0.0001)

			l_result := l_v1.subtract (l_v2)
			assert ("zero minus zero is zero", l_result.magnitude < 0.0001)

			l_result := l_v1.scale (100.0)
			assert ("zero scaled is zero", l_result.magnitude < 0.0001)
		end

	test_dot_product_with_zero
			-- Test dot product involving zero vectors.
		local
			l_v1, l_v2: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.zero
			assert ("dot with zero is zero", (l_v1.dot_product (l_v2)).abs < 0.0001)
		end

	test_cross_product_with_zero
			-- Test cross product involving zero vectors.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.zero
			l_result := l_v1.cross_product (l_v2)
			assert ("cross with zero is zero", l_result.magnitude < 0.0001)
		end

feature -- Tests: Repeated Operations

	test_repeated_additions
			-- Test multiple successive additions.
		local
			l_v1, l_result: VECTOR_3D
			i: INTEGER
		do
			create l_result.zero
			create l_v1.make (0.1, 0.1, 0.1)

			from i := 1 until i > 100 loop
				l_result := l_result.add (l_v1)
				i := i + 1
			end

			-- Result should be approximately (10, 10, 10)
			assert ("repeated addition", (l_result.x - 10.0).abs < 0.1)
		end

	test_repeated_scaling
			-- Test multiple successive scalings.
		local
			l_vec, l_result: VECTOR_3D
			i: INTEGER
		do
			create l_result.make (1.0, 1.0, 1.0)

			from i := 1 until i > 5 loop
				l_result := l_result.scale (2.0)
				i := i + 1
			end

			-- Result should be (32, 32, 32) = 2^5 times original
			assert ("repeated scaling x", (l_result.x - 32.0).abs < 0.0001)
			assert ("repeated scaling y", (l_result.y - 32.0).abs < 0.0001)
		end

	test_repeated_normalizations
			-- Test normalizing multiple times.
		local
			l_vec: VECTOR_3D
			i: INTEGER
		do
			create l_vec.make (3.0, 4.0, 0.0)

			from i := 1 until i > 10 loop
				l_vec := l_vec.normalize
				i := i + 1
			end

			-- Each normalization should yield unit vector (or zero)
			assert ("normalized magnitude near 1", (l_vec.magnitude - 1.0).abs < 0.0001)
		end

feature -- Tests: State Management Stress

	test_world_stress_many_bodies
			-- Test world with many bodies.
		local
			l_gravity, l_pos, l_vel: VECTOR_3D
			l_world: PHYSICS_WORLD
			l_body: PHYSICS_BODY
			i: INTEGER
		do
			create l_gravity.zero
			create l_world.make (l_gravity)

			create l_pos.zero
			create l_vel.zero

			-- Add many bodies
			from i := 1 until i > 100 loop
				create l_body.make (1.0, 0.1, l_pos, l_vel)
				l_world.add_body (l_body)
				i := i + 1
			end

			assert ("100 bodies added", l_world.body_count = 100)
		end

	test_world_add_remove_cycle
			-- Test repeated add/remove operations.
		local
			l_gravity, l_pos, l_vel: VECTOR_3D
			l_world: PHYSICS_WORLD
			l_body: PHYSICS_BODY
			i: INTEGER
		do
			create l_gravity.zero
			create l_world.make (l_gravity)

			create l_pos.zero
			create l_vel.zero
			create l_body.make (1.0, 0.1, l_pos, l_vel)

			-- Add and remove same body repeatedly
			from i := 1 until i > 10 loop
				l_world.add_body (l_body)
				l_world.remove_body (l_body)
				i := i + 1
			end

			assert ("world empty after add/remove cycle", l_world.body_count = 0)
		end

feature -- Tests: Energy Calculations Under Stress

	test_kinetic_energy_high_velocity
			-- Test kinetic energy with very high velocity.
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
			l_ke: REAL_64
		do
			create l_pos.zero
			create l_vel.make (1000.0, 1000.0, 1000.0)
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			l_ke := l_body.kinetic_energy
			assert ("kinetic energy high", l_ke > 1000000.0)
		end

	test_potential_energy_extreme_height
			-- Test potential energy at extreme heights.
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 100000.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			-- PE = 1.0 * 9.8 * 100000 = 980000
			assert ("extreme height PE", (l_body.potential_energy (9.8) - 980000.0).abs < 1.0)
		end

feature -- Tests: Precision and Numerical Stability

	test_magnitude_precision
			-- Test magnitude calculation precision.
		local
			l_vec: VECTOR_3D
			l_mag: REAL_64
		do
			-- 3-4-5 triangle
			create l_vec.make (3.0, 4.0, 0.0)
			l_mag := l_vec.magnitude
			assert ("magnitude 5.0", (l_mag - 5.0).abs < 0.00001)
		end

	test_dot_product_self
			-- Test dot product of vector with itself equals magnitude squared.
		local
			l_vec: VECTOR_3D
			l_dot: REAL_64
			l_mag_sq: REAL_64
		do
			create l_vec.make (2.0, 3.0, 6.0)
			l_dot := l_vec.dot_product (l_vec)
			l_mag_sq := l_vec.magnitude * l_vec.magnitude

			-- Dot product should equal magnitude squared
			assert ("v·v = |v|²", (l_dot - l_mag_sq).abs < 0.00001)
		end

	test_cross_product_magnitude_relationship
			-- Test |a × b| = |a| |b| sin(θ)
		local
			l_v1, l_v2, l_cross: VECTOR_3D
		do
			-- Orthogonal unit vectors: |a × b| should equal 1
			create l_v1.make (1.0, 0.0, 0.0)
			create l_v2.make (0.0, 1.0, 0.0)
			l_cross := l_v1.cross_product (l_v2)

			assert ("cross product magnitude", (l_cross.magnitude - 1.0).abs < 0.0001)
		end

feature -- Tests: Invalid State Transitions

	test_body_position_update_sequence
			-- Test rapid position updates.
		local
			l_pos, l_vel, l_new_pos: VECTOR_3D
			l_body: PHYSICS_BODY
			i: INTEGER
		do
			create l_pos.zero
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			from i := 1 until i > 10 loop
				create l_new_pos.make (1.0 * i, 1.0 * i, 1.0 * i)
				l_body.set_position (l_new_pos)
				i := i + 1
			end

			-- Final position should be (10, 10, 10)
			assert ("final position x", (l_body.position.x - 10.0).abs < 0.0001)
		end

	test_body_velocity_update_sequence
			-- Test rapid velocity updates.
		local
			l_pos, l_vel, l_new_vel: VECTOR_3D
			l_body: PHYSICS_BODY
			i: INTEGER
		do
			create l_pos.zero
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			from i := 1 until i > 20 loop
				create l_new_vel.make (i * 0.5, 0.0, 0.0)
				l_body.set_velocity (l_new_vel)
				i := i + 1
			end

			-- Final velocity x should be 10.0 (20 * 0.5)
			assert ("final velocity x", (l_body.velocity.x - 10.0).abs < 0.0001)
		end

end
