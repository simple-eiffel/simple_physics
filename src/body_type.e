note
	description: "Enumeration for static/dynamic body types"
	author: "Larry Rix"

class
	BODY_TYPE

create
	make_static, make_dynamic

feature {NONE} -- Initialization

	make_static
			-- Create static body type.
		do
			is_static_flag := True
		ensure
			is_static: is_static
			not_dynamic: not is_dynamic
		end

	make_dynamic
			-- Create dynamic body type.
		do
			is_static_flag := False
		ensure
			is_dynamic: is_dynamic
			not_static: not is_static
		end

feature -- Status

	is_static: BOOLEAN
			-- Is this a static (immovable) body?
		do
			Result := is_static_flag
		end

	is_dynamic: BOOLEAN
			-- Is this a dynamic (movable) body?
		do
			Result := not is_static_flag
		end

feature {NONE} -- Implementation

	is_static_flag: BOOLEAN

invariant
	either_static_or_dynamic: is_static xor is_dynamic

end
