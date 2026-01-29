note
	description: "Immutable simulation step results (SCOOP-safe)"
	author: "Larry Rix"

class
	PHYSICS_RESULT

create
	make

feature {NONE} -- Initialization

	make (a_bodies: LIST [PHYSICS_BODY]; a_collisions: LIST [COLLISION_INFO]; a_ke, a_pe, a_dt: REAL_64)
			-- Create simulation result.
		require
			bodies_not_void: a_bodies /= Void
			collisions_not_void: a_collisions /= Void
			time_positive: a_dt > 0.0
		do
			bodies := a_bodies
			collisions := a_collisions
			total_kinetic_energy := a_ke
			total_potential_energy := a_pe
			step_time := a_dt
		ensure
			bodies_set: bodies = a_bodies
			collisions_set: collisions = a_collisions
			ke_set: total_kinetic_energy = a_ke
			pe_set: total_potential_energy = a_pe
			dt_set: step_time = a_dt
		end

feature -- Access

	bodies: LIST [PHYSICS_BODY]
			-- All bodies after step

	collisions: LIST [COLLISION_INFO]
			-- Detected collisions

	total_kinetic_energy: REAL_64
			-- Sum of all kinetic energies

	total_potential_energy: REAL_64
			-- Sum of all potential energies

	step_time: REAL_64
			-- Time step taken

invariant
	immutable: True
	bodies_not_void: bodies /= Void
	collisions_not_void: collisions /= Void
	energies_non_negative: total_kinetic_energy >= 0.0 and total_potential_energy >= 0.0

end
