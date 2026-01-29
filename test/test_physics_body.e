note
	description: "Tests for rigid body physics"
	author: "Larry Rix"

class
	TEST_PHYSICS_BODY

inherit
	TEST_SET_BASE

feature -- Tests: Creation

	test_make_creates_dynamic_body
			-- Test creating a dynamic body.
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (1.0, 2.0, 3.0)
			create l_vel.make (0.1, 0.2, 0.3)
			create l_body.make (10.0, 0.5, l_pos, l_vel)

			assert ("mass set", l_body.mass = 10.0)
			assert ("radius set", l_body.radius = 0.5)
			assert ("position set", l_body.position = l_pos)
			assert ("velocity set", l_body.velocity = l_vel)
			assert ("is dynamic", l_body.body_type.is_dynamic)
		end

	test_make_static_creates_static_body
			-- Test creating a static (immovable) body.
		local
			l_pos: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 5.0, 0.0)
			create l_body.make_static (2.0, l_pos)

			assert ("radius set", l_body.radius = 2.0)
			assert ("position set", l_body.position = l_pos)
			assert ("velocity zero", l_body.velocity.magnitude < 0.0001)
			assert ("is static", l_body.body_type.is_static)
		end

	test_body_creation_multiple
			-- Test that multiple bodies can be created.
		local
			l_pos1, l_pos2, l_vel: VECTOR_3D
			l_body1, l_body2: PHYSICS_BODY
		do
			create l_pos1.make (0.0, 0.0, 0.0)
			create l_pos2.make (1.0, 1.0, 1.0)
			create l_vel.zero
			create l_body1.make (1.0, 0.5, l_pos1, l_vel)
			create l_body2.make (1.0, 0.5, l_pos2, l_vel)

			assert ("first body created", l_body1 /= Void)
			assert ("second body created", l_body2 /= Void)
		end

feature -- Tests: Modification

	test_set_position
			-- Test modifying body position.
		local
			l_pos, l_new_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			create l_new_pos.make (5.0, 5.0, 5.0)
			l_body.set_position (l_new_pos)

			assert ("position updated", l_body.position = l_new_pos)
			assert ("mass unchanged", l_body.mass = 1.0)
			assert ("radius unchanged", l_body.radius = 0.5)
		end

	test_set_velocity
			-- Test modifying body velocity.
		local
			l_pos, l_vel, l_new_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.make (1.0, 1.0, 1.0)
			create l_body.make (2.0, 0.5, l_pos, l_vel)

			create l_new_vel.make (5.0, 0.0, 0.0)
			l_body.set_velocity (l_new_vel)

			assert ("velocity updated", l_body.velocity = l_new_vel)
			assert ("mass unchanged", l_body.mass = 2.0)
			assert ("radius unchanged", l_body.radius = 0.5)
		end

feature -- Tests: Energy

	test_kinetic_energy_dynamic_body
			-- Test kinetic energy calculation: KE = 0.5 * m * v²
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.make (3.0, 4.0, 0.0)  -- magnitude 5.0
			create l_body.make (2.0, 0.5, l_pos, l_vel)

			-- KE = 0.5 * 2.0 * 5.0² = 0.5 * 2.0 * 25.0 = 25.0
			assert ("kinetic energy", (l_body.kinetic_energy - 25.0).abs < 0.0001)
		end

	test_kinetic_energy_static_body
			-- Test that static bodies have zero kinetic energy.
		local
			l_pos: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 0.0, 0.0)
			create l_body.make_static (0.5, l_pos)

			assert ("zero kinetic energy", l_body.kinetic_energy = 0.0)
		end

	test_kinetic_energy_stationary_body
			-- Test kinetic energy of stationary dynamic body.
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			assert ("zero kinetic energy", l_body.kinetic_energy = 0.0)
		end

	test_potential_energy_dynamic_body
			-- Test potential energy: PE = m * g * h
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 10.0, 0.0)
			create l_vel.zero
			create l_body.make (2.0, 0.5, l_pos, l_vel)

			-- PE = 2.0 * 9.8 * 10.0 = 196.0
			assert ("potential energy", (l_body.potential_energy (9.8) - 196.0).abs < 0.1)
		end

	test_potential_energy_static_body
			-- Test that static bodies have zero potential energy.
		local
			l_pos: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, 100.0, 0.0)
			create l_body.make_static (0.5, l_pos)

			assert ("zero potential energy", l_body.potential_energy (9.8) = 0.0)
		end

	test_potential_energy_below_ground
			-- Test potential energy with negative height.
		local
			l_pos, l_vel: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			create l_pos.make (0.0, -5.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			-- PE = 1.0 * 10.0 * (-5.0) = -50.0
			assert ("negative potential energy", (l_body.potential_energy (10.0) - (-50.0)).abs < 0.0001)
		end

end
