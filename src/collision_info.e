note
	description: "Immutable collision information"
	author: "Larry Rix"

class
	COLLISION_INFO

create
	make

feature {NONE} -- Initialization

	make (a_body1, a_body2: PHYSICS_BODY; a_point, a_normal: VECTOR_3D; a_depth: REAL_64)
			-- Create collision information.
		require
			body1_not_void: a_body1 /= Void
			body2_not_void: a_body2 /= Void
			point_not_void: a_point /= Void
			normal_not_void: a_normal /= Void
			depth_non_negative: a_depth >= 0.0
		do
			body1 := a_body1
			body2 := a_body2
			collision_point := a_point
			collision_normal := a_normal
			penetration_depth := a_depth
		ensure
			body1_set: body1 = a_body1
			body2_set: body2 = a_body2
			point_set: collision_point = a_point
			normal_set: collision_normal = a_normal
			depth_set: penetration_depth = a_depth
		end

feature -- Access

	body1: PHYSICS_BODY
			-- First colliding body

	body2: PHYSICS_BODY
			-- Second colliding body

	collision_point: VECTOR_3D
			-- Contact point

	collision_normal: VECTOR_3D
			-- Collision normal (unit vector)

	penetration_depth: REAL_64
			-- How far spheres overlap

invariant
	immutable: True
	bodies_not_void: body1 /= Void and body2 /= Void
	normal_magnitude_near_one: (collision_normal.magnitude - 1.0).abs < 0.1
	depth_non_negative: penetration_depth >= 0.0

end
