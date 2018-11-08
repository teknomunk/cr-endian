require "./spec_helper"

lib C
	struct Example
		src : StaticArray(UInt8,6)
		dst : StaticArray(UInt8,6)
		value : Int16
	end
end

describe Endian do
  # TODO: Write tests
	describe BigEndian16 do
		it "is no larger than the base type" do
			sizeof(BigEndian16).should eq(2)
			sizeof(BigEndian32).should eq(4)
			sizeof(BigEndian64).should eq(8)
		end
		it "Sets correctly" do
			be1 = BigEndian16.new(15)

			io = IO::Memory.new()
			io << be1
			io.to_slice.should eq([0_u8,15_u8].to_slice)
		end
		it "Converts types correctly" do
			be1 = BigEndian32.new(50000)
			be1.to_i32.should eq(50000)
			be1.to_i16.should eq(-15536_i16)
			be1.to_i64.should eq(50000_i64)
			be1.to_i8.should eq(80_i8)
			be1.to_u32.should eq(50000_u32)
			be1.to_u16.should eq(50000_u16)
			be1.to_u64.should eq(50000_u64)
			be1.to_u8.should eq(80_u8)
		end
		it "Works in binding structures" do
			example_ptr = "01:23:45:67:89:AB 10:32:54:76:98:BA 0100".gsub(/[^0-9A-Fa-f]/,"").hexbytes.to_unsafe.unsafe_as(Pointer(C::Example))

			# This is very ugly
			puts example_ptr.value
			example_ptr.value.unsafe_as(BigEndian16).to_u16.should eq(256_u16)
		end
	end
end
