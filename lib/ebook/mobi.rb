require_relative 'sectionizer'

module Ebook
  class Mobi

    attr_reader :title, :mobi_type, :text_encoding, :exth

    def initialize(file)
      sections = Sectionizer.new(file, 'rb')
      @header = sections.load_section(0)
      @len_mobi = @header[20..-1].unpack('L>')[0] + 16
    end 

    def exth
      len_exth, = @header[@len_mobi+4..-1].unpack('L>')
      exth_records = @header[@len_mobi..@len_mobi+len_exth][12..-1]
      _exth = {}
      while exth_records.length > 8 do
        rectype, reclen = exth_records.unpack('L>L>')
        recdata = exth_records[8...reclen]
        _exth[rectype] = recdata
        exth_records = exth_records[reclen..-1]
      end
      _exth
    end
    
    def mobi_type
      @header[24..-1].unpack('L>')
    end

    def title
      mobi_raw = @header[0..@len_mobi]
      titleoffset, titlelen = mobi_raw[84..-1].unpack('L>L>')
      @header[titleoffset...titleoffset+titlelen]
    end

    def text_encoding
      @header[28..-1].unpack('L>')
    end

    def type
      exth[501]
    end

    def asin
      exth[113]
    end
  end
end
