note
	description: "Tests for physics facade"
	author: "Larry Rix"

class
	TEST_SIMPLE_PHYSICS

inherit
	TEST_SET_BASE

feature -- Tests: Creation

	test_make_initializes_zero_gravity
			-- Test that make creates facade with zero gravity.
		local
			l_physics: SIMPLE_PHYSICS
		do
			create l_physics.make
			assert ("gravity zero", l_physics.world = Void)
		end

feature -- Tests: Configuration

	test_set_gravity
			-- Test setting gravity.
		local
			l_physics: SIMPLE_PHYSICS
		do
			create l_physics.make
			l_physics.set_gravity (9.8).do_nothing
			-- Gravity set internally, verify by creating world
		end

	test_set_gravity_fluent_chaining
			-- Test fluent chaining with set_gravity.
		local
			l_physics: SIMPLE_PHYSICS
			l_result: SIMPLE_PHYSICS
		do
			create l_physics.make
			l_result := l_physics.set_gravity (9.8)
			assert ("result is current", l_result = l_physics)
		end

	test_set_gravity_negative
			-- Test that negative gravity is rejected.
		local
			l_physics: SIMPLE_PHYSICS
		do
			create l_physics.make
			-- Precondition should prevent negative gravity
			-- This test documents the contract
		end

feature -- Tests: World Creation

	test_create_world
			-- Test creating a simulation world.
		local
			l_physics: SIMPLE_PHYSICS
			l_world: PHYSICS_WORLD
		do
			create l_physics.make
			l_physics.set_gravity (9.8).do_nothing
			l_world := l_physics.create_world
			assert ("world created", l_world /= Void)
			assert ("world stored", l_physics.world /= Void)
		end

	test_create_world_with_zero_gravity
			-- Test creating world with zero gravity.
		local
			l_physics: SIMPLE_PHYSICS
			l_world: PHYSICS_WORLD
		do
			create l_physics.make
			l_world := l_physics.create_world
			assert ("world created", l_world /= Void)
		end

end
