module SugoiLogWatcher
  module ParsedObject
    class SQL
      attr_accessor :path, :raw_data, :msec, :pid, :type, :sql

      def initialize(params)
        @raw_data = params[:raw_data]
        @pid = params[:pid]
        @type = params[:type]

        perse!
      end

      def perse!
        if /Load \(.+?ms\)  (.*)$/ =~ @raw_data
          @sql = $1
          @sql = mask(@sql)
        else
          raise "can not perse sql!!(#{@raw_data.codepoints})"
        end
      end

      private

      def mask(s)
        s.gsub(/\b\d+\b/, 'N').
          gsub(/\b0x[0-9A-Fa-f]+\b/, 'N').
          gsub(/''/, "'S'").
          gsub(/""/, '"S"').
          gsub(/(\\')/, '').
          gsub(/(\\")/, '').
          gsub(/'[^']+'/, "'S'").
          gsub(/"[^"]+"/, '"S"').
          gsub(/"[^"]+"/, '"S"')
      end
    end
  end
end
