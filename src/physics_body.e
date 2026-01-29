note
	description: "Rigid body state container for physics simulation"
	author: "Larry Rix"

class
	PHYSICS_BODY

create
	make, make_static

feature {NONE} -- Initialization

	make (a_mass, a_radius: REAL_64; a_position, a_velocity: VECTOR_3D)
			-- Create dynamic body with mass, radius, position, velocity.
		require
			positive_mass: a_mass > 0.0
			positive_radius: a_radius > 0.0
			position_not_void: a_position /= Void
			velocity_not_void: a_velocity /= Void
		do
			mass := a_mass
			radius := a_radius
			position := a_position
			velocity := a_velocity
			body_type := create {BODY_TYPE}.make_dynamic
		ensure
			mass_set: mass = a_mass
			radius_set: radius = a_radius
			position_set: position = a_position
			velocity_set: velocity = a_velocity
			is_dynamic: body_type.is_dynamic
		end

	make_static (a_radius: REAL_64; a_position: VECTOR_3D)
			-- Create static body at position with radius.
		require
			positive_radius: a_radius > 0.0
			position_not_void: a_position /= Void
		do
			mass := 1.0  -- Ignored for static bodies
			radius := a_radius
			position := a_position
			create velocity.zero
			body_type := create {BODY_TYPE}.make_static
		ensure
			radius_set: radius = a_radius
			position_set: position = a_position
			is_static: body_type.is_static
		end

feature -- Access

	id: INTEGER
			-- Unique body identifier

	mass: REAL_64
			-- Mass (for dynamic bodies only)

	radius: REAL_64
			-- Collision sphere radius

	position: VECTOR_3D
			-- Current position

	velocity: VECTOR_3D
			-- Current velocity

	body_type: BODY_TYPE
			-- Static or dynamic

feature -- Modification

	set_position (a_position: VECTOR_3D)
			-- Update position.
		require
			position_not_void: a_position /= Void
		do
			position := a_position
		ensure
			position_set: position = a_position
			mass_unchanged: mass = old mass
			radius_unchanged: radius = old radius
		end

	set_velocity (a_velocity: VECTOR_3D)
			-- Update velocity.
		require
			velocity_not_void: a_velocity /= Void
		do
			velocity := a_velocity
		ensure
			velocity_set: velocity = a_velocity
			mass_unchanged: mass = old mass
			radius_unchanged: radius = old radius
		end

feature -- Computed

	kinetic_energy: REAL_64
			-- KE = 0.5 * mass * v²
		do
			if body_type.is_static then
				Result := 0.0
			else
				Result := 0.5 * mass * velocity.magnitude * velocity.magnitude
			end
		ensure
			non_negative: Result >= 0.0
			static_is_zero: body_type.is_static implies Result = 0.0
		end

	potential_energy (gravity: REAL_64): REAL_64
			-- PE = mass * gravity * y
		require
			gravity_non_negative: gravity >= 0.0
		do
			if body_type.is_static then
				Result := 0.0
			else
				Result := mass * gravity * position.y
			end
		ensure
			static_is_zero: body_type.is_static implies Result = 0.0
		end

feature {NONE} -- Implementation

	-- ID assignment uses object_id from ANY class

invariant
	mass_positive: mass > 0.0
	radius_positive: radius > 0.0
	position_not_void: position /= Void
	velocity_not_void: velocity /= Void
	body_type_not_void: body_type /= Void

end
