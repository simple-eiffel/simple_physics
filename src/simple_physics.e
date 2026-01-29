note
	description: "Facade entry point for physics simulation"
	author: "Larry Rix"

class
	SIMPLE_PHYSICS

create
	make

feature {NONE} -- Initialization

	make
			-- Create physics system with zero gravity.
		do
			gravity := 0.0
			world := Void
		ensure
			gravity_zero: gravity = 0.0
			world_void: world = Void
		end

feature -- Configuration

	set_gravity (a_gravity: REAL_64): like Current
			-- Set gravitational acceleration magnitude (non-negative).
		require
			non_negative: a_gravity >= 0.0
		do
			gravity := a_gravity
			Result := Current
		ensure
			gravity_set: gravity = a_gravity
			result_is_current: Result = Current
		end

	create_world: PHYSICS_WORLD
			-- Create simulation world with configured gravity.
		local
			l_gravity_vector: VECTOR_3D
		do
			create l_gravity_vector.make (0.0, -gravity, 0.0)
			create Result.make (l_gravity_vector)
			world := Result
		ensure
			result_not_void: Result /= Void
			world_set: world /= Void
		end

feature -- Access

	world: detachable PHYSICS_WORLD
			-- Active simulation world (if created)

feature {NONE} -- Implementation

	gravity: REAL_64
			-- Gravitational acceleration magnitude

invariant
	gravity_non_negative: gravity >= 0.0

end
