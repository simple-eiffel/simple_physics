note
	description: "Post-collision velocity results"
	author: "Larry Rix"

class
	COLLISION_RESULT

create
	make

feature {NONE} -- Initialization

	make (a_v1, a_v2: VECTOR_3D)
			-- Create collision result with new velocities.
		require
			v1_not_void: a_v1 /= Void
			v2_not_void: a_v2 /= Void
		do
			body1_velocity_after := a_v1
			body2_velocity_after := a_v2
		ensure
			v1_set: body1_velocity_after = a_v1
			v2_set: body2_velocity_after = a_v2
		end

feature -- Access

	body1_velocity_after: VECTOR_3D
			-- Body 1 velocity after collision

	body2_velocity_after: VECTOR_3D
			-- Body 2 velocity after collision

invariant
	immutable: True
	v1_not_void: body1_velocity_after /= Void
	v2_not_void: body2_velocity_after /= Void

end
