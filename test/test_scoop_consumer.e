note
	description: "SCOOP consumer compatibility test for simple_physics"

class TEST_SCOOP_CONSUMER

inherit
	TEST_SET_BASE

feature -- Tests

	test_scoop_compatibility
			-- Verify library types work in SCOOP context.
		local
			l_vector: VECTOR_3D
			l_body: PHYSICS_BODY
		do
			-- Create instances using library's main types
			create l_vector.make (1.0, 2.0, 3.0)
			create l_body.make (1.0, 0.5, create {VECTOR_3D}.make (0.0, 0.0, 0.0), create {VECTOR_3D}.make (0.0, 0.0, 0.0))

			-- Minimal usage to trigger type checking in SCOOP context
			assert ("vector created", l_vector /= Void)
			assert ("body created", l_body /= Void)
		end

end
