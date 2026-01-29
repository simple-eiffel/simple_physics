note
	description: "Tests for 3D vector operations"
	author: "Larry Rix"

class
	TEST_VECTOR_3D

inherit
	TEST_SET_BASE

feature -- Tests: Creation

	test_make_creates_vector
			-- Test that make creates vector with correct components.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (1.0, 2.0, 3.0)
			assert ("x correct", l_vec.x = 1.0)
			assert ("y correct", l_vec.y = 2.0)
			assert ("z correct", l_vec.z = 3.0)
		end

	test_zero_creates_zero_vector
			-- Test that zero creates zero vector.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.zero
			assert ("x zero", l_vec.x = 0.0)
			assert ("y zero", l_vec.y = 0.0)
			assert ("z zero", l_vec.z = 0.0)
		end

	test_make_with_negative_values
			-- Test creating vector with negative components.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (-1.0, -2.0, -3.0)
			assert ("x correct", l_vec.x = -1.0)
			assert ("y correct", l_vec.y = -2.0)
			assert ("z correct", l_vec.z = -3.0)
		end

feature -- Tests: Magnitude

	test_magnitude_calculation
			-- Test vector magnitude: sqrt(3² + 4² + 0²) = 5
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (3.0, 4.0, 0.0)
			assert ("magnitude is 5", (l_vec.magnitude - 5.0).abs < 0.0001)
		end

	test_magnitude_zero_vector
			-- Test magnitude of zero vector.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.zero
			assert ("magnitude is zero", l_vec.magnitude < 0.0001)
		end

	test_magnitude_unit_vector
			-- Test magnitude of unit vector.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (1.0, 0.0, 0.0)
			assert ("magnitude is 1", (l_vec.magnitude - 1.0).abs < 0.0001)
		end

	test_magnitude_negative_components
			-- Test magnitude with negative components.
		local
			l_vec: VECTOR_3D
		do
			create l_vec.make (-3.0, -4.0, 0.0)
			assert ("magnitude is 5", (l_vec.magnitude - 5.0).abs < 0.0001)
		end

feature -- Tests: Arithmetic

	test_addition
			-- Test vector addition.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.make (4.0, 5.0, 6.0)
			l_result := l_v1.add (l_v2)
			assert ("x sum", l_result.x = 5.0)
			assert ("y sum", l_result.y = 7.0)
			assert ("z sum", l_result.z = 9.0)
		end

	test_addition_with_zero
			-- Test adding zero vector.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.zero
			l_result := l_v1.add (l_v2)
			assert ("unchanged", l_result.x = 1.0 and l_result.y = 2.0 and l_result.z = 3.0)
		end

	test_subtraction
			-- Test vector subtraction.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.make (5.0, 7.0, 9.0)
			create l_v2.make (4.0, 5.0, 6.0)
			l_result := l_v1.subtract (l_v2)
			assert ("x diff", l_result.x = 1.0)
			assert ("y diff", l_result.y = 2.0)
			assert ("z diff", l_result.z = 3.0)
		end

	test_scale
			-- Test scalar multiplication.
		local
			l_vec, l_result: VECTOR_3D
		do
			create l_vec.make (1.0, 2.0, 3.0)
			l_result := l_vec.scale (2.0)
			assert ("x scaled", l_result.x = 2.0)
			assert ("y scaled", l_result.y = 4.0)
			assert ("z scaled", l_result.z = 6.0)
		end

	test_scale_by_zero
			-- Test scalar multiplication by zero.
		local
			l_vec, l_result: VECTOR_3D
		do
			create l_vec.make (1.0, 2.0, 3.0)
			l_result := l_vec.scale (0.0)
			assert ("x zero", l_result.x = 0.0)
			assert ("y zero", l_result.y = 0.0)
			assert ("z zero", l_result.z = 0.0)
		end

	test_scale_by_negative
			-- Test scalar multiplication by negative value.
		local
			l_vec, l_result: VECTOR_3D
		do
			create l_vec.make (1.0, 2.0, 3.0)
			l_result := l_vec.scale (-1.0)
			assert ("x negated", l_result.x = -1.0)
			assert ("y negated", l_result.y = -2.0)
			assert ("z negated", l_result.z = -3.0)
		end

