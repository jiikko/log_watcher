module SugoiLogWatcher
  class LineParser
    def initialize(line)
      @line = line
    end

    def parse
      params = {}
      params[:type] = 
        case
        when /INFO -- : Started/ =~ @line
          :start
        when /Views/ =~ @line && /ActiveRecord/ =~ @line
          :end
        else
          :message
        end

      %r!\#(\d+?)\][^:]+?:   Rendered (.+?) \(([0-9.]+?)ms\)! =~ @line
      pid  = $1
      path = $2
      msec = $3
      PersedObject.new(
        params.merge(pid: pid, path: path, msec: msec)
      )
    end
  end
end
