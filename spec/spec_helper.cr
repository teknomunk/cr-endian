require "spec"
require "../src/endian"

class Array(T)
	def to_slice()
		return Slice(T).new(0,0) if size == 0
		s = Slice(T).new( size, self[0] )
		i = 0
		while i < size
			s[i] = self[i]
			i += 1
		end
		return s
	end
end

class String
	def from_hex()
		self.gsub(/[^0-9A-Fa-f]/,"").hexbytes
	end
end

