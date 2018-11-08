# TODO: Write documentation for `Endian`
module Endian
	VERSION = "0.1.0"
end

{% for i in [16,32,64] %}
	struct BigEndian{{i.id}}
		def initialize( other : Number )
			p = pointerof(@value)
			{% for j in (0...(i/8)) %}
				p.unsafe_as(Pointer(UInt8))[{{j.id}}] = (( other.to_i{{i.id}} >> {{(i-(8*(j+1))).id}} ) & 0xFF).to_u8
			{% end %}
		end
		def to_s( io : IO )
			io.write @value.unsafe_as(StaticArray(UInt8,{{(i/8).id}})).to_slice
		end
		def to_i{{i.id}}()
			p = pointerof(@value)
			{% begin %}
				{% for j in (0...(i/8 - 1)) %}
					( p.unsafe_as(Pointer(UInt8))[{{j.id}}].to_i{{i.id}} << {{ (i-(8*(j+1))).id }}) |
				{% end %}
				( p.unsafe_as(Pointer(UInt8))[{{(i/8 - 1).id}}].to_i{{i.id}} << 0 )
			{% end %}
		end
		{% for j in [8,16,32,64].select {|k| k != i } %}
			def to_i{{j.id}}()
				self.to_i{{i.id}}.to_i{{j.id}}
			end
		{% end %}
		{% for j in [8,16,32,64] %}
			def to_u{{j.id}}()
				self.to_i{{i.id}}.to_u{{j.id}}
			end
		{% end %}

		@value : Int{{i.id}} = 0
	end
{% end %}
