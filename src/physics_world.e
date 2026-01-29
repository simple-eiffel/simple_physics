note
	description: "Physics world orchestrator managing bodies and simulation"
	author: "Larry Rix"

class
	PHYSICS_WORLD

create
	make

feature {NONE} -- Initialization

	make (a_gravity: VECTOR_3D)
			-- Create world with given gravity vector.
		require
			gravity_not_void: a_gravity /= Void
		do
			gravity := a_gravity
			create bodies.make (0)
		ensure
			gravity_set: gravity = a_gravity
			bodies_empty: bodies.count = 0
		end

feature -- Access

	gravity: VECTOR_3D
			-- Gravitational acceleration vector

	bodies: ARRAYED_LIST [PHYSICS_BODY]
			-- All bodies in simulation

	body_count: INTEGER
			-- Number of bodies
		do
			Result := bodies.count
		ensure
			non_negative: Result >= 0
		end

	last_collisions: detachable LIST [COLLISION_INFO]
			-- Last detected collisions (if any)

feature -- Body Management

	add_body (a_body: PHYSICS_BODY)
			-- Add body to simulation.
		require
			body_not_void: a_body /= Void
		do
			bodies.extend (a_body)
		ensure
			body_added: bodies.count = old bodies.count + 1
		end

	remove_body (a_body: PHYSICS_BODY)
			-- Remove body from simulation.
		require
			body_not_void: a_body /= Void
		do
			bodies.prune_all (a_body)
		ensure
			body_removed: bodies.count = old bodies.count - 1
		end

feature -- Simulation

	set_gravity (a_gravity: VECTOR_3D)
			-- Update gravity vector.
		require
			gravity_not_void: a_gravity /= Void
		do
			gravity := a_gravity
		ensure
			gravity_set: gravity = a_gravity
		end

	integrate_step (dt: REAL_64): PHYSICS_RESULT
			-- Integrate one time step and return results.
		require
			positive_dt: dt > 0.0
		local
			l_result: PHYSICS_RESULT
			l_integrator: PHYSICS_INTEGRATOR
			l_detector: COLLISION_DETECTOR
			l_resolver: COLLISION_RESOLVER
			l_updated_bodies: ARRAYED_LIST [PHYSICS_BODY]
			l_collisions: LIST [COLLISION_INFO]
			l_collision_result: COLLISION_RESULT
			l_total_ke: REAL_64
			l_total_pe: REAL_64
			l_gravity_magnitude: REAL_64
			i: INTEGER
		do
			-- Create integrator and detector
			create l_integrator
			create l_detector
			create l_resolver

			-- Step 1: Integrate all bodies
			create l_updated_bodies.make (0)
			from i := 1 until i > bodies.count loop
				l_updated_bodies.extend (
					l_integrator.rk4_step (bodies.at (i), gravity, dt)
				)
				i := i + 1
			end

			-- Step 2: Detect collisions
			l_collisions := l_detector.detect_all_collisions (l_updated_bodies)

			-- Step 3: Resolve collisions and update velocities in bodies
			from i := 1 until i > l_collisions.count loop
				l_collision_result := l_resolver.resolve_collision (l_collisions.at (i))

				-- Update body velocities post-collision
				l_updated_bodies.at (1).set_velocity (l_collision_result.body1_velocity_after)
				l_updated_bodies.at (2).set_velocity (l_collision_result.body2_velocity_after)

				i := i + 1
			end

			-- Step 4: Calculate total energy
			l_total_ke := 0.0
			l_total_pe := 0.0
			l_gravity_magnitude := gravity.magnitude

			from i := 1 until i > l_updated_bodies.count loop
				l_total_ke := l_total_ke + l_updated_bodies.at (i).kinetic_energy
				l_total_pe := l_total_pe + l_updated_bodies.at (i).potential_energy (l_gravity_magnitude)
				i := i + 1
			end

			-- Step 5: Update world bodies and return result
			bodies := l_updated_bodies
			create l_result.make (l_updated_bodies, l_collisions, l_total_ke, l_total_pe, dt)
			Result := l_result
		ensure
			result_not_void: Result /= Void
		end

invariant
	gravity_not_void: gravity /= Void
	bodies_not_void: bodies /= Void

end
