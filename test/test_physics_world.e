note
	description: "Tests for physics world"
	author: "Larry Rix"

class
	TEST_PHYSICS_WORLD

inherit
	TEST_SET_BASE

feature -- Tests: Creation

	test_make_creates_empty_world
			-- Test creating a world with given gravity.
		local
			l_gravity: VECTOR_3D
			l_world: PHYSICS_WORLD
		do
			create l_gravity.make (0.0, -9.8, 0.0)
			create l_world.make (l_gravity)

			assert ("gravity set", l_world.gravity = l_gravity)
			assert ("bodies empty", l_world.body_count = 0)
		end

feature -- Tests: Body Management

	test_add_body
			-- Test adding a body to the world.
		local
			l_gravity, l_pos, l_vel: VECTOR_3D
			l_world: PHYSICS_WORLD
			l_body: PHYSICS_BODY
		do
			create l_gravity.make (0.0, -9.8, 0.0)
			create l_world.make (l_gravity)

			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			l_world.add_body (l_body)
			assert ("body added", l_world.body_count = 1)
		end

	test_add_multiple_bodies
			-- Test adding multiple bodies.
		local
			l_gravity, l_pos, l_vel: VECTOR_3D
			l_world: PHYSICS_WORLD
			l_body1, l_body2: PHYSICS_BODY
		do
			create l_gravity.make (0.0, -9.8, 0.0)
			create l_world.make (l_gravity)

			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.zero
			create l_body1.make (1.0, 0.5, l_pos, l_vel)
			create l_body2.make (2.0, 0.5, l_pos, l_vel)

			l_world.add_body (l_body1)
			l_world.add_body (l_body2)

			assert ("two bodies added", l_world.body_count = 2)
		end

	test_remove_body
			-- Test removing a body from the world.
		local
			l_gravity, l_pos, l_vel: VECTOR_3D
			l_world: PHYSICS_WORLD
			l_body: PHYSICS_BODY
		do
			create l_gravity.make (0.0, -9.8, 0.0)
			create l_world.make (l_gravity)

			create l_pos.make (0.0, 0.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)

			l_world.add_body (l_body)
			assert ("body added", l_world.body_count = 1)

			l_world.remove_body (l_body)
			assert ("body removed", l_world.body_count = 0)
		end

feature -- Tests: Gravity

	test_set_gravity
			-- Test updating gravity.
		local
			l_gravity1, l_gravity2: VECTOR_3D
			l_world: PHYSICS_WORLD
		do
			create l_gravity1.make (0.0, -9.8, 0.0)
			create l_world.make (l_gravity1)

			create l_gravity2.make (0.0, -15.0, 0.0)
			l_world.set_gravity (l_gravity2)

			assert ("gravity updated", l_world.gravity = l_gravity2)
		end

feature -- Tests: Integration

	test_integrate_step
			-- Test single integration step.
		local
			l_gravity, l_pos, l_vel: VECTOR_3D
			l_world: PHYSICS_WORLD
			l_body: PHYSICS_BODY
			l_result: PHYSICS_RESULT
		do
			create l_gravity.make (0.0, -9.8, 0.0)
			create l_world.make (l_gravity)

			create l_pos.make (0.0, 10.0, 0.0)
			create l_vel.zero
			create l_body.make (1.0, 0.5, l_pos, l_vel)
			l_world.add_body (l_body)

			l_result := l_world.integrate_step (0.01)
			assert ("result not void", l_result /= Void)
		end

end
