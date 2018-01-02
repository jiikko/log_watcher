module SugoiLogWatcher
  class LineParser
    def initialize(line)
      @line = line
    end

    def parse
      params = {}
      params[:raw_data] = @line
      params[:type] =
        case
        when /INFO -- : Started/ =~ @line
          :start
        when /Completed/ =~ @line
          :end
        else
          :message
        end
      %r!\[(.+?)\s\#(\d+?)\]! =~ @line
      timestamp = $1
      pid = $2

      %r!Rendered (.+?) \(([0-9.]+?)ms\)! =~ @line
      path = $1
      msec = $2
      PersedObject.new(
        params.merge(pid: pid, path: path, msec: msec)
      )
    end
  end
end
