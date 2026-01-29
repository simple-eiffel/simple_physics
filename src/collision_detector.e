note
	description: "Sphere-sphere collision detection"
	author: "Larry Rix"

class
	COLLISION_DETECTOR

feature -- Detection

	detect_collision (a_body1, a_body2: PHYSICS_BODY): detachable COLLISION_INFO
			-- Detect collision between two bodies (Void if no collision).
		require
			body1_not_void: a_body1 /= Void
			body2_not_void: a_body2 /= Void
			different_bodies: a_body1 /= a_body2
		local
			l_delta: VECTOR_3D
			l_distance: REAL_64
			l_collision_sum: REAL_64
			l_contact_point: VECTOR_3D
			l_normal: VECTOR_3D
			l_penetration: REAL_64
		do
			l_delta := a_body2.position.subtract (a_body1.position)
			l_distance := l_delta.magnitude
			l_collision_sum := a_body1.radius + a_body2.radius

			if l_distance < l_collision_sum then
				-- Collision detected: compute contact geometry
				l_penetration := l_collision_sum - l_distance

				if l_distance > 0.0001 then
					-- Normal: unit vector from body1 to body2
					l_normal := l_delta.normalize
				else
					-- Bodies at same position: use default normal
					create l_normal.make (0.0, 1.0, 0.0)
				end

				-- Contact point: midpoint between surface contact points
				l_contact_point := a_body1.position.add (l_normal.scale (a_body1.radius))

				create Result.make (a_body1, a_body2, l_contact_point, l_normal, l_penetration)
			else
				Result := Void
			end
		end

	detect_all_collisions (a_bodies: LIST [PHYSICS_BODY]): LIST [COLLISION_INFO]
			-- Detect all collisions in body list (O(n²) broad phase).
		require
			bodies_not_void: a_bodies /= Void
		local
			l_collisions: ARRAYED_LIST [COLLISION_INFO]
			l_collision: detachable COLLISION_INFO
			l_i, l_j: INTEGER
		do
			create l_collisions.make (0)

			-- O(n²) pairwise collision detection
			from l_i := 1 until l_i > a_bodies.count loop
				from l_j := l_i + 1 until l_j > a_bodies.count loop
					-- Check each pair once (i < j)
					l_collision := detect_collision (a_bodies.at (l_i), a_bodies.at (l_j))
					if l_collision /= Void then
						l_collisions.extend (l_collision)
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end

			Result := l_collisions
		ensure
			result_not_void: Result /= Void
		end

end
