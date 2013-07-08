module KindleCG
  module Ebook
    class Sectionizer

      attr_accessor :file, :header, :sections, :identity

      def initialize(file, perm) 
        @file = File.open(file, perm)
        @header = @file.read(78)
        @sections = split_sections(@header, @file)
      end

      def load_section(section)
        before, after = @sections[section..section+2]
        @file.seek(before)
        @file.read(after - before)
      end

      def identity
        @header[0x3C...0x3C+8]
      end

      private

      def split_sections(header, file)
        num_sections, = header[76..-1].unpack 'S!>'
        raw_sections = file.read(num_sections*8)
        sections_unpacked = raw_sections.unpack ("L>%d" % (num_sections*2))
        sections_unpacked.values_at(*(0..sections_unpacked.size).step(2)).compact + [0xfffffff]
      end
    end
  end
end
