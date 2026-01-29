note
	description: "Impulse-based collision response"
	author: "Larry Rix"

class
	COLLISION_RESOLVER

feature -- Resolution

	resolve_collision (a_collision: COLLISION_INFO): COLLISION_RESULT
			-- Calculate post-collision velocities (elastic).
		require
			collision_not_void: a_collision /= Void
		local
			l_v1_new, l_v2_new: VECTOR_3D
			l_relative_vel: REAL_64
			l_normal: VECTOR_3D
			l_restitution: REAL_64
			l_inv_mass_sum: REAL_64
			l_impulse: REAL_64
			l_impulse_vector: VECTOR_3D
		do
			l_restitution := 0.8  -- 80% bounce (inelastic collision)
			l_normal := a_collision.collision_normal
			l_v1_new := a_collision.body1.velocity
			l_v2_new := a_collision.body2.velocity

			-- Relative velocity along collision normal
			l_relative_vel := l_v2_new.subtract (l_v1_new).dot_product (l_normal)

			-- Only resolve if bodies are approaching (rel_vel < 0)
			if l_relative_vel < 0.0 then
				-- Inverse mass sum (handle infinite mass for static bodies)
				if a_collision.body1.body_type.is_static then
					l_inv_mass_sum := 1.0 / a_collision.body2.mass
				elseif a_collision.body2.body_type.is_static then
					l_inv_mass_sum := 1.0 / a_collision.body1.mass
				else
					l_inv_mass_sum := (1.0 / a_collision.body1.mass) + (1.0 / a_collision.body2.mass)
				end

				-- Impulse magnitude: j = -(1 + e) * v_rel / (1/m1 + 1/m2)
				l_impulse := -(1.0 + l_restitution) * l_relative_vel / l_inv_mass_sum
				l_impulse_vector := l_normal.scale (l_impulse)

				-- Update velocities
				if a_collision.body1.body_type.is_dynamic then
					l_v1_new := l_v1_new.subtract (l_impulse_vector.scale (1.0 / a_collision.body1.mass))
				end

				if a_collision.body2.body_type.is_dynamic then
					l_v2_new := l_v2_new.add (l_impulse_vector.scale (1.0 / a_collision.body2.mass))
				end
			end

			create Result.make (l_v1_new, l_v2_new)  -- body1_velocity_after, body2_velocity_after
		ensure
			result_not_void: Result /= Void
		end

end
