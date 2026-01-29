note
	description: "RK4 numerical integration engine"
	author: "Larry Rix"

class
	PHYSICS_INTEGRATOR

feature -- Integration

	rk4_step (a_body: PHYSICS_BODY; a_gravity: VECTOR_3D; dt: REAL_64): PHYSICS_BODY
			-- Perform one RK4 integration step on body.
		require
			body_not_void: a_body /= Void
			gravity_not_void: a_gravity /= Void
			positive_dt: dt > 0.0
			small_dt: dt <= 0.1
		local
			l_result: PHYSICS_BODY
			l_k1, l_k2, l_k3, l_k4: VECTOR_3D
			l_v1, l_v2, l_v3: VECTOR_3D
			l_p1, l_p2, l_p3: VECTOR_3D
			l_new_pos, l_new_vel: VECTOR_3D
		do
			-- RK4 integration for dynamic bodies (static bodies don't move)
			if a_body.body_type.is_dynamic then
				-- k1 = acceleration at t
				l_k1 := a_gravity

				-- k2 = acceleration at t + 0.5*dt
				l_v1 := a_body.velocity.add (l_k1.scale (0.5 * dt))
				l_p1 := a_body.position.add (a_body.velocity.scale (0.5 * dt))
				l_k2 := a_gravity

				-- k3 = acceleration at t + 0.5*dt (different position)
				l_v2 := a_body.velocity.add (l_k2.scale (0.5 * dt))
				l_p2 := a_body.position.add (a_body.velocity.scale (0.5 * dt))
				l_k3 := a_gravity

				-- k4 = acceleration at t + dt
				l_v3 := a_body.velocity.add (l_k3.scale (dt))
				l_p3 := a_body.position.add (a_body.velocity.scale (dt))
				l_k4 := a_gravity

				-- Update position: p_new = p + dt * (v + dt/6 * (k1 + 2*k2 + 2*k3 + k4))
				l_new_pos := a_body.position.add (
					a_body.velocity.scale (dt).add (
						l_k1.add (l_k2.scale (2.0)).add (l_k3.scale (2.0)).add (l_k4).scale (dt / 6.0)
					)
				)

				-- Update velocity: v_new = v + dt/6 * (k1 + 2*k2 + 2*k3 + k4)
				l_new_vel := a_body.velocity.add (
					l_k1.add (l_k2.scale (2.0)).add (l_k3.scale (2.0)).add (l_k4).scale (dt / 6.0)
				)

				create l_result.make (a_body.mass, a_body.radius, l_new_pos, l_new_vel)
			else
				-- Static bodies don't move
				create l_result.make (a_body.mass, a_body.radius, a_body.position, a_body.velocity)
			end

			Result := l_result
		ensure
			result_not_void: Result /= Void
			result_mass: Result.mass = a_body.mass
			result_radius: Result.radius = a_body.radius
		end

end