feature -- Tests: Dot Product

	test_dot_product
			-- Test dot product: 1*4 + 2*5 + 3*6 = 32
		local
			l_v1, l_v2: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.make (4.0, 5.0, 6.0)
			assert ("dot product", (l_v1.dot_product (l_v2) - 32.0).abs < 0.0001)
		end

	test_dot_product_orthogonal
			-- Test dot product of orthogonal vectors.
		local
			l_v1, l_v2: VECTOR_3D
		do
			create l_v1.make (1.0, 0.0, 0.0)
			create l_v2.make (0.0, 1.0, 0.0)
			assert ("orthogonal", (l_v1.dot_product (l_v2)).abs < 0.0001)
		end

	test_dot_product_commutativity
			-- Test dot product commutativity: a·b = b·a
		local
			l_v1, l_v2: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.make (4.0, 5.0, 6.0)
			assert ("commutative", (l_v1.dot_product (l_v2) - l_v2.dot_product (l_v1)).abs < 0.0001)
		end

feature -- Tests: Cross Product

	test_cross_product
			-- Test cross product.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.make (1.0, 0.0, 0.0)
			create l_v2.make (0.0, 1.0, 0.0)
			l_result := l_v1.cross_product (l_v2)
			assert ("x component", (l_result.x - 0.0).abs < 0.0001)
			assert ("y component", (l_result.y - 0.0).abs < 0.0001)
			assert ("z component", (l_result.z - 1.0).abs < 0.0001)
		end

	test_cross_product_anticommutativity
			-- Test cross product anticommutativity: a×b = -(b×a)
		local
			l_v1, l_v2, l_cross1, l_cross2: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.make (4.0, 5.0, 6.0)
			l_cross1 := l_v1.cross_product (l_v2)
			l_cross2 := l_v2.cross_product (l_v1)
			assert ("anticommutative",
				((l_cross1.x + l_cross2.x).abs < 0.0001) and
				((l_cross1.y + l_cross2.y).abs < 0.0001) and
				((l_cross1.z + l_cross2.z).abs < 0.0001))
		end

	test_cross_product_parallel_vectors
			-- Test cross product of parallel vectors.
		local
			l_v1, l_v2, l_result: VECTOR_3D
		do
			create l_v1.make (1.0, 2.0, 3.0)
			create l_v2.make (2.0, 4.0, 6.0)
			l_result := l_v1.cross_product (l_v2)
			assert ("zero result", l_result.magnitude < 0.0001)
		end

feature -- Tests: Normalize

	test_normalize
			-- Test vector normalization.
		local
			l_vec, l_result: VECTOR_3D
		do
			create l_vec.make (3.0, 4.0, 0.0)
			l_result := l_vec.normalize
			assert ("magnitude is 1", (l_result.magnitude - 1.0).abs < 0.0001)
		end

	test_normalize_zero_vector
			-- Test normalizing zero vector.
		local
			l_vec, l_result: VECTOR_3D
		do
			create l_vec.zero
			l_result := l_vec.normalize
			assert ("remains zero", l_result.x = 0.0 and l_result.y = 0.0 and l_result.z = 0.0)
		end

	test_normalize_very_small_vector
			-- Test normalizing very small vector (below threshold).
		local
			l_vec, l_result: VECTOR_3D
		do
			create l_vec.make (0.00001, 0.00001, 0.00001)
			l_result := l_vec.normalize
			assert ("small vector becomes zero", l_result.x = 0.0 and l_result.y = 0.0 and l_result.z = 0.0)
		end

end
