note
	description: "3D immutable vector for physics calculations"
	author: "Larry Rix"

class
	VECTOR_3D

create
	make, zero

feature {NONE} -- Initialization

	make (a_x, a_y, a_z: REAL_64)
			-- Create vector with components (a_x, a_y, a_z).
		do
			x := a_x
			y := a_y
			z := a_z
		ensure
			x_set: x = a_x
			y_set: y = a_y
			z_set: z = a_z
		end

	zero
			-- Create zero vector (0, 0, 0).
		do
			x := 0.0
			y := 0.0
			z := 0.0
		ensure
			is_zero: x = 0.0 and y = 0.0 and z = 0.0
		end

feature -- Access

	x: REAL_64
			-- X component

	y: REAL_64
			-- Y component

	z: REAL_64
			-- Z component

	magnitude: REAL_64
			-- Length of vector: sqrt(x² + y² + z²)
		local
			l_math: SIMPLE_MATH
		do
			create l_math.make
			Result := l_math.sqrt (x * x + y * y + z * z)
		ensure
			non_negative: Result >= 0.0
			zero_for_zero_vector: (x = 0.0 and y = 0.0 and z = 0.0) implies Result = 0.0
		end

feature -- Arithmetic

	add (other: VECTOR_3D): VECTOR_3D
			-- Vector addition: self + other
		require
			other_not_void: other /= Void
		do
			create Result.make (x + other.x, y + other.y, z + other.z)
		ensure
			result_not_void: Result /= Void
			x_correct: Result.x = x + other.x
			y_correct: Result.y = y + other.y
			z_correct: Result.z = z + other.z
		end

	subtract (other: VECTOR_3D): VECTOR_3D
			-- Vector subtraction: self - other
		require
			other_not_void: other /= Void
		do
			create Result.make (x - other.x, y - other.y, z - other.z)
		ensure
			result_not_void: Result /= Void
			x_correct: Result.x = x - other.x
			y_correct: Result.y = y - other.y
			z_correct: Result.z = z - other.z
		end

	scale (scalar: REAL_64): VECTOR_3D
			-- Scalar multiplication: scalar * self
		do
			create Result.make (scalar * x, scalar * y, scalar * z)
		ensure
			result_not_void: Result /= Void
			x_correct: Result.x = scalar * x
			y_correct: Result.y = scalar * y
			z_correct: Result.z = scalar * z
		end

	dot_product (other: VECTOR_3D): REAL_64
			-- Dot product: self · other
		require
			other_not_void: other /= Void
		do
			Result := x * other.x + y * other.y + z * other.z
		ensure
			commutative: Result = other.dot_product (Current)
			orthogonal_zero: (x.abs < 0.0001 or other.x.abs < 0.0001) and (y.abs < 0.0001 or other.y.abs < 0.0001) implies Result.abs < 0.0001
		end

	cross_product (other: VECTOR_3D): VECTOR_3D
			-- Cross product: self × other
		require
			other_not_void: other /= Void
		do
			create Result.make (
				y * other.z - z * other.y,
				z * other.x - x * other.z,
				x * other.y - y * other.x
			)
		ensure
			result_not_void: Result /= Void
			x_correct: Result.x = y * other.z - z * other.y
			y_correct: Result.y = z * other.x - x * other.z
			z_correct: Result.z = x * other.y - y * other.x
			anticommutative: Result.add (other.cross_product (Current)).magnitude < 0.0001
		end

	normalize: VECTOR_3D
			-- Unit vector in direction of self (or zero if magnitude ≈ 0)
		local
			l_mag: REAL_64
		do
			l_mag := magnitude
			if l_mag > 0.0001 then
				Result := scale (1.0 / l_mag)
			else
				create Result.zero
			end
		ensure
			result_not_void: Result /= Void
			magnitude_small_then_zero: magnitude <= 0.0001 implies (Result.x = 0.0 and Result.y = 0.0 and Result.z = 0.0)
			magnitude_large_then_unit: magnitude > 0.0001 implies (Result.magnitude - 1.0 < 0.0001)
		end

invariant
	immutable: True  -- All operations return new vectors

end
