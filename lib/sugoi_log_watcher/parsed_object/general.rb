module SugoiLogWatcher
  module ParsedObject
    class General
      attr_accessor :render_path, :request_path, :raw_data, :msec, :pid, :type

      def initialize(params)
        @raw_data = params[:raw_data]
        @pid = params[:pid]
        @type = params[:type]

        perse!
      end

      def perse!
        if type == :start
          %r!Started (?::GET|POST|PATCH) \"([^"]+?)\"! =~ @raw_data
          self.request_path = $1
        end
        %r!Rendered (.+?) \(([0-9.]+?)ms\)! =~ @raw_data
        @render_path = $1
        @msec = $2
      end
    end
  end
end
